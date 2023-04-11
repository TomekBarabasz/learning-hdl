import sys,argparse,shlex
from pathlib import Path
from subprocess import run

def main(Args):
    command_line = f"ghdl -a --std={Args.std} {' '.join(map(str,Args.files))}"
    #print('running',command_line)
    cp = run(shlex.split(command_line))
    if cp.returncode != 0:
        return

    command_line = f"ghdl -e --std={Args.std} {Args.name}"
    #print('running',command_line)
    cp = run(shlex.split(command_line))
    if cp.returncode != 0:
        return

    if Args.test:
        wavefilename = Args.wave if Args.wave is not None else Args.name
        command_line = f"ghdl -r --std={Args.std} {Args.name} --wave={wavefilename}.ghw"
        #print('running',command_line)
        cp = run(shlex.split(command_line))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("name", type=str, help="test entity name")
    parser.add_argument("-files", "-f", type=Path, nargs='+', help="files to process")
    parser.add_argument("-std",  type=str,  default='08', help="vhdl standard")
    parser.add_argument("-test", "-t", action='store_true',  help="run tests")
    parser.add_argument("-wave", "-w", type=str, help="output wavefile name")
    Args = parser.parse_args(sys.argv[1:])

    main(Args)