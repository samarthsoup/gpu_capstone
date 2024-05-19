CXX = nvcc
ARGS = 512

all: clean build run

build:
	$(CXX) src/bitonic_sort.cu -o bin/bitonic_sort.out
	$(CXX) src/data_populator.cu -o bin/data_populator.out

run:
	bin/data_populator.out $(ARGS) 
	bin/bitonic_sort.out > data/output$(ARGS).txt

clean:
	rm -f bin/*
	rm -f data/*