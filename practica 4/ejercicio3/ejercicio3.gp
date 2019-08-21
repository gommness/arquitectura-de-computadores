#!/usr/bin/gnuplot
#chmod +x ejemploGNUplot.gp

# Salida por pantalla simple: sudo apt-get install gnuplot-x11; set term 11
set term dumb

#set data style points
set title "ejercicio3"
set xlabel "tamanio vector"
set ylabel "tiempo (s)"
plot "bestPerformances.dat" using 1:2 with lines title "serie", "bestPerformances.dat" using 1:3 with lines title "paralelo v3 4 hilos"

# Para salida a un archivo tipo portable network graphics
set term jpeg
set output "ejercicio3tiempos.jpeg"
replot

#set data style points
set title "ejercicio3"
set xlabel "tamanio vector"
set ylabel "speedup"
plot "bestPerformances.dat" using 1:4 with lines title "speedup"

# Para salida a un archivo tipo portable network graphics
set term jpeg
set output "ejercicio3speedup.jpeg"
replot

# Cierra el archivo de salida
set output
