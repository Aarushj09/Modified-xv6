#include "kernel/param.h"
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc != 3 ){
    fprintf(2, "Usage: %s priority command\n", argv[0]);
    exit(1);
  }

  int val = setpriority(atoi(argv[1]),atoi(argv[2]));
  if (val < 0) {
    fprintf(2, "%s: setpriority failed\n", argv[0]);
    exit(1);
  }

  printf("Old static priority of process with pid %s = %d\n", argv[2], val);
  exit(0);
}