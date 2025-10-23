import os
import sys
import subprocess


def run():
    os.unshare(os.CLONE_NEWUTS | os.CLONE_NEWPID)

    pid = os.fork()
    if pid == 0:
        child()
    else:
        os.waitpid(pid, 0)


def child():
    subprocess.run(["hostname", "container"])

    os.chroot("tinyroot")
    os.chdir("/")

    os.makedirs("/proc", exist_ok=True)
    subprocess.run(["mount", "-t", "proc", "proc", "/proc"])

    cmd = sys.argv[2:]
    pid = os.fork()
    if pid == 0:
        os.execvp(cmd[0], cmd)
    else:
        os.waitpid(pid, 0)
        subprocess.run(["umount", "/proc"])


def main():
    if len(sys.argv) < 2:
        print("Usage: python main.py run <command> [args...]")
        sys.exit(1)

    if sys.argv[1] == "run":
        run()


if __name__ == "__main__":
    main()
