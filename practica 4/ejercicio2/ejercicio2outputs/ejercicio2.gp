#!/usr/bin/gnuplot
#chmod +x ejemploGNUplot.gp

# Salida por pantalla simple: sudo apt-get install gnuplot-x11; set term 11
set term dumb

#set data style points
set title "ejercicio2"
set xlabel "tamanio vector"
set ylabel "tiempo (s)"
plot "ejercicio2par-1.output" using 1:2 with lines title "paralelo 1 hilo", "ejercicio2par-2.output" using 1:2 with lines title "paralelo 2 hilos", "ejercicio2par-3.output" using 1:2 with lines title "paralelo 3 hilos", "ejercicio2par-4.output" using 1:2 with lines title "paralelo 4 hilos", "ejercicio2ser.output" using 1:2 with lines title "serie"

# Para salida a un archivo tipo portable network graphics
set term jpeg
set output "ejercicio2.jpeg"
replot

set xlabel "tamanio vector"
set ylabel "speedup"
plot "speedups.output" using 1:2 with lines title "1 hilo", "speedups.output" using 1:3 with lines title "2 hilos", "speedups.output" using 1:4 with lines title "3 hilos", "speedups.output" using 1:5 with lines title "4 hilos"
set term jpeg
set output "ejercicio2speedups.jpeg"
replot

# Cierra el archivo de salida
set output
