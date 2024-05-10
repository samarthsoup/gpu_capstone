# Bitonic sort using GPU and Cuda

Bitonic sort is a sorting technique that is very easily parallelised. As the size of the input increases, the advantage of using a GPU over a CPU increases.

# Instructions for running the program

1. Navigate to the directory that contains the Makefile.

2. Run <code>make all</code> in the terminal. 

3. Sorted array will also be stored in an 'output.txt' file.

### This is how GPU compares with CPU for bitonic sort:
---

Input size: 32

GPU Time: 0.048192 ms

CPU Time: 0.007 ms

---
Input size: 256

GPU Time: 0.101408 ms

CPU Time: 0.071 ms

---

Input size: 512

GPU Time: 0.120832 ms

CPU Time: 0.155 ms

---

Input size: 1024

GPU Time: 0.148512 ms

CPU Time: 0.345 ms

---

Input size: 3000

GPU Time: 0.195616 ms

CPU Time: 1.559 ms

---
Input size: 10000

GPU Time: 0.262144 ms

CPU Time: 7.19 ms

---

Input size: 30000

GPU Time: 0.306304 ms

CPU Time: 18.431 ms

---