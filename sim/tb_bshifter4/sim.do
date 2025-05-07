if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

set TOP_ENTITY {work.tb_bshifter4}

vlog -work work ../../rtl/mux2x1.sv
vlog -work work ../../rtl/bshifter4.sv

vlog -work work tb_bshifter4.sv

vsim -voptargs=+acc ${TOP_ENTITY}

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 100ns
