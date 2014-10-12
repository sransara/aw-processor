#! /usr/local/bin/python3
import argparse
import os
import subprocess
import sys

# Colors
HEADERC = '\033[95m'
OKBLUEC = '\033[94m'
OKGREENC = '\033[92m'
WARNINGC = '\033[93m'
FAILC = '\033[91m'
ENDC = '\033[0m'

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--file', help='.asm file to test')
parser.add_argument('-s', '--syn', help='sim or syn', action='store_true')
parser.add_argument('-n', '--synth', help='synth')
parser.add_argument('-v', '--verbose', help='print all kinds of output', action='store_true')
parser.add_argument('-d', '--differences', help='print differences', action='store_true')

args = parser.parse_args()
sym = 'sim'
if args.syn:
  sym = 'syn' # default to sim, set to syn
elif args.synth:
  sym = 'synth'

runfname = args.file if args.file else ''

errors = False
testdir = './asmFiles/'
print("Testing " + sym)
for fname in os.listdir(testdir):
    std = '' if args.verbose else ' > /dev/null'
    if(runfname and not fname.startswith(runfname)):
        continue

    if(fname.endswith('.asm')):
        asm = testdir + fname
        trout = 'memsim.hex'
        myout = 'memcpu.hex'

        print("-- Testing file:", fname)
        recommand = 'asm asmFiles/' + fname + '; sim > /dev/null;'
        reout = os.system(recommand)
        print(recommand)

        sycommand = ''
        if(sym == 'syn'):
          sycommand = 'make system.syn ' + std
        elif(args.synth):
          sycommand = 'synthesize -t -f '+ args.synth +' system ' + std
          std = '' # hacky way to get make (the next cmd) to print to stdout

        if(sycommand):
          print (sycommand)
          syout = os.system(sycommand)

        excommand = 'make system.sim ' + std
        dfcommand = 'diff -b -B ' + myout + ' ' + trout
        print(excommand)
        exout = os.system(excommand);

        try:
            print(dfcommand)
            dfout = subprocess.check_output(dfcommand, shell=True);
            print("[" + OKGREENC + "PASSED" + ENDC + "]", fname)
        except:
            errors = True
            if args.differences:
              dyfcommand = 'diff -y  ' + myout + ' ' + trout
              os.system(dyfcommand);
            print("[" + FAILC + "FAILED" + ENDC + "]", fname)
            #break

if(errors): exit(1)
