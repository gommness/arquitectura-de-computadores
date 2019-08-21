#!/bin/bash

cd $(dirname $0)
P=23 #numero de pareja
minsz=$P
maxsz=$(expr 2048 + $P)
incr=16
file="./ejercicio1.dat"
echo "tamanio	slow	fast" > $file

for i in $(seq $minsz $incr $maxsz)
do

	#tamanio	
	cad1=$i
	#tiempo de ejecucion del slow	
	cad2=$(./../source/slow $i | grep 'Execution time: ' | cut -d ' ' -f 3)
	#tiempo de ejecucion del fast
	cad3=$(./../source/fast $i | grep 'Execution time: ' | cut -d ' ' -f 3)
	
	echo "$cad1	$cad2	$cad3" >> $file
done
