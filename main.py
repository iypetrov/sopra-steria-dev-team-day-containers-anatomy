import os
import sys
import subprocess


def run():
    cmd = sys.argv[2:]
    subprocess.run(
        cmd,
        stdin=sys.stdin,
        stdout=sys.stdout,
        stderr=sys.stderr,
        preexec_fn=lambda: os.unshare(os.CLONE_NEWUTS)
    )


def main():
    if len(sys.argv) < 2:
        sys.exit(1)
        print("There should be at least 2 arguments")

    if sys.argv[1] == "run":
        run()


if __name__ == "__main__":
    main()
