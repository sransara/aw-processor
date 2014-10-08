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
parser.add_argument('-v', '--verbose', help='print all kinds of output', action='store_true')
parser.add_argument('-d', '--differences', help='print differences', action='store_true')

args = parser.parse_args()
sym = 'syn' if args.syn else 'sim' # default to sim, set to syn
runfname = args.file if args.file else ''
std = '' if args.verbose else ' > /dev/null'

if(sym == 'sim'):
  print("Warning: Running sim on synthesized without cleaning will give unintended errors")
  input()

errors = False
testdir = './asmFiles/'
print("Testing " + sym)
for fname in os.listdir(testdir):
    if(runfname and not fname.startswith(runfname)):
        continue

    if(fname.endswith('.asm')):
        asm = testdir + fname
        trout = 'memsim.hex'
        myout = 'memcpu.hex'

        recommand = 'asm asmFiles/' + fname + '; sim > /dev/null;'
        if(sym == 'syn'):
          sycommand = 'make system.syn ' + std
        excommand = 'make system.sim ' + std
        dfcommand = 'diff -b -B ' + myout + ' ' + trout

        print("-- Testing file:", fname)
        print(recommand)
        reout = os.system(recommand)
        if(sym == 'syn'):
          print (sycommand)
          syout = os.system(sycommand)
        print(excommand)
        exout = os.system(excommand);
        try:
            print(dfcommand)
            dfout = subprocess.check_output(dfcommand, shell=True);
            print("[" + OKGREENC + "PASSED" + ENDC + "] testcase for ", fname)
        except:
            errors = True
            if args.differences:
              dyfcommand = 'diff -y  ' + myout + ' ' + trout
              os.system(dyfcommand);
            print("[" + FAILC + "FAILED" + ENDC + "] testcase for ", fname)
            #break

if(errors): exit(1)
