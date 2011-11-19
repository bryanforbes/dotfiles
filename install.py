#!/usr/bin/env python

import os, sys, subprocess
from time import localtime, strftime
from path import path

right_now = strftime("%Y%m%d%H%M%S", localtime())

replace_all = False
def prompt_overwrite(file):
    global replace_all
    if replace_all:
        return True

    inputline = raw_input("Overwrite ~/%s? [ynaq] " % file.name)

    if inputline == "y":
        return True
    if inputline == "a":
        replace_all = True
        return True
    if inputline == "q":
        sys.exit()
    return False

def replace_file(file):
    dotfile = path("~/.%s" % file.basename()).expand()

    if dotfile.isfile() or dotfile.isdir() or dotfile.islink():
        if not prompt_overwrite(dotfile):
            print "\tSkipping ~/%s" % dotfile.name
            return
        print "\tBacking up ~/%(file)s to ~/%(file)s.%(right_now)s" % {
            'file': dotfile.name, 
            'right_now': right_now
        }

        dotfile.move(dotfile + ('.%s' % right_now))
    file.symlink(dotfile)

if __name__ == "__main__":
    subprocess.call(["git", "submodule", "init"])
    subprocess.call(["git", "submodule", "update"])

    for file in path(__file__).realpath().dirname().glob("*"):
        if file.fnmatch("*.py") or file.fnmatch("*.pyc") or \
            file.fnmatch("*.sh") or file.fnmatch("*.md"):
            continue

        replace_file(file)
