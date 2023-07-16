#include <iostream>
#include <math.h>

void grayScaleCUDA(unsigned char* input_image, int height, int width, int channels, unsigned char* output_image);
void grayScaleCPU(unsigned char* input_image, int height, int width, int channels, unsigned char* output_image);
unsigned char* createImageBuffer(unsigned int bytes);
void destroyImageBuffer(unsigned char* bytes);
