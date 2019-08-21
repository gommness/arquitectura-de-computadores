#!/bin/bash

#use this script if you fetched the callgrind files correctly but somehow the output.dat files were messed up
cd $(dirname $0)
rm ./dataFiles/*.dat

P=23
cacheTam=1
minsz=$P
closest2power=16
I1=0
D1=0
LL=0
maxsz=$(expr 2048 + $P)
incr=16


for iter in $(seq 0 1 3)
do
	file="./dataFiles/$cacheTam.dat"
	touch $file
	echo -e "TamMatriz\tD1mrslow\tD1mwslow\tD1mrfast\tD1mwfast" > $file

	for i in $(seq $minsz $incr $maxsz)
	do
		#Ir  Dr  Dw  I1mr  D1mr  D1mw  ILmr  DLmr  DLmw
		#escribo en el fichero los resultados
		callgrind_annotate callgrind/$cacheTam.$i.slow | head -n 30 | grep "PROGRAM TOTALS" | tr --delete , | awk -v tam="$i" '{printf tam"\t""%s""\t""%s""\t",$5,$6}' >> $file
		callgrind_annotate callgrind/$cacheTam.$i.fast | head -n 30 | grep "PROGRAM TOTALS" | tr --delete , | awk '{print $5"\t"$6}' >> $file
	done
	#cacheTam va duplicandose cada iteracion
	cacheTam=$(expr $cacheTam \* 2)
done
