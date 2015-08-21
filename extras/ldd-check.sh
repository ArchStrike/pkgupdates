#!/bin/bash
pacman -Qqm | while read package
do
  pacman -Ql $package | grep -v -E "(.gz|.html|.h|.hxx|/)$" | awk '{ print $2}' | while read curFile
  do
    ldd $curFile &> /dev/null
    if [ $? = 0 ]
    then
      ldd $curFile 2> /dev/null | awk '{ print $3}' | while read libFile
      do
        if [ ! -f $libFile ]
        then
          echo $package
        fi
      done
    fi
  done
done
