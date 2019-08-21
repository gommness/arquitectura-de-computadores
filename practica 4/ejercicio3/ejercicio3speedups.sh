#!/bin/bash
echo "accediendo a datos"
timeSerie=$(cat ejercicio3.output | head -n 2 | tail -n 1)
timeV=$(cat ejercicio3.output | head -n 3 | tail -n 1)
#timeV2=$(cat ejercicio3.output | head -n 4 | tail -n 1)
#timeV3=$(cat ejercicio3.output | tail -n 1)

echo "creando fichero"
echo "version/hilos 1 2 3 4" > ejercicio3speedups.output
echo "Serie 1 1 1 1" >> ejercicio3speedups.output

for i in $(seq 1 1 3) #bucle para recorrer las versiones. recorre filas
do
	echo "calculando speedup de version $i"
	echo -n "version$i " >> ejercicio3speedups.output
	for j in $(seq 2 1 5) #bucle para recorrer el numero de hilos. recorre columnas
	do
		timeAuxPar=$(echo "$timeV" | cut -d' ' -f$j)
		timeAuxSer=$(echo "$timeSerie" | cut -d' ' -f$j)
		speedup=$(echo "scale=4;$timeAuxSer/$timeAuxPar" | bc)
		echo -n "$speedup " >> ejercicio3speedups.output
	done
	timeV=$(cat ejercicio3.output | head -n $(expr 3 + $i) | tail -n 1)
	echo "" >> ejercicio3speedups.output
done
