#!/usr/bin/gnuplot
#chmod +x ejemploGNUplot.gp

# Salida por pantalla simple: sudo apt-get install gnuplot-x11; set term 11
set term dumb

#set data style points
set title "tiempos"
set xlabel "tamaño"
set ylabel "tiempo de ejecución"
plot "ejercicio1.dat" using 1:2 with lines title "slow", "ejercicio1.dat" using 1:3 with lines title "fast"

# Para salida a un archivo tipo portable network graphics
set term jpeg
set output "ejercicio1.jpeg"
replot

# Cierra el archivo de salida
set output

pause -1 "Pulse Enter para continuar"
