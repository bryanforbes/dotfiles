#!/usr/bin/env python

import os, sys, subprocess
from path import path

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
    dotfile = path("~/.%s" % file.namebase).expand()
    backup = dotfile + '.backup'

    if dotfile.isfile() or dotfile.isdir() or dotfile.islink():
        if not prompt_overwrite(dotfile):
            print "\tSkipping ~/%s" % dotfile.name
            return
        print "\tBacking up ~/%(file)s to ~/%(file)s.backup" % {
            'file': dotfile.name
        }

        if backup.exists():
            backup.unlink()
        dotfile.move(dotfile + '.backup')
    file.symlink(dotfile)

def restore_file(file):
    dotfile = path("~/.%s" % file.namebase).expand()
    backup = dotfile + '.backup'

    if backup.exists():
        print "Restoring ~/%(backup)s to ~/%(dotfile)s" % {
            'backup': backup.name,
            'dotfile': dotfile.name
        }
        dotfile.unlink()
        backup.move(dotfile)

if __name__ == "__main__":
    subprocess.call(["git", "submodule", "update", "--init"])

    restore = '--restore' in sys.argv
    for file in path(__file__).realpath().dirname().glob("*.symlink"):
        if restore:
            restore_file(file)
        else:
            replace_file(file)
