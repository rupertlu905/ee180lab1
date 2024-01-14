#!/usr/bin/env bash

# Command to compare the output of the C and MIPS implementations of radixsort.
# Written by Chris Copeland (chrisnc@stanford.edu)

# usage: ./test.sh inputfile

# (make sure to run "chmod +x test.sh" first)

# attempt to build the executable if it does not exist
if [ ! -e "radixsort"  ]
then
	make
fi

diff <(./radixsort < $1 | tail -n 1) <(spim -file radixsort.s < $1 | tail -n 1)
