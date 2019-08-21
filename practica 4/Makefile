LIBS = 
LIB_DIR =  
FLAGS = -g -lgomp -Wall -D_GNU_SOURCE -fopenmp

.PHONY: clean all

all: source/omp1 source/omp2 source/pescalar_serie source/pescalar_par1 source/pescalar_par2 ejercicio3/code/matrixComputePar1 ejercicio3/code/matrixComputePar2 ejercicio3/code/matrixComputePar3 ejercicio3/code/matrixComputeSerie clear

source/omp1: source/omp1.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

source/omp2: source/omp2.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

source/pescalar_serie: source/pescalar_serie.c source/arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

source/pescalar_par1: source/pescalar_par1.c source/arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

source/pescalar_par2: source/pescalar_par2.c source/arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

ejercicio3/code/matrixComputePar1: ejercicio3/code/matrixComputePar1.c source/arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

ejercicio3/code/matrixComputePar2: ejercicio3/code/matrixComputePar2.c source/arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

ejercicio3/code/matrixComputePar3: ejercicio3/code/matrixComputePar3.c source/arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

ejercicio3/code/matrixComputeSerie: ejercicio3/code/matrixComputeSerie.c source/arqo4.c
	gcc $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ source/omp1 source/omp2 source/pescalar_serie source/pescalar_par1 source/pescalar_par2 ejercicio3/code/matrixComputePar1 ejercicio3/code/matrixComputePar2 ejercicio3/code/matrixComputePar3 ejercicio3/code/matrixComputeSerie
	
clear:
	rm -f *.o *~
