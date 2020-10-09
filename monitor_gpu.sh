#!/bin/bash

# ----------------------------------------
# A shell script that monitor gpu's usage.
# ----------------------------------------

if [ "$1" == "intel" ]; then
	sudo intel_gpu_top
elif [ "$1" == "nvidia" ]; then
	sudo watch -n 1 nvidia-smi
else
	echo "Invalid gpu (intel|nvidia)"
fi
