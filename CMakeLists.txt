cmake_minimum_required (VERSION 3.8)
project (Improc)

find_package(CUDA REQUIRED)
find_package(OpenCV REQUIRED)

include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
    message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()

# Enable compile optimizations
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")

# use sse3 instruction set
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -msse -msse2 -msse3")

# include directory
include_directories(${CUDA_INCLUDE_DIRS} ${OpenCV_INCLUDE_DIRS})

# CUDA

set(ALL_CUDA_LIBS ${CUDA_LIBRARIES} ${CUDA_cusparse_LIBRARY} ${CUDA_cublas_LIBRARY})
set(LIBS ${LIBS} ${ALL_CUDA_LIBS})
set(CUDA_SEPARABLE_COMPILATION OFF)
set(CUDA_NVCC_FLAGS ${CUDA_NVCC_FLAGS} -arch sm_86 -gencode arch=compute_86,code=sm_86)

#GPU
# Set files the build
set(sources_gpu image_processing.cu)
CUDA_COMPILE(CU_O ${sources_gpu})

set(source_cpu image_processing.cpp)

#
add_executable(improcCUDA mainCUDA.cpp ${CU_O})
target_link_libraries(improcCUDA ${OpenCV_LIBS} ${LIBS})

add_executable(improcCPU mainCPU.cpp ${source_cpu})
target_link_libraries(improcCPU ${OpenCV_LIBS} ${LIBS})