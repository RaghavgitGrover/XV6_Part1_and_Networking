#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct proc* mlfq[4][NPROC];  
int queue_size[4] = {0, 0, 0, 0};  
int global_ticks = 0;

struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;

extern void forkret(void);
static void freeproc(struct proc *p);

extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table.
void procinit(void)
{
  struct proc *p;

  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  for (p = proc; p < &proc[NPROC]; p++)
  {
    initlock(&p->lock, "proc");
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
  }

  #ifdef MLFQ
  for (int i = 0; i < 4; i++) {
    queue_size[i] = 0;
    for (int j = 0; j < NPROC; j++) {
      mlfq[i][j] = 0;
    }
  }
  #endif
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

int allocpid()
{
  int pid;

  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->state == UNUSED)
    {
      goto found;
    }
    else
    {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

  // Allocate a trapframe page.
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
  {
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if (p->pagetable == 0)
  {
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;
  p->rtime = 0;
  p->etime = 0;
  p->ctime = ticks;
  p->tickets = 1;

  memset(p->syscalls, 0, sizeof(p->syscalls));

  memset(&p->ticks_count, 0, sizeof(p->ticks_count));
  memset(&p->alarm_on, 0, sizeof(p->alarm_on));
  memset(&p->alarm_interval, 0, sizeof(p->alarm_interval));
  memset(&p->alarm_handler, 0, sizeof(p->alarm_handler));
  memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));

  #ifdef MLFQ
  p->mlfq_priority = 0;  // Start in highest priority queue
  p->time_slice = 1;     // Initial time slice
  p->mlfq_ticks = 0;
  p->total_ticks = 0;
  
  enqueue(p, 0); 
  #endif
  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if (p->trapframe)
    kfree((void *)p->trapframe);
  p->trapframe = 0;
  if (p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  if (p->alarm_trapframe) 
    kfree((void *)p->alarm_trapframe);
  memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if (pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if (mappages(pagetable, TRAMPOLINE, PGSIZE,
               (uint64)trampoline, PTE_R | PTE_X) < 0)
  {
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if (mappages(pagetable, TRAPFRAME, PGSIZE,
               (uint64)(p->trapframe), PTE_R | PTE_W) < 0)
  {
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// a user program that calls exec("/init")
// assembled from ../user/initcode.S
// od -t xC ../user/initcode
uchar initcode[] = {
    0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
    0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
    0x93, 0x08, 0x70, 0x00, 0x73, 0x00, 0x00, 0x00,
    0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
    0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
    0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00};

// Set up first user process.
void userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;

  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;     // user program counter
  p->trapframe->sp = PGSIZE; // user stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n)
{
  uint64 sz;
  struct proc *p = myproc();

  sz = p->sz;
  if (n > 0)
  {
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    {
      return -1;
    }
  }
  else if (n < 0)
  {
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0)
  {
    return -1;
  }

  // Copy user memory from parent to child.
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
  {
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  np->tickets = p->tickets;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for (i = 0; i < NOFILE; i++)
    if (p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;
  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void reparent(struct proc *p)
{
  struct proc *pp;

  for (pp = proc; pp < &proc[NPROC]; pp++)
  {
    if (pp->parent == p)
    {
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

int
getsyscount(int mask)
{
  struct proc *p = myproc();
  int index = get_syscall_index(mask);
  if (index == -1) {
    // printf("Debug: Invalid mask %d in getsyscount\n", mask);
    return -1;
  }
  // printf("Debug: Counting syscall %d for PID %d\n", index, p->pid);
  // printf("Debug: Count for syscall %d: %d\n", index, p->syscall_count[index]);
  return p->syscalls[index];
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
// void exit(int status)
// {
//   struct proc *p = myproc();

//   if (p == initproc)
//     panic("init exiting");

//   // Close all open files.
//   for (int fd = 0; fd < NOFILE; fd++)
//   {
//     if (p->ofile[fd])
//     {
//       struct file *f = p->ofile[fd];
//       fileclose(f);
//       p->ofile[fd] = 0;
//     }
//   }

//   if(p->parent) {
//     acquire(&p->parent->lock);
//     for (int i = 0; i < 32; i++) p->parent->syscalls[i] += p->syscalls[i];
//     release(&p->parent->lock);
//   }

//   begin_op();
//   iput(p->cwd);
//   end_op();
//   p->cwd = 0;

//   acquire(&wait_lock);

//   // Give any children to init.
//   reparent(p);

//   // Parent might be sleeping in wait().
//   wakeup(p->parent);

//   acquire(&p->lock);

//   p->xstate = status;
//   p->state = ZOMBIE;
//   p->etime = ticks;

//   release(&wait_lock);

//   // Jump into the scheduler, never to return.
//   sched();
//   panic("zombie exit");
// }

void exit(int status)
{
  struct proc *p = myproc();

  if (p == initproc)
    panic("init exiting");
  // printf(""); printf(""); printf("");

  // Debugging statement
  // printf("Exiting process %d\n", p->pid);
  // printf(""); printf(""); printf("");

  // Close all open files.
  for (int fd = 0; fd < NOFILE; fd++)
  {
    if (p->ofile[fd])
    {
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  // printf(""); printf(""); printf("");

  // Transfer syscall counts to parent if it exists
  if (p->parent) {
    acquire(&p->parent->lock);
    for (int i = 0; i < 32; i++) {
      p->parent->syscalls[i] += p->syscalls[i];
    }
    release(&p->parent->lock);
  }

  // printf(""); printf(""); printf("");

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Debugging statement
  // printf("Reparenting children of process %d\n", p->pid);
  // printf(""); printf(""); printf("");

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);

  // printf(""); printf(""); printf("");

  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;
  p->etime = ticks;

  release(&wait_lock);

  // Debugging statement
  // printf("Process %d is now a zombie\n", p->pid);
  // printf(""); printf(""); printf(""); 

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(uint64 addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (pp = proc; pp < &proc[NPROC]; pp++)
    {
      if (pp->parent == p)
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if (pp->state == ZOMBIE)
        {
          // Found one.
          pid = pp->pid;
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
                                   sizeof(pp->xstate)) < 0)
          {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || killed(p))
    {
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
  }
}

uint
rand(void)
{
  static uint seed = 1;
  seed = seed * 1103515245 + 15243;
  return seed;
}

void log_event(int time, int pid, int queue_id) {
  printf("%d,%d,%d\n", pid, time, queue_id);
}

void
enqueue(struct proc *p, int queue)
{
  // log_event(ticks, p->pid, queue);
  mlfq[queue][queue_size[queue]++] = p;
}

struct proc*
dequeue(int queue)
{
  if (queue_size[queue] == 0)
    return 0;
  
  struct proc *p = mlfq[queue][0];
  for (int i = 0; i < queue_size[queue] - 1; i++) {
    mlfq[queue][i] = mlfq[queue][i+1];
  }
  queue_size[queue]--;
  return p;
}

void
priority_boost(void)
{
  struct proc *p;
  for (int i = 1; i < 4; i++) {
    while (queue_size[i] > 0) {
      p = dequeue(i);
      p->mlfq_priority = 0;
      p->mlfq_ticks = 0;
      p->time_slice = 1;
      enqueue(p, 0);
    }
  }
}

void
update_ticks(void)
{
  struct proc *p = myproc();
  if(p != 0) {
    acquire(&p->lock);
    p->total_ticks++;
    p->mlfq_ticks++;
    p->time_slice--;
    if(p->time_slice <= 0) {
      yield();
    }
    release(&p->lock);
  }
  acquire(&tickslock);
  global_ticks++;
  if(global_ticks >= 48) {
    priority_boost();
    global_ticks = 0;
  }
  release(&tickslock);
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void scheduler(void)
{
  // struct proc *p;
  struct cpu *c = mycpu();

  c->proc = 0;
  for (;;)
  {
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();
    #ifdef RR
    // printf("Scheduling policy: RR\n");
    int found = 0;
    struct proc *p;
    for (p = proc; p < &proc[NPROC]; p++)
    {
      acquire(&p->lock);
      if (p->state == RUNNABLE)
      {
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        p->state = RUNNING;
        c->proc = p;
        swtch(&c->context, &p->context);

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
        found = 1;
      }
      release(&p->lock);
    }
    if(found == 0) {
      intr_on();
      asm volatile("wfi");
    }
    #endif

    #ifdef LBS
    // printf("Scheduling policy: LBS\n");
    struct proc *p;
    int total_tickets = 0;
    struct proc *earliest_proc[NPROC] = {0};

    // Count total tickets and find earliest process for each ticket count
    for(p = proc; p < &proc[NPROC]; p++) {
      acquire(&p->lock);
      if(p->state == RUNNABLE) {
        total_tickets += p->tickets;
        if(!earliest_proc[p->tickets] || p->ctime < earliest_proc[p->tickets]->ctime) {
          earliest_proc[p->tickets] = p;
        }
      }
      release(&p->lock);
    }

    // printf("LBS: Total tickets: %d\n", total_tickets);

    if(total_tickets == 0) {
      // printf("LBS: No runnable processes, yielding...\n");
      intr_on();
      asm volatile("wfi");
      continue;
    }

    int winner = rand() % total_tickets;
    int counter = 0;
    struct proc *selected = 0;

    for(p = proc; p < &proc[NPROC]; p++) {
      if(p->state == RUNNABLE) {
        counter += p->tickets;
        if(counter > winner) {
          // Check if there's an earlier process with the same number of tickets
          if(earliest_proc[p->tickets] && earliest_proc[p->tickets]->ctime < p->ctime) {
            p = earliest_proc[p->tickets];
          }
          selected = p;
          break;
        }
      }
    }

    if(selected) {
      acquire(&selected->lock);
      if(selected->state == RUNNABLE) {
        // printf("LBS: Selected process %d with %d tickets\n", selected->pid, selected->tickets);
        c->proc = selected;
        selected->state = RUNNING;
        swtch(&c->context, &selected->context);
        c->proc = 0;
      }
      release(&selected->lock);
    } else {
      // printf("LBS: No process selected, yielding...\n");
      intr_on();
      asm volatile("wfi");
    }
    #endif

    #ifdef MLFQ
    struct proc *p;
    int found = 0;
    // Loop through priority queues
    for (int i = 0; i < 4 && !found; i++) {
      // Run processes in the current queue
      for (int j = 0; j < queue_size[i] && !found; j++) {
        p = mlfq[i][j];
        if(p && p->state == RUNNABLE) {
          acquire(&p->lock);
          if(p->state == RUNNABLE) {
            p->state = RUNNING;
            c->proc = p;
            // log_event(ticks, p->pid, i);
            swtch(&c->context, &p->context);
            c->proc = 0;
            found = 1;
          }
          release(&p->lock);
        }
      }
    }

    // If no RUNNABLE process was found, yield the CPU
    if (!found) {
      intr_on();
      asm volatile("wfi");
    }
    #endif
  }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&p->lock))
    panic("sched p->lock");
  if (mycpu()->noff != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched running");
  if (intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *p = myproc();
  acquire(&p->lock);
  p->state = RUNNABLE;
  #ifdef MLFQ
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < queue_size[i]; j++) {
      if (mlfq[i][j] == p) {
        // Remove from current position
        for (int k = j; k < queue_size[i] - 1; k++) {
          mlfq[i][k] = mlfq[i][k+1];
        }
        queue_size[i]--;
        // Add to appropriate queue
        enqueue(p, p->mlfq_priority);
        break;
      }
    }
  }
  #endif
  sched();
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);

  if (first)
  {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();

  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); // DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    if (p != myproc())
    {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan)
      {
        p->state = RUNNABLE;
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->pid == pid)
    {
      p->killed = 1;
      if (p->state == SLEEPING)
      {
        // Wake process from sleep().
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

void setkilled(struct proc *p)
{
  acquire(&p->lock);
  p->killed = 1;
  release(&p->lock);
}

int killed(struct proc *p)
{
  int k;

  acquire(&p->lock);
  k = p->killed;
  release(&p->lock);
  return k;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if (user_dst)
  {
    return copyout(p->pagetable, dst, src, len);
  }
  else
  {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if (user_src)
  {
    return copyin(p->pagetable, dst, src, len);
  }
  else
  {
    memmove(dst, (char *)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
  static char *states[] = {
      [UNUSED] "unused",
      [USED] "used",
      [SLEEPING] "sleep ",
      [RUNNABLE] "runble",
      [RUNNING] "run   ",
      [ZOMBIE] "zombie"};
  struct proc *p;
  char *state;

  printf("\n");
  for (p = proc; p < &proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s", p->pid, state, p->name);
    printf("\n");
  }
}

// waitx
int waitx(uint64 addr, uint *wtime, uint *rtime)
{
  struct proc *np;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for (;;)
  {
    // Scan through table looking for exited children.
    havekids = 0;
    for (np = proc; np < &proc[NPROC]; np++)
    {
      if (np->parent == p)
      {
        // make sure the child isn't still in exit() or swtch().
        acquire(&np->lock);

        havekids = 1;
        if (np->state == ZOMBIE)
        {
          // Found one.
          pid = np->pid;
          *rtime = np->rtime;
          *wtime = np->etime - np->ctime - np->rtime;
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
                                   sizeof(np->xstate)) < 0)
          {
            release(&np->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(np);
          release(&np->lock);
          release(&wait_lock);
          return pid;
        }
        release(&np->lock);
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || p->killed)
    {
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep(p, &wait_lock); // DOC: wait-sleep
  }
}

void update_time()
{
  struct proc *p;
  for (p = proc; p < &proc[NPROC]; p++)
  {
    acquire(&p->lock);
    if (p->state == RUNNING)
    {
      p->rtime++;
    }
    release(&p->lock);
  }
}

int
sigalarm(int interval, void (*handler)())
{
  struct proc *p = myproc();
  p->alarm_interval = interval;
  p->alarm_handler = (uint64)handler;
  memset(&p->ticks_count, 0, sizeof(p->ticks_count));
  if (interval > 0) p->alarm_on = 1;
  else p->alarm_on = 0;
  return 0;
}

int
sigreturn(void)
{
  struct proc *p = myproc();
  if(p->alarm_trapframe == 0)
    return -1;
  memmove(p->trapframe, p->alarm_trapframe, sizeof(struct trapframe));
  kfree(p->alarm_trapframe);
  memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
  return 0;
}

