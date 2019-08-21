#!/bin/bash

cd $(dirname $0)

tam=(1000 2000 5000 10000 20000 30000 40000 50000 100000)
hilos=(1 2 3 4)

rm ejercicio2outputs/*.output

for i in "${hilos[@]}"
do
	echo "tamanio tiempo" > "ejercicio2outputs/ejercicio2par-$i.output"
	for j in "${tam[@]}"
	do
		echo -e -n "$j " >> "ejercicio2outputs/ejercicio2par-$i.output"
		./../source/pescalar_par2 $j $i | grep "Tiempo" | cut -d' ' -f2 >> "ejercicio2outputs/ejercicio2par-$i.output"
	done
done

echo "tamanio tiempo" > "ejercicio2outputs/ejercicio2ser.output"
for j in "${tam[@]}"
do
	#echo -e "./../source/pescalar_serie $j\n$(./../source/pescalar_serie $j)"
	echo -e -n "$j " >> "ejercicio2outputs/ejercicio2ser.output"
	./../source/pescalar_serie $j | grep "Tiempo" | cut -d' ' -f2 >> "ejercicio2outputs/ejercicio2ser.output"
done

