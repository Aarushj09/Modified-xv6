# Modified XV6

## Specification 1 : Adding syscall trace

> Add  `sys_trace()` in `kernel/sysproc.c` which loads the argument `mask` from the trapframe and stores it in the `proc` struct.

> `syscall()` in `kernel/syscall.c` is modified to print the output of trace.

> In `fork()`, mask is copied from the parent to the child process.

> A new file `strace.c` is added to `user` directory which parses the arguments and calls the system call.

> A stub is added in `user/usys.pl` and a prototype for the system call is also added in `user/user.h`.

> `$/U_strace` is added to `UPROGS` in the `MAKEFILE`.

## Specification 2 : Scheduling

`Makefile` is modified to define a macro `SCHEDULER`.

### FCFS

> It selects the process with the lowest creation time and keeps runnning until the process ends.

> While process creation in `allocproc()`, process' creation time is stored in `struct proc::ctime`.

> In `kernel/proc.c`, we search for the process with the lowest creation time and run that process.

> Preemption is disabled by disabling the call to `yield()` in `usertrap()` and `kerneltrap()` in `kernel/trap.c`, if FCFS is the choosen scheduler.

### PBS

> Here also, in `kernel/proc.c`, we search for the process with the lowest dynamic priority.

> The sleeping time of the process is calculated by storing the ticks at which the process enters `sleep()` and `wakeup()` in `kernel/proc.c` and and then storing the difference in `struct proc::stime`.

> The static priority is set in the `allocproc()`. 

> Since, this is also pre-emptive, `yield()` is also disables just like in FCFS.

> Just like the syscall `trace` implemented in spec 1, another syscall `setpriority` is implemented. It searches for the process with the given pid and changes the static priority to the given one. The static priority for a process is stored in `struct proc::priority`.

> Also, if after setting the new static priority, the dynamic priority decreases, then rescheduling is done by calling the `yield()` function.

### MLFQ

> To implement the priority queue, we store the queue in which the process is present in `struct proc::queue`. 

> For each process, if the wait time > 15, then the process is promoted to the next higher priority queue. 

> The time at which the process enters in the current queue is stored in `struct proc::last_qtime`. With this and the the `struct proc::queue`, we find the process in the front of the topmost non-empty priority queue and run it. 

> In `kernel/trap.c`, if the process exceeds the time-slice alloted for the queue in which it is present, then a timer interrupt occurs and the process is demoted to a lower-priority queue.

## Specification 3 : procdump()

> It prints the information as mentioned in the assignment doc. Most of this information is already present as part of `struct proc`.

> `wtime` is calculated using ` current_time/end_time - creation_time - run_time`


## Exploitation of MLFQ by a process

If a process voluntarily relinquishes control of the CPU(eg. For doing I/O), it leaves the queuing network, and when the process becomes ready againa fter the I/O, it is inserted at the tail of the same queue, from which it is relinquished earlier. This can be exploited by a process, because a process can be created which voluntarily relinquishes control of the CPU just when the time-slice for the current queue is about to get over. This process will then be inserted back into the same queue and will still maintain higher priority. Due to this it would run sooner then it should have and other lower priority will not get a chance to execute in time.

## Benchmark

`schedulertest.c` was ran for all the scheduling functions with the average wait time and running time as follows:

RR :  avg rtime 114, avg wtime 13

FCFS : avg rtime 42, avg wtime 34

PBS : avg rtime 107, avg wtime 17

MLFQ : avg rtime 110, avg wtime 15

Round-robin performs the best, which performs almost equally good as MLFQ, followed by PBS.

We can see, that FCFS performs the worst because a long CPU-bound process occuring first, increase the wait-time of all other processes.

The process `usertests reparent2` is run on each scheduler and the average running and wait time for them are as follows.

RR : waiting:63 running:59

FCFS : waiting:69 running:59

PBS : waiting:71 running:53

MLFQ : waiting:70 running:58
