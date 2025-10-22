import os
import sys
import subprocess

def run():
    cmd = sys.argv[2:]
    print(cmd)
    subprocess.run(cmd, stdin=sys.stdin, stdout=sys.stdout, stderr=sys.stderr)

# docker         run image <cmd> <params>
# python main.py run       <cmd> <params>
def main():
    if len(sys.argv) < 2:
        sys.exit(1)

    if sys.argv[1] == "run":
        run()

if __name__ == "__main__":
    main()
