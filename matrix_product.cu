#include <time.h>
#include <sys/time.h>
#include <stdio.h>
#include <stdlib.h>

#define N 10000


void initializeMatrices(int a[N][N], int b[N][N]) {
	srand(time(NULL));
	for (int i=0; i<N; i++) {
		for (int j=0; j<N; j++) {
			a[i][j] = rand() % 50;
			b[i][j] = rand() % 50;
		}
	}
}

__global__ void matrixProduct(int *a, int *b, int *c, int width) {
	int sum = 0;
	int row = threadIdx.y + blockDim.y * blockIdx.y;
	int col = threadIdx.x + blockDim.x * blockIdx.x;
	// printf("Thread in block position: (%d, %d) \n", row, col);
	if (col < width && row < width) {
		for (int k=0; k<width; k++) {
			sum += a[row * width + k] * b[k * width + col];
		}
		c[row * width + col] = sum;
	}
}

void showMatrices(int a[N][N], int b[N][N], int c[N][N]) {
	printf("***** MATRIX A *****\n");
	for (int i=0; i<N; i++) {
		for (int j=0; j<N; j++) {
			(j % N == N-1) ? printf("%d \n", a[i][j]) : printf("%d,", a[i][j]);
		}
	}
	printf("***** MATRIX B *****\n");
	for (int i=0; i<N; i++) {
		for (int j=0; j<N; j++) {
			(j % N == N-1) ? printf("%d \n", b[i][j]) : printf("%d,", b[i][j]);
		}
	}
	printf("***** MATRIX C *****\n");
	for (int i=0; i<N; i++) {
		for (int j=0; j<N; j++) {
			(j % N == N-1) ? printf("%d \n", c[i][j]) : printf("%d,", c[i][j]);
		}
	}
}

int main() {
	struct timeval t1, t2;
	gettimeofday(&t1, 0);

	int h_a[N][N], h_b[N][N], h_c[N][N];
	int *d_a, *d_b, *d_c;

	initializeMatrices(h_a, h_b);

	double size = (double) N * N * sizeof(int);
	cudaMalloc((void **) &d_a, size);
	cudaMalloc((void **) &d_b, size);
	cudaMalloc((void **) &d_c, size);

	cudaMemcpy(d_a, h_a, size, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, h_b, size, cudaMemcpyHostToDevice);

	dim3 dimGrid(1, 1);
	dim3 dimBlock(N, N);

	matrixProduct<<<dimGrid, dimBlock>>>(d_a, d_b, d_c, N);
	cudaDeviceSynchronize();
	cudaGetLastError();

	cudaMemcpy(h_c, d_c, size, cudaMemcpyDeviceToHost);

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	// showMatrices(a, b, c);

	cudaDeviceReset();

	gettimeofday(&t2, 0);
	double time = (1000000.0*(t2.tv_sec-t1.tv_sec) + t2.tv_usec-t1.tv_usec)/1000000.0;
	printf("Time to calculate:  %3.1f ms \n", time);
	
	return 0;
}
