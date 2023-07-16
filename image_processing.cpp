#include "image_processing.hpp"

void grayScaleCPU(uint8_t *input_image, int width, int height, int channels, uint8_t *output_image)
{
    int sum = 0;
    int r, g, b;
    for (int x = 0; x < width; x++)
    {
        for (int y = 0; y < height; y++)
        {
            b = input_image[(height * x + y) * channels];
            g = input_image[(height * x + y) * channels + 1];
            r = input_image[(height * x + y) * channels + 2];
            sum = (r + g + b) / 3;
            output_image[height * x + y] = sum;
        }
    }
}