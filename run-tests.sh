#!/bin/bash

LISP=sbcl
LISP_TYPE=sbcl

while getopts "l:h" arg; do
  case $arg in
    h)
      echo "Usage: run-tests.sh -l <lisp>"
      exit
      ;;
    l)
      LISP=$OPTARG
      LISP_TYPE=$(basename ${LISP[0]})
      ;;
  esac
done

case $LISP_TYPE in
    sbcl)
        cmd="$LISP --non-interactive --eval '(asdf:test-system :usocket)'"
        ;;
    ecl)
        cmd="$LISP --nodebug --eval '(asdf:test-system :usocket)' --eval '(ext:quit)'"
        ;;
    ccl*)
        cmd="$LISP --batch -Q </dev/null --eval '(asdf:test-system :usocket)'"
        ;;
    abcl)
        cmd="$LISP --batch --eval '(asdf:test-system :usocket)'"
        ;;
    *)
        echo "Unknown lisp implementation: $LISP"
        exit 5
esac
echo $cmd

export CL_SOURCE_REGISTRY="$PWD"
eval "exec $cmd"
