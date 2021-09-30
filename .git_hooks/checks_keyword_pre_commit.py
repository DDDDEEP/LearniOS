#!/usr/bin/env python3

import os
import sys
import git

words = [
    "b,y,t,e,d,a,n,c,e",
    "B,y,t,e,D,a,n,c,e",
    "b,d,p",
    "B,D,P",
    "b,t,d",
    "B,T,D",
]
keywords = list(map(lambda str: str.replace(',', ''), words))

extensions = [
    '.m',
    '.h',
    '.mm',
]

print("Checking keywords: '{keywords}'".format(keywords=keywords))
print("Checking file extension: '{extensions}'".format(extensions=extensions))

repo = git.Repo('.')

for i in repo.index.diff("HEAD"):
    fname = i.a_path

    isShouldCheck = False
    for ext in extensions:
        if fname.endswith(ext):
            isShouldCheck = True
            break

    if not isShouldCheck:
        continue

    print("Checking file: '{file}'".format(file=fname))
    if os.path.isfile(fname):    # make sure it's a file, not a directory entry
        with open(fname) as f:   # open file
            for line in f:       # process line by line
                for word in keywords:
                    if word in line:    # search for string
                        print("Found keyword '{word}' in file: '{file}'".format(word=word, file=fname))
                        sys.exit(1)
print("Check keywords success!")
sys.exit(0)
