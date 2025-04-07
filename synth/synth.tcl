set LIBERTY_PATH {/soft64/design-kits/stm/28nm-cmos28fdsoi_25d}
set LIB_CORE_LR  {C28SOI_SC_12_CORE_LR@2.0@20130411.0/libs/C28SOI_SC_12_CORE_LR_ss28_0.90V_125C.lib}
set LIB_PR_LR    {C28SOI_SC_12_PR_LR@2.0@20130412.0/libs/C28SOI_SC_12_PR_LR_tt28_1.00V_25C.lib}
set LIB_CLK_LR   {C28SOI_SC_12_CLK_LR@2.1@20130621.0/libs/C28SOI_SC_12_CLK_LR_tt28_1.00V_25C.lib}

set LEF_DEFKIT   {SiteDefKit_cmos28@1.4@20120720.0/LEF/sites.lef}
set LEF_TECHNO   {CadenceTechnoKit_cmos028FDSOI_6U1x_2U2x_2T8x_LB_LowPower@1.0.1@20121114.0/LEF/technology.12T.lef}
set LEF_CORE_LR  {C28SOI_SC_12_CORE_LR@2.0@20130411.0/CADENCE/LEF/C28SOI_SC_12_CORE_LR_soc.lef}
set LEF_PR_LR    {C28SOI_SC_12_PR_LR@2.0@20130412.0/CADENCE/LEF/C28SOI_SC_12_PR_LR_soc.lef}
set LEF_CLK_LR   {C28SOI_SC_12_CLK_LR@2.1@20130621.0/CADENCE/LEF/C28SOI_SC_12_CLK_LR_soc.lef}

set CAP_TABLE    {/soft64/design-kits/stm/28nm-cmos28lp_42/CadenceTechnoKit_cmos028_6U1x_2U2x_2T8x_LB@4.2.1/CAP_TABLE/FuncRCmax.captable}

set TOP_MODULE   {mux2x1}

set CLOCK_PIM    {clock}
set CLOCK_PERIOD {1000}

# enable verbosity 
#set_db information_level 9
set_db hdl_error_on_blackbox true

# folder to look for hdl sources
set_db init_hdl_search_path {../rtl}

# load actual files

#read_hdl -vhdl any_vhdl_here
#read_hdl -v2001 any_old_verilog_here
read_hdl -sv {mux2x1.sv}

# folder to look for libraries (Liberty)
set_db init_lib_search_path ${LIBERTY_PATH}

#set_db library {$LIB_CORE_LR $LIB_PR_LR $LIB_CLK_LR}
set_db library "${LIB_CORE_LR} ${LIB_PR_LR} ${LIB_CLK_LR}"
set_db lef_library "${LEF_DEFKIT} ${LEF_TECHNO} ${LEF_CORE_LR} ${LEF_PR_LR} ${LEF_CLK_LR}"
set_db cap_table_file ${CAP_TABLE}

# start elaboration
elaborate ${TOP_MODULE}

set_db syn_generic_effort high
set_db syn_map_effort high
set_db syn_opt_effort high

# Apply design constraints for logic synthesis
# Define clock with 1000ps period, no external timing slack, clock transition time (slew rate) of 100ps
set clock [define_clock -period ${CLOCK_PERIOD} -name ${CLOCK_PIN} [clock_ports]]
#set_input_delay -clock ${clock} 0 [vfind /designs/${DESIGN}/ports -port *]
#set_output_delay -clock ${clock} 0 [vfind /designs/${DESIGN}/ports -port *]
#dc::set_clock_transition .1 ${clock}

# check unresolved references
check_design –unresolved 

syn_generic
write_netlist [current_design] > outputs/gen_netlist.v

report_timing > ./reports/gen_report_timing.rpt
report_power -by_hierarchy  > reports/gen_report_power.rpt
report_area > ./reports/gen_report_area.rpt
report_qor > ./reports/gen_report_qor.rpt

write_sdc > outputs/gen_dds_sdc.sdc

syn_map
write_netlist [current_design] > outputs/map_netlist.v

report_timing > ./reports/map_report_timing.rpt
report_power -by_hierarchy  > reports/map_report_power.rpt
report_area > ./reports/map_report_area.rpt
report_qor > ./reports/map_report_qor.rpt

# out gate level design
write_sdc > outputs/map_dds_sdc.sdc

# same as "write_hdl > outputs/dds_netlist.v"
#write_netlist [current_design] > outputs/netlist.v

write_snapshot -innovus -directory layout -tag logical [current_design] 

# show results
# gui_show