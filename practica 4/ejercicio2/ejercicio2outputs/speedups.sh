#!/bin/bash

tam=($(cat ejercicio2ser.output | tail -n +2 | awk '{print $1}'))
ser=($(cat ejercicio2ser.output | tail -n +2 | awk '{print $2}'))

echo "tamanio speedUpV1 speedUpV2 speedUpV3 speedUpV4" > speedups.output

for j in $(seq 0 1 8)
do
	echo -n "${tam[$j]} " >> speedups.output
	for i in $(seq 1 1 4)
	do
		par=($(cat ejercicio2par-$i.output | tail -n +2 | awk '{print $2}'))
		speedup=$(echo "scale=10;${ser[$j]}/${par[$j]}" | bc)
		echo -n "$speedup " >> speedups.output
	done
	echo "" >> speedups.output
done
