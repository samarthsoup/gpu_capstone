#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <cuda.h>
#include <iostream>
#include <cstdlib>
#include <ctime>
#include <algorithm>
#include <iostream>
#include <fstream>

#define MAX_THREADS_PER_BLOCK 1024

void bitonicSortCPU(int* arr, int n) 
{
    for (int k = 2; k <= n; k *= 2) {
        for (int j = k / 2; j > 0; j /= 2) {
            for (int i = 0; i < n; i++) {
                int ij = i ^ j;

                if (ij > i) {
                    if ((i & k) == 0) {
                        if (arr[i] > arr[ij]){
                            int temp = arr[i];
                            arr[i] = arr[ij];
                            arr[ij] = temp;
                        }
                    } else {
                        if (arr[i] < arr[ij]){
                            int temp = arr[i];
                            arr[i] = arr[ij];
                            arr[ij] = temp;
                        }
                    }
                }
            }
        }
    }
}

__global__ void bitonicSortGPU(int* arr, int j, int k)
{
    unsigned int i, ij;

    i = threadIdx.x + blockDim.x * blockIdx.x;

    ij = i ^ j;

    if (ij > i) {
        if ((i & k) == 0) {
            if (arr[i] > arr[ij]) {
                int temp = arr[i];
                arr[i] = arr[ij];
                arr[ij] = temp;
            }
        } else {
            if (arr[i] < arr[ij]) {
                int temp = arr[i];
                arr[i] = arr[ij];
                arr[ij] = temp;
            }
        }
    }
}

void printArray(int* arr, int size) 
{
    for (int i = 0; i < size; ++i)
        std::cout << arr[i] << " ";
    std::cout << std::endl;
}

bool isSorted(int* arr, int size) 
{
    for (int i = 1; i < size; ++i) 
    {
        if (arr[i] < arr[i - 1])
            return false;
    }
    return true;
}

bool isPowerOfTwo(int num) 
{
    return num > 0 && (num & (num - 1)) == 0;
}

int nextPowerOfTwo(int n) {
    if (n && !(n & (n - 1))) {
        return n;
    }
    
    n--;
    n |= n >> 1;
    n |= n >> 2;
    n |= n >> 4;
    n |= n >> 8;
    n |= n >> 16;
    n++;

    return n;
}


int main() 
{   
    std::ifstream infile("data/generated_data.txt");
    if (!infile) {
        std::cerr << "Error opening file.\n";
        return 1;
    }

    int input_size = 0;
    infile >> input_size;

    int size;
    if (input_size <= 0) {
        std::cerr << "Array size must be a positive integer\n";
        return 1;
    }

    if (!isPowerOfTwo(input_size)) {   
        std::cout << "Size provided is not a power of two, size will be the next power of two and remaining spots of the array will be padded with zeroes\nSize provided: " << input_size << std::endl;
        size = nextPowerOfTwo(input_size);
        std::cout << "The nearest higher power of two is: " << size << std::endl;
    } else {
        size = input_size;
    }

    int* arr = new int[size];
    int* carr = new int[size];
    int* temp = new int[size];

    int* gpuArrbiton;
    int* gpuTemp;

    srand(static_cast<unsigned int>(time(nullptr)));
    for (int i = 0; i < input_size; ++i) {
        if (!(infile >> arr[i])) {
            std::cerr << "Error reading number at position " << i + 1 << ".\n";
            delete[] arr;
            return 1;
        }
        carr[i] = arr[i];
    }

    infile.close();

    for (int i = input_size; i < size; ++i) {
        arr[i] = 0;
        carr[i] = 0;
    }

    cudaMalloc((void**)&gpuTemp, size * sizeof(int));
    cudaMalloc((void**)&gpuArrbiton, size * sizeof(int));

    cudaMemcpy(gpuArrbiton, arr, size * sizeof(int), cudaMemcpyHostToDevice);

    cudaEvent_t startGPU, stopGPU;
    cudaEventCreate(&startGPU);
    cudaEventCreate(&stopGPU);
    float GPU_time_ms = 0;

    clock_t startCPU, endCPU;

    int threadsPerBlock = MAX_THREADS_PER_BLOCK;
    int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;

    
    int j, k;

    cudaEventRecord(startGPU);
    for (k = 2; k <= size; k <<= 1) {
        for (j = k >> 1; j > 0; j = j >> 1) {
            bitonicSortGPU << <blocksPerGrid, threadsPerBlock >> > (gpuArrbiton, j, k);
        }
    }
    cudaEventRecord(stopGPU);

    cudaMemcpy(arr, gpuArrbiton, size * sizeof(int), cudaMemcpyDeviceToHost);
    cudaEventSynchronize(stopGPU);
    cudaEventElapsedTime(&GPU_time_ms, startGPU, stopGPU);

    startCPU = clock();
    bitonicSortCPU(carr, size);
    endCPU = clock();
    

    double CPU_time_ms = static_cast<double>(endCPU - startCPU) / (CLOCKS_PER_SEC / 1000.0);
    
    if (isSorted(arr, size))
        std::cout << "\n\nSORT CHECKER RUNNING - SUCCESFULLY SORTED GPU ARRAY" << std::endl;
    else
        std::cout << "SORT CHECKER RUNNING - !!! FAIL !!!" << std::endl;
   
    if (isSorted(carr, size))
        std::cout << "SORT CHECKER RUNNING - SUCCESFULLY SORTED CPU ARRAY" << std::endl;
    else
        std::cout << "SORT CHECKER RUNNING - !!! FAIL !!!" << std::endl;

    std::cout << "\n\nGPU Time: " << GPU_time_ms << " ms" << std::endl;
    std::cout << "CPU Time: " << CPU_time_ms << " ms" << std::endl;

    std::ofstream outfile("data/output.txt");
    if (!outfile) {
        std::cerr << "Error opening output file.\n";
        delete[] arr;
        return 1;
    }

    for (int i = size-input_size; i < size; ++i) {
        outfile << arr[i] << " ";
    }

    outfile.close();

    delete[] arr;
    delete[] carr;
    delete[] temp;

    cudaFree(gpuArrbiton);
    cudaFree(gpuTemp);

    return 0;
}