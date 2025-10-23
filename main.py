import os
import sys
import subprocess
import multiprocessing


def run():
    flags = os.CLONE_NEWUTS | os.CLONE_NEWPID
    os.unshare(flags)

    p = multiprocessing.Process(target=child)
    p.start()
    p.join()


def child():
    subprocess.run(["hostname", "container"])
    cmd = sys.argv[2:]
    os.execvp(cmd[0], cmd)


def main():
    if len(sys.argv) < 2:
        print("There should be at least 2 arguments")
        sys.exit(1)

    if sys.argv[1] == "run":
        run()
    elif sys.argv[1] == "child":
        child()


if __name__ == "__main__":
    main()
