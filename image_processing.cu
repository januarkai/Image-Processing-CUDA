#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include "image_processing.hpp"

// Indexing function for 2D image + RGB Channels
__device__ int index2D(int Channels) {
	int blockId = blockIdx.x + blockIdx.y * gridDim.x;
	int idx = (blockId * (blockDim.x * blockDim.y)+ (threadIdx.y * blockDim.x)+ threadIdx.x) * Channels;
	return idx;
}


// Kernel function to run image grayscle computations
__global__ void grayScale_kernel(unsigned char* image, int channels, unsigned char* output){

	int idx = index2D(channels);
	int r, g, b, temp;

	b = image[idx];
	g = image[idx + 1];
	r = image[idx + 2];
	
	temp = (b+g+r)/3;

	output[idx/ channels] = temp;

}


// CPU function to initialize CUDA kernel and memory copy 
void grayScaleCUDA(unsigned char* input_image, int height, int width, int channels, unsigned char* output_image){
    
    unsigned char* dev_input_image = NULL;
	unsigned char* dev_output_image = NULL;
	int size = sizeof(int);

	cudaMalloc((void**)&dev_input_image, height * width * channels);
	cudaMalloc((void**)&dev_output_image, height * width * channels);

	cudaMemcpy(dev_input_image, input_image, height * width * channels, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_output_image, output_image, height * width, cudaMemcpyHostToDevice);


	dim3 Thread_Index(32, 32);
	dim3 Grid_Image(width/Thread_Index.x+1, height/Thread_Index.y+1);
	grayScale_kernel<<<Grid_Image, Thread_Index>>>(dev_input_image, channels, dev_output_image);

	cudaMemcpy(output_image, dev_output_image, height * width, cudaMemcpyDeviceToHost);

	cudaDeviceSynchronize();

	cudaFree(dev_input_image);
	cudaFree(dev_output_image);
}

unsigned char* createImageBuffer(unsigned int bytes) {

    unsigned char *ptr = NULL;
    cudaSetDeviceFlags(cudaDeviceMapHost);
    cudaHostAlloc(&ptr, bytes, cudaHostAllocMapped);
    return ptr;
}

void destroyImageBuffer(unsigned char* bytes) {
    cudaFreeHost(bytes);
}