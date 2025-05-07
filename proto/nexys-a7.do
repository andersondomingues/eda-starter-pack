set PROJECT_NAME bshifter_fpga
set PROJECT_CONSTRAINT_FILE nexys-a7/Nexys-A7-100T-TP2.xdc
set DIR_OUTPUT /sim/layout
set TOP_MODULE top_nexys_a7

file mkdir ${DIR_OUTPUT}
create_project -force ${PROJECT_NAME} ${DIR_OUTPUT}/${PROJECT_NAME} -part xc7a100tcsg324-1

# hdl files
add_files ../rtl/mux2x1.sv
add_files ../rtl/bshifter4.sv
add_files ../rtl/bshifter16.sv

# fpga-specific files
add_files ./nexys-a7/dspl_drv_NexysA7.v
add_files ./nexys-a7/${TOP_MODULE}.sv

import_files -force
import_files -fileset constrs_1 -force -norecurse ${PROJECT_CONSTRAINT_FILE}

# automatically locate top file and fix compile order
update_compile_order -fileset sources_1

# launch synthesis
launch_runs synth_1
wait_on_run synth_1
open_run synth_1 -name netlist_1

# timing and power reports
report_timing_summary -delay_type max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -file ${DIR_OUTPUT}/syn_timing.rpt
report_power -file ${DIR_OUTPUT}/syn_power.rpt

# launch implementation
set_property STEPS.PHYS_OPT_DESIGN.IS_ENABLED true [get_runs impl_1]
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1 

# timing and power reports
# open_run impl_1
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 10 -input_pins -file ${DIR_OUTPUT}/imp_timing.rpt
report_power -file ${DIR_OUTPUT}/imp_power.rpt

# comment out the for batch mode
# start_gui

# connect to the hardware manager
open_hw_manager
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets *]
open_hw_target

# device programming
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
set_property PROGRAM.FILE ${DIR_OUTPUT}/${PROJECT_NAME}/${PROJECT_NAME}.runs/impl_1/${TOP_MODULE}.bit [lindex [get_hw_devices] 0]
#set_property PROBES.FILE ${DIR_OUTPUT}/${PROJECT_NAME}/${PROJECT_NAME}.runs/impl_1/${TOP_MODULE}.ltx [lindex [get_hw_devices] 0]

program_hw_devices [lindex [get_hw_devices] 0]
refresh_hw_device [lindex [get_hw_devices] 0]

quit

