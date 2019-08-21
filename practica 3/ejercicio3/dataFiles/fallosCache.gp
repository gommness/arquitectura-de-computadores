#!/usr/bin/gnuplot
#chmod +x ejemploGNUplot.gp

# Salida por pantalla simple: sudo apt-get install gnuplot-x11; set term 11
set term dumb

#set data style points
set title "fallos cache"
set xlabel "tamanio matriz"
set ylabel "fallos cache"
plot "matrix.dat" using 1:4 with lines title "fallos escritura | normal", "matrix.dat" using 1:7 with lines title "fallos escritura | traspuesta"
set term jpeg
set output "fallosCacheESCRITURA.jpeg"
replot
plot "matrix.dat" using 1:3 with lines title "fallos lectura | normal", "matrix.dat" using 1:4 with lines title "fallos escritura | normal","matrix.dat" using 1:6 with lines title "fallos lectura | traspuesta", "matrix.dat" using 1:7 with lines title "fallos escritura | traspuesta"

# Para salida a un archivo tipo portable network graphics
set term jpeg
set output "fallosCache.jpeg"
replot

# Cierra el archivo de salida
set output
