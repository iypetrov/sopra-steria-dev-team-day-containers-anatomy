import os
import sys


def run():
    print("The PID of the main process is:", os.getpid())
    cmd = sys.argv[2:]
    print(cmd)


# docker         run image <cmd> <params>
# python main.py run       <cmd> <params>
def main():
    if len(sys.argv) < 2:
        print("Usage: python main.py run <command> [args...]")
        sys.exit(1)

    if sys.argv[1] == "run":
        run()


if __name__ == "__main__":
    main()
