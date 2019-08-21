// ----------- Arqo P4-----------------------
// pescalar_par2
//
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include "arqo4.h"

int main(int argc, char* argv[])
{
	int nHilos, tam;
	float *A=NULL, *B=NULL;
	long long k=0;
	struct timeval fin,ini;
	float sum=0;

	if(argc < 2){
		fprintf(stderr,"error de formato. siga este formato:\n./pescalar_par2 <tamano vector> [numero de hilos]\n");
		return 1;
	} else if(argc == 2){
		tam = atoi(argv[1]);
		nHilos = 1;
	} else if(argc == 3){
		tam = atoi(argv[1]);
		nHilos = atoi(argv[2]);
	}

	A = generateVector(tam);
	B = generateVector(tam);
	if ( !A || !B )
	{
		printf("Error when allocationg matrix\n");
		freeVector(A);
		freeVector(B);
		return -1;
	}
	
	omp_set_num_threads(nHilos);

	gettimeofday(&ini,NULL);
	/* Bloque de computo */
	sum = 0;
	#pragma omp parallel for reduction(+:sum)
	for(k=0;k<tam;k++)
	{
		sum = sum + A[k]*B[k];
	}
	/* Fin del computo */
	gettimeofday(&fin,NULL);

	printf("Resultado: %f\n",sum);
	printf("Tiempo: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	freeVector(A);
	freeVector(B);

	return 0;
}
