#include <iostream>
#include <stdio.h>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>

#include "image_processing.hpp"

int main() {
    cv::Mat image = cv::imread("../Bini2.jpeg");
    cv::Mat image_output(cv::Size(image.cols, image.rows), CV_8UC1);
    clock_t begin = clock();
    grayScaleCPU(image.data, image.rows, image.cols, image.channels(), image_output.data);
    clock_t end = clock();
    double time = double(end - begin) / CLOCKS_PER_SEC;
    std::cout << "Time: " << time << std::endl;
    cv::imwrite("image_output_CPU.jpg", image_output);
    return 0;
}