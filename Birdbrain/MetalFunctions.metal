//
//  MetalFunctions.metal
//  Birdbrain
//
//  Created by Jorden Hill on 10/9/15.
//  Copyright © 2015 Jorden Hill. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

kernel void sigmoid(device float *x [[ buffer(0) ]], device float *y [[ buffer(1) ]],
                    uint id [[ thread_position_in_grid ]]) {
  y[id] = 1.0 / (1.0 + exp(-x[id]));
}

kernel void tanh(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                 uint id [[thread_position_in_grid]]) {
  y[id] = tanh(x[id]);
}

kernel void relu(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                 uint id [[thread_position_in_grid]]) {
  y[id] = fmax(x[id], 0.0);
}

kernel void sigmoid_prime(device float *x[[buffer(0)]], device float *y [[buffer(1)]],
                          uint id [[thread_position_in_grid]]) {
  y[id] = (1.0 / (1.0 + exp(-x[id]))) * (1.0 - (1.0 / (1.0 + exp(-x[id]))));
}

kernel void tanh_prime(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                       uint id [[thread_position_in_grid]]) {
  y[id] = 1 - pow(tanh(x[id]), 2);
}

kernel void relu_prime(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                       uint id [[thread_position_in_grid]]) {
  y[id] = x[id] <= 0.0 ? 0.0 : 1.0;
}

kernel void add(device float *x [[buffer(0)]], device float *y [[buffer(1)]], device float
                *z [[buffer(2)]], uint id [[thread_position_in_grid]]) {
  z[id] = x[id] + y[id];
}

kernel void scalar_add(device float *A [[buffer(0)]], constant float *c [[buffer(1)]],
                       device float *y [[buffer(2)]], uint id[[thread_position_in_grid]]) {
  y[id] = A[id] + c[0];
}

kernel void subtract(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                     device float *z [[buffer(2)]], uint id [[thread_position_in_grid]]) {
  z[id] = x[id] - y[id];
}

kernel void scalar_subtract(device float *A [[buffer(0)]], constant float *c [[buffer(1)]],
                            device float *y [[buffer(2)]], uint id[[thread_position_in_grid]]) {
  y[id] = A[id] - c[0];
}

kernel void multiply(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                     device float *z [[buffer(2)]], uint id [[thread_position_in_grid]]) {
  z[id] = x[id] * y[id];
}

kernel void scalar_multiply(device float *A [[buffer(0)]], constant float *c [[buffer(1)]],
                            device float *y [[buffer(2)]], uint id[[thread_position_in_grid]]) {
  y[id] = A[id] * *c;
}

typedef struct
{
  ushort m, n;
} MetalMatrixDim;

kernel void matrixvector_multiply(device float *A [[buffer(0)]], device float *x [[buffer(1)]],
                                  constant MetalMatrixDim& dims [[ buffer(2) ]],
                                  device float *y [[buffer(3)]],
                                  uint id[[thread_position_in_grid]]) {
  int m = (int) dims.m;
  int n = (int) dims.n;
  
  float sum = 0.0f;
  for (int k = 0; k < n; k++) {
      sum += A[id * m + k] * x[k];
  }
    
  y[id] = sum;
}

kernel void divide(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                   device float *z [[buffer(2)]], uint id [[thread_position_in_grid]]) {
  z[id] = x[id] / y[id];
}

kernel void scalar_divide(device float *A [[buffer(0)]], constant float *c [[buffer(1)]],
                          device float *y [[buffer(2)]], uint id[[thread_position_in_grid]]) {
  y[id] = A[id] / c[0];
}

kernel void exp(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                uint id [[thread_position_in_grid]]) {
  y[id] = exp(x[id]);
}

kernel void square(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                   uint id [[thread_position_in_grid]]) {
  y[id] = x[id] * x[id];
}

kernel void neg(device float *x [[buffer(0)]], device float *y [[buffer(1)]],
                uint id [[thread_position_in_grid]]) {
  y[id] = -x[id];
}
