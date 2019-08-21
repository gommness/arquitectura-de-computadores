#!/bin/bash

cd $(dirname $0)
rm callgrind/*.slow
rm callgrind/*.fast
rm dataFiles/*.dat

P=23
cacheTam=1
minsz=$P
closest2power=16
I1=0
D1=0
LL=0
maxsz=$(expr 2048 + $P)
incr=16

#8MB de cache de ultimo nivel
LL=$(expr 8 \* 1024 \* 1024)

for iter in $(seq 0 1 3)
do
	file="./dataFiles/$cacheTam.dat"
	touch $file
	echo -e "TamMatriz\tD1mrslow\tD1mwslow\tD1mrfast\tD1mwfast" > $file
	#i va de P a 2048+P en incrementos de 16
	for i in $(seq $minsz $incr $maxsz)
	do
		echo -e "\ncache: $cacheTam matriz: $i\n"
		#tamanios de cache en cada iteracion
		I1=$(expr $closest2power \* $cacheTam \* 1024)
		D1=$(expr $closest2power \* $cacheTam \* 1024)
		#generamos los ficheros callgrind.out
		valgrind -q --tool=callgrind --I1=$I1,1,64 --D1=$D1,1,64 --LL=$LL,1,64 ../source/slow $i > /dev/null
		mv callgrind.out.* "./callgrind/$cacheTam.$i.slow"
		valgrind -q --tool=callgrind --I1=$I1,1,64 --D1=$D1,1,64 --LL=$LL,1,64 ../source/fast $i > /dev/null
		mv callgrind.out.* "./callgrind/$cacheTam.$i.fast"

		#Ir  Dr  Dw  I1mr  D1mr  D1mw  ILmr  DLmr  DLmw

		#escribo en el fichero los resultados
		callgrind_annotate "./callgrind/$cacheTam.$i.slow" | head -n 30 | grep "PROGRAM TOTALS" | tr --delete , | awk -v tam="$i" '{printf tam"\t""%s""\t""%s""\t",$5,$6}' >> $file
		callgrind_annotate "./callgrind/$cacheTam.$i.fast" | head -n 30 | grep "PROGRAM TOTALS" | tr --delete , | awk '{print $5"\t"$6}' >> $file
		#mv $cacheTam.$i.* callgrind
	done
	
	#cacheTam va duplicandose cada iteracion
	cacheTam=$(expr $cacheTam \* 2)
done

bash ./dataFiles/makeGraphs

