# Instructions for running the program

1. Navigate to the directory that contains the 'run.sh' file.

2. Run <code>./run.sh</code> in the terminal. 

3. Sorted array will be stored in an 'output.txt' file.

# Changing input size using CLI arguments:

1. Go to the 'run.sh' file.

2. Change the variable 'ARGS' to have any value you want(doesn't have to be a power of 2).

Running 'run.sh' without the 'ARGS' will also work(by default the value for 'ARGS' is 512 as mentioned in the Makefile).

# Bitonic sort using GPU and Cuda

Bitonic sort is a sorting technique that is very easily parallelised. As the size of the input increases, the advantage of using a GPU over a CPU increases.

## How it works

### Bitonic Sequence: 
This is a sequence of numbers with two halves, where one half is monotonically increasing, and the other is monotonically decreasing. For example, [1, 4, 6, 8, 7, 5, 3, 2] is a bitonic sequence.

### Step 1: Divide array into bitonic subsequences
If the array is not initially in a bitonic sequence, you can recursively divide and sort the sequence into bitonic subsequences by repeatedly reversing halves until each part becomes bitonic.

### Step 2: Bitonic merge
Once you have a bitonic sequence, you can apply the bitonic merge step:
1. Divide the bitonic sequence into two halves.
2. Compare and swap elements across the middle, ensuring that the first half is sorted in ascending order and the second half is sorted in descending order.
3. Recursively apply this to each half until the entire sequence is sorted.

### Overview:
The sorting phase uses bitonic merges. Initially, it forms small bitonic sequences and merges them to sort larger subarrays:
1. Divide the entire array into small sorted subsequences.
2. Expand the bitonic subsequences to create longer ones.
3. Use the bitonic merge to sort them fully.

## Why input size needs to be a power of 2
During the sorting and merging phases, the input array is recursively divided into smaller sub-arrays, which also need to be of even size. With a power-of-2 input size, you can guarantee that every sub-array can be evenly divided.

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