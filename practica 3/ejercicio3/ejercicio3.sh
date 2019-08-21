#!/bin/bash
cd $(dirname $0)
rm -f matrixCompute
gcc -o matrixCompute matrixCompute.c ../source/arqo3.c
rm ./callgrind/normal.*
rm ./callgrind/transp.*

P=23
min=$P
max=$(expr $P + 512)
file="./dataFiles/matrix.dat"
echo -e "tamanio\ttiempoNormal\tD1mrNormal\tD1mwNormal\ttiempoTrasp\tD1mrTrasp\tD1mwTrasp" > $file
for i in $(seq $min 16 $max)
do
	echo -e "\nmatriz: $i\n"
	#tam_matriz tiempo_normal D1mr_normal D1mw_normal tiempo_trasp D1mr_trasp D1mw_trasp
	time1=$(valgrind -q --tool=callgrind --I1=32768,8,64 --D1=32768,8,64 --LL=262144,8,64 ./matrixCompute $i)
	mv callgrind.out.* callgrind/"normal.$i"
	time2=$(valgrind -q --tool=callgrind --I1=32768,8,64 --D1=32768,8,64 --LL=262144,8,64 ./matrixCompute -t $i)
	mv callgrind.out.* callgrind/"transp.$i"
	callgrind_annotate callgrind/"normal.$i" | head -n 30 | grep "PROGRAM TOTALS" | tail -n 1 | tr --delete , | awk -v tam="$i" -v time="$time1" '{printf tam"\t"time"\t""%s""\t""%s""\t",$5,$6}' >> $file
	callgrind_annotate callgrind/"transp.$i" | head -n 30 | grep "PROGRAM TOTALS" | tail -n 1 | tr --delete , | awk -v time="$time2" '{print time"\t"$5"\t"$6}' >> $file
done
