CXX = nvcc
ARGS = 512

all: clean build

build:
	$(CXX) src/bitonic_sort.cu -o bin/bitonic_sort.out
	$(CXX) src/data_populator.cu -o bin/data_populator.out

run:
	bin/data_populator.out $(ARGS)
	bin/bitonic_sort.out

clean:
	rm -f bin/bitonic_sort.out bin/data_populator.out data/generated_data.txt data/output.txt