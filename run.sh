#!/usr/bin/env bash
make clean build

make run ARGS="256"
make run ARGS="512"
make run ARGS="1024"
make run ARGS="4096"
make run ARGS="10000"
make run ARGS="30000"