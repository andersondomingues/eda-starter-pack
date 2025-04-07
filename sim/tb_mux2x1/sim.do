if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

set TOP_ENTITY {work.tb_mux2x1}

vlog -work work ../../rtl/mux2x1.sv

vlog -work work tb_mux2x1.sv

vsim -voptargs=+acc ${TOP_ENTITY}

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 100ns
