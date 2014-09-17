#! /usr/bin/env python
import argparse
import os
import subprocess
import sys

parser = argparse.ArgumentParser()
parser.add_argument('-f', '--file', help='.asm file to test')
parser.add_argument('-s', '--syn', help='sim or syn', action='store_true')
parser.add_argument('-v', '--verbose', help='print all kinds of output')

args = parser.parse_args()
sym = 'syn' if args.syn else 'sim' # default to sim, set to syn
runfname = args.file if args.file else ''
std = '' if args.verbose else ' > /dev/null'

errors = False
testdir = './asmFiles/'
print("Testing " + sym)
for fname in os.listdir(testdir):
    if(runfname and fname != runfname):
        continue

    if(fname.endswith('.asm')):
        asm = testdir + fname
        trout = testdir + 'memsim.hex'
        myout = 'memcpu.hex'

        recommand = 'asm asmFiles/' + fname + '; cd asmFiles; asm ' + fname + '; sim > /dev/null; cd .. ;'
        if(sym == 'syn'):
          sycommand = 'make system.syn ' + std
        excommand = 'make system.sim ' + std
        dfcommand = 'diff -b -B ' + myout + ' ' + trout

        print("Testing file:", fname)
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
        except:
            errors = True
            print("--- Failed testcase for ", fname)
            #break

if(errors): exit(1)
