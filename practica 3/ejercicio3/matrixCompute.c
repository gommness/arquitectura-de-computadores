#include "./../source/arqo3.h"
#include <string.h>
#include <sys/time.h>

void computeTRANSPOSED(int tam, num** matrixA, num** matrixB, num*** matrixC);
void computeNORMAL(int tam, num** matrixA, num** matrixB, num*** matrixC);
void printMatrix(int tam, num** matrix);
num** transpose(int tam, num** matrix);

int main(int argc, char** argv){
	num ** matrixA, ** matrixB, ** matrixC, **matrixTransposed;
	int dim, flag;
	struct timeval fin,ini;

	if(argc < 2)
	{
		fprintf(stderr,"numero de argumentos erroneo.\n./ejercicio3 [-t] <tamanio matriz>\n");
		return 1;
	}

	flag = strcmp("-t",argv[1]);
	if(argc == 3)
		dim = atoi(argv[2]);
	else if(argc == 2)
		dim = atoi(argv[1]);

	if(dim <= 0)
	{
		fprintf(stderr,"tamanio introducido invalido\n");
		return 1;
	}

	matrixA = generateMatrix(dim);
	matrixB = generateMatrix(dim);
	//matrixTransposed = generateEmptyMatrix(dim);
	matrixC = generateEmptyMatrix(dim);
	if(!matrixA || !matrixB || !matrixC)
	{
		fprintf(stderr,"error al inicializar las matrices\n");
		return 1;
	}
	
	if(flag == 0)//transposed
	{
		matrixTransposed = transpose(dim, matrixB);
		gettimeofday(&ini,NULL);
		computeTRANSPOSED(dim, matrixA, matrixTransposed, &matrixC);
		gettimeofday(&fin,NULL);
		freeMatrix(matrixTransposed);
	}
	else//not transposed
	{
		gettimeofday(&ini,NULL);
		computeNORMAL(dim, matrixA, matrixB, &matrixC);
		gettimeofday(&fin,NULL);
	}

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
void printMatrix(int tam, num** matrix){
	int i, j;
	printf("\n");
	for(i=0;i<tam;i++){
		for(j=0;j<tam;j++){
			printf(" %lf ", matrix[i][j]);
		}
		printf("\n");
	}
}

void computeNORMAL(int tam, num** matrixA, num** matrixB, num*** matrixC){
	int i, j, k;
	num aux;
	for(i=0;i<tam;i++)
	{
		for(j=0;j<tam;j++)
		{
			for(k=0, aux=0;k<tam;k++)
				aux += matrixA[i][k]*matrixB[k][j];
			(*matrixC)[i][j] = aux;
		}
	}
}

num** transpose(int tam, num** matrix){
	int i, j;

	num** matrixTransposed = generateEmptyMatrix(tam);

	for(i=0;i<tam;i++)
		for(j=0;j<tam;j++)
			matrixTransposed[j][i] = matrix[i][j];

	return matrixTransposed;
}

void computeTRANSPOSED(int tam, num** matrixA, num** matrixB, num*** matrixC){
	int i, j, k;
	num aux;

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



