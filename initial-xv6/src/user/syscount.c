#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/syscall.h"
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))

char* syscall_name(int mask) {
    static char* syscalls[] = {
        "fork", "exit", "wait", "pipe", "read", "kill", "exec", "fstat",
        "chdir", "dup", "getpid", "sbrk", "sleep", "uptime", "open", "write",
        "mknod", "unlink", "link", "mkdir", "close", "waitx", "getsyscount"
    };
    // printf("Debug: Initial mask value = %d\n", mask);
    int index = -1;
    while (mask > 1) {
        mask /= 2;  
        index++;
    }
    // printf("Debug: Index = %d\n", index);
    if (index >= 0 && index < NELEM(syscalls)) return syscalls[index];
    return "unknown";
}

int main(int argc, char *argv[]) {
//   if (argc < 3) {
  if (argc < 3) {
    printf("Usage: syscount <mask> command [args]\n");
    exit(1);
  }
  int mask = atoi(argv[1]);
  // check if mask is a power of 2
  if ((mask & (mask - 1)) != 0) {
      printf("Invalid mask %d\n", mask);
      exit(1);
  }
  int pid = fork();
  if (pid < 0) {
    printf("Couldn't execute fork\n");
    exit(1);
  }
  if (pid == 0) {    
    exec(argv[2], &argv[2]);
    printf("Couldn't execute exec\n");
    exit(1);
  } 
  else {    
    wait(0);
    int count = getsyscount(mask);
    printf("PID %d called %s %d times\n", pid, syscall_name(mask), count);
  }
  exit(0);
}

// printf("Debug: Child process executing %s\n", argv[2]);
// printf("Debug: Parent process waiting for child PID %d\n", pid);
// printf("Debug: Child process exited\n");
// printf("Debug: Count returned by getsyscount = %d\n", count);