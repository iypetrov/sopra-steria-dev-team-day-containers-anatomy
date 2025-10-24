docker run --rm -it busybox /bin/sh
- hostname
- ps aux

namespaces - limit what a process can see, there are different types of namespaces (pid, net, mount, uts, ipc, user)
- run the contianer and run `hostname container`

set hostname automatically
- explain why fork is needed
- in the new container show that the ps of the host are visible

make the pid in container start from 1
- ps get the info from /proc
- we need to create our own proc so that the container only sees its own processes
- for this we will use chroot
- with the Makefile will create a tinyroot filesystem based on busybox
    - `ls /` - to see our own root filesystem 
    - `ls tinyroot` - to see the tinyroot filesystem
- now we chroot
- we need to mount a new instance of the proc filesystem inside the container’s PID namespace(proc is a filesystem on its own)
  A /proc filesystem shows (in the /proc/pid directories) only processes visible in the PID namespace of the process that performed the mount.

now if we run `sleep 100` and in the host do `ps -C sleep` and we can see that `ls -la /proc/<PID>/root` shows the tinyroot filesystem

to show that the mount of the container is cleared after the container exits run `mount | grep proc` on the host before and after running the container

cgroups - limit resource usage (cpu, memory, io, pids)
docker run --rm -it --memory=10M busybox /bin/sh
- cd /sys/fs/cgroup/system.slice
- ls | grep docker 
- cat memory.max

- use `ps -ef --forest | grep <PID>` to see the process tree
