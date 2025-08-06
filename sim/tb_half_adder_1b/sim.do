if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

vlog -work work ../../rtl/half_adder_1b.sv
vlog -work work tb_half_adder_1b.sv

vsim -voptargs=+acc work.tb_half_adder_1b

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 100ns
