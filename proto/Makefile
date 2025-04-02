SHELL := /bin/bash

OUT_MODULE := $(shell command -v module 2> /dev/null)
OUT_VSIM := $(shell command -v vivado -version 2> /dev/null)

ifndef OUT_MODULE
	CMD := $(CMD) source /soft64/source_gaph ;
endif
ifndef OUT_VSIM
	CMD := $(CMD) module load vivado ;
endif

all:
	$(CMD) vivado -mode tcl -source nexys-a7.do
	
clean:
	rm -rf vivado*.jou vivado*.log .Xil
