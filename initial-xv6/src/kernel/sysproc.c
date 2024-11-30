#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0; // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_waitx(void)
{
  uint64 addr, addr1, addr2;
  uint wtime, rtime;
  argaddr(0, &addr);
  argaddr(1, &addr1); // user virtual memory
  argaddr(2, &addr2);
  int ret = waitx(addr, &wtime, &rtime);
  struct proc *p = myproc();
  if (copyout(p->pagetable, addr1, (char *)&wtime, sizeof(int)) < 0)
    return -1;
  if (copyout(p->pagetable, addr2, (char *)&rtime, sizeof(int)) < 0)
    return -1;
  return ret;
}

// int
// getsyscount(int mask)
// {
//   struct proc *p = myproc();
//   int index = get_syscall_index(mask);
//   if (index == -1) {
//     // printf("Debug: Invalid mask %d in getsyscount\n", mask);
//     return -1;
//   }
//   // printf("Debug: Counting syscall %d for PID %d\n", index, p->pid);
//   // printf("Debug: Count for syscall %d: %d\n", index, p->syscall_count[index]);
//   return p->syscalls[index];
// }

uint64
sys_getsyscount(void)
{
  int mask;
  argint(0, &mask);

  struct proc *p = myproc();
  int index = get_syscall_index(mask);
  if (index != -1) {
    index = p->syscalls[index]; 
  }
  // printf("Debug: Counting syscall %d for PID %d\n", index, p->pid);
  // printf("Debug: Count for syscall %d: %d\n", index, p->syscall_count[index]);

  index = get_syscall_index(mask);
  if (index == -1) return -1;
  int count = getsyscount(mask);
  return count;
}

// printf("Debug: Invalid mask %d\n", mask); // Debug print
// printf("Debug: sys_getsyscount called with mask %d (index %d), count %d\n", mask, index, count); // Debug print

uint64
sys_sigalarm(void)
{
  int interval;
  argint(0, &interval);
  uint64 handler;
  argaddr(1, &handler);
  struct proc *p = myproc();
  memset(&p->ticks_count, 0, sizeof(p->ticks_count));
  if (interval > 0) p->alarm_on = 1;
  else p->alarm_on = 0;
  p->alarm_interval = interval;
  p->alarm_handler = handler;
  if (p->alarm_trapframe) {
    kfree(p->alarm_trapframe);
    memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
  }
  return 0;
}

uint64
sys_sigreturn(void)
{
  struct proc *p = myproc();
  if (p->alarm_trapframe) {
    memmove(p->trapframe, p->alarm_trapframe, sizeof(struct trapframe));
    kfree(p->alarm_trapframe);
    memset(&p->alarm_trapframe, 0, sizeof(p->alarm_trapframe));
    return 0;
  }
  return -1;
}

uint64  
sys_settickets(void)
{
  int tickets;
  argint(0, &tickets);
  if (tickets <= 0) return -1;
  myproc()->tickets = tickets;
  return tickets;
}
