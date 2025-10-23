import sys


def run():
    cmd = sys.argv[2:]
    print(cmd)


def main():
    if len(sys.argv) < 2:
        print("Usage: python main.py run <command> [args...]")
        sys.exit(1)

    if sys.argv[1] == "run":
        run()


if __name__ == "__main__":
    main()
