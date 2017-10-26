#!/usr/bin/env python

import os
import sys

path = sys.path[0]
os.chdir(path)

print('\n==== start setup project development ====\n')

n = os.system('clang-format -version')
n = n >> 8

if n != 0:
    print('\n**** start install clang-format ****\n')
    os.system('brew install clang-format')

os.system('cp ./pre-commit-hooks ../.git/hooks/pre-commit')
os.system('chmod +x ../.git/hooks/pre-commit')
print('\n==== setup project development succeed ====\n')


