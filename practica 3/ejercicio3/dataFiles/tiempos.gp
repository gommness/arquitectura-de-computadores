#!/usr/bin/gnuplot
#chmod +x ejemploGNUplot.gp

# Salida por pantalla simple: sudo apt-get install gnuplot-x11; set term 11
set term dumb

#set data style points
set title "tiempo"
set xlabel "tamanio matriz"
set ylabel "tiempo empleado"
plot "matrix.dat" using 1:2 with lines title "normal", "matrix.dat" using 1:5 with lines title "traspuesta"

# Para salida a un archivo tipo portable network graphics
set term jpeg
set output "tiempos.jpeg"
replot

# Cierra el archivo de salida
set output
