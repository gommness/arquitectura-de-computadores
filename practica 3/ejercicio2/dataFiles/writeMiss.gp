#!/usr/bin/gnuplot
#chmod +x ejemploGNUplot.gp

# Salida por pantalla simple: sudo apt-get install gnuplot-x11; set term 11
set term dumb

#set data style points
set title "fallos escritura"
set xlabel "tamanio matriz"
set ylabel "fallos en escritura"
plot "1.dat" using 1:3 with lines title "slow 16K", "2.dat" using 1:3 with lines title "slow 32K", "4.dat" using 1:3 with lines title "slow 64K", "8.dat" using 1:3 with lines title "slow 128K", "1.dat" using 1:5 with lines title "fast 16K", "2.dat" using 1:5 with lines title "fast 32K", "4.dat" using 1:5 with lines title "fast 64K", "8.dat" using 1:5 with lines title "fast 128K"

# Para salida a un archivo tipo portable network graphics
set term jpeg
set output "graficaFallosEscritura.jpeg"
replot

# Cierra el archivo de salida
set output
