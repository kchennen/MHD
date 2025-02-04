import os
import sys

from pyfiglet import figlet_format
from termcolor import cprint

from mhd.cli import cli

pathname = os.path.dirname(sys.argv[0])
sys.path.insert(0, pathname)
from mhd import prog_name


def main() -> None:
    cprint(text=figlet_format(text=prog_name,
                              font='starwars'),
           
           color='magenta',
           attrs=['bold'],
           )
    cli()


if __name__ == '__main__':
    main()
