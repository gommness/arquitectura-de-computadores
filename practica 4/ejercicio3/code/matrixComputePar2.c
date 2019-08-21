#include "../../source/arqo4.h"
#include <string.h>
#include <sys/time.h>
#include <omp.h>

void computeTRANSPOSED(int tam, float** matrixA, float** matrixB, float*** matrixC);
void computeNORMAL(int tam, float** matrixA, float** matrixB, float*** matrixC);
void printMatrix(int tam, float** matrix);
float** transpose(int tam, float** matrix);

int n_hilos;

int main(int argc, char** argv){
	float ** matrixA, ** matrixB, ** matrixC;
	int dim;
	struct timeval fin,ini;

	if(argc <= 2)
	{
		fprintf(stderr,"numero de argumentos erroneo.\n./ejercicio3 <tamanio matriz> <numero hilos>\n");
		return 1;
	}

	if(argc == 3){
		dim = atoi(argv[1]);
		n_hilos = atoi(argv[2]);
	}

	if(dim < 1 || n_hilos < 1)
	{
		fprintf(stderr,"parametros invalidos\n");
		return 1;
	}

	//printf("dimension: %d\nn_hilos: %d\n",dim,n_hilos);

	matrixA = generateMatrix(dim);
	matrixB = generateMatrix(dim);
	//matrixTransposed = generateEmptyMatrix(dim);
	matrixC = generateEmptyMatrix(dim);
	if(!matrixA || !matrixB || !matrixC)
	{
		fprintf(stderr,"error al inicializar las matrices\n");
		return 1;
	}
	
	gettimeofday(&ini,NULL);
	computeNORMAL(dim, matrixA, matrixB, &matrixC);
	gettimeofday(&fin,NULL);

	printf("%f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);

	//printMatrix(dim, matrixA);
	//printMatrix(dim, matrixB);
	//printMatrix(dim, matrixC);

	freeMatrix(matrixA);
	freeMatrix(matrixB);
	freeMatrix(matrixC);
	return 0;
}

//function used for debugging purposes only
void printMatrix(int tam, float** matrix){
	int i, j;
	printf("\n");
	for(i=0;i<tam;i++){
		for(j=0;j<tam;j++){
			printf(" %lf ", matrix[i][j]);
		}
		printf("\n");
	}
}

void computeNORMAL(int tam, float** matrixA, float** matrixB, float*** matrixC){
	int i, j, k;
	float aux;

	omp_set_num_threads(n_hilos);

	for(i=0;i<tam;i++)
	{
		#pragma omp parallel for firstprivate(tam, i) private(aux, k, j) shared(matrixC, matrixA, matrixB)
		for(j=0;j<tam;j++)
		{
			for(k=0, aux=0;k<tam;k++)
				aux += matrixA[i][k]*matrixB[k][j];
			(*matrixC)[i][j] = aux;
		}
	}
}

float** transpose(int tam, float** matrix){
	int i, j;

	float** matrixTransposed = generateEmptyMatrix(tam);

	for(i=0;i<tam;i++)
		for(j=0;j<tam;j++)
			matrixTransposed[j][i] = matrix[i][j];

	return matrixTransposed;
}

void computeTRANSPOSED(int tam, float** matrixA, float** matrixB, float*** matrixC){
	int i, j, k;
	float aux;

	//printMatrix(tam, matrixB);

	for(i=0;i<tam;i++)
	{
		for(j=0;j<tam;j++)
		{
			for(k=0, aux=0;k<tam;k++)
				aux += matrixA[i][k]*matrixB[j][k];
			(*matrixC)[i][j] = aux;
		}
	}
}



