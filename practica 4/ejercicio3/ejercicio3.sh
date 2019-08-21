#!/bin/bash

make clean
make

echo "version/hilos 1 2 3 4" > ejercicio3.output

echo -n "matrixComputeSerie " >> ejercicio3.output

echo -e "ejecutando computación con hilos en serie\n"

for i in $(seq 1 1 4)
do
	time=$(./code/matrixComputeSerie 1000)
	echo -n "$time " >> ejercicio3.output
done
echo "" >> ejercicio3.output

echo -e "ejecutando computación con hilos en paralelo\n"
for j in $(seq 1 1 3)
do
	echo -e "\nversion $j\n"
	echo -n "matrixComputePar$j " >> ejercicio3.output
	for i in $(seq 1 1 4)
	do
		echo "$i hilos"
		time=$(./code/matrixComputePar$j 1000 $i)
	        echo -n "$time " >> ejercicio3.output
	done
    echo "" >> ejercicio3.output
done

