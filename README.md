# sopra-steria-dev-team-day-containers-anatomy

can view the slides on this [link](https://iypetrov.github.io/sopra-steria-dev-team-day-containers-anatomy)

docker run --rm -it busybox /bin/sh


man unshare

- limit the container to see only its processes
ps uses /proc to get the list of processes
so to do this our contianer needs its own /proc
here we are going to use the chroot
use ps aux to see all processes
or ps -C sleep
