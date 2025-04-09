tclmode

set LIBERTY_PATH {/soft64/design-kits/stm/28nm-cmos28fdsoi_25d}
set LIB_CORE_LR  {C28SOI_SC_12_CORE_LR@2.0@20130411.0/libs/C28SOI_SC_12_CORE_LR_ss28_0.90V_125C.lib}
set LIB_PR_LR    {C28SOI_SC_12_PR_LR@2.0@20130412.0/libs/C28SOI_SC_12_PR_LR_tt28_1.00V_25C.lib}
set LIB_CLK_LR   {C28SOI_SC_12_CLK_LR@2.1@20130621.0/libs/C28SOI_SC_12_CLK_LR_tt28_1.00V_25C.lib}

set LEF_DEFKIT   {SiteDefKit_cmos28@1.4@20120720.0/LEF/sites.lef}
set LEF_TECHNO   {CadenceTechnoKit_cmos028FDSOI_6U1x_2U2x_2T8x_LB_LowPower@1.0.1@20121114.0/LEF/technology.12T.lef}
set LEF_CORE_LR  {C28SOI_SC_12_CORE_LR@2.0@20130411.0/CADENCE/LEF/C28SOI_SC_12_CORE_LR_soc.lef}
set LEF_PR_LR    {C28SOI_SC_12_PR_LR@2.0@20130412.0/CADENCE/LEF/C28SOI_SC_12_PR_LR_soc.lef}
set LEF_CLK_LR   {C28SOI_SC_12_CLK_LR@2.1@20130621.0/CADENCE/LEF/C28SOI_SC_12_CLK_LR_soc.lef}

set GOLDEN_TOP_MODULE   {mux2x1}
set GOLDEN_MODULE ../synth/fv/${GOLDEN_TOP_MODULE}/fv_map.v.gz

set REVISED_TOP_MODULE   {mux2x1}
set REVISED_MODULE ../synth/fv/${REVISED_TOP_MODULE}/fv_map.v.gz


# add path to the liberty libraries
add_search_path -both ${LIBERTY_PATH}

# load liberty libraries
# -both specifices both golden and revised designs
read_library -liberty -both ${LIB_CORE_LR} ${LIB_PR_LR} ${LIB_CLK_LR} 

# read golden model
read_design -verilog -lastmod -noelaborate -golden ${GOLDEN_MODULE}
elaborate_design -golden -root ${GOLDEN_TOP_MODULE}

# read revised model
read_design -verilog -lastmod -noelaborate -revised ${REVISED_MODULE}
elaborate_design -revised -root ${REVISED_TOP_MODULE}

# switch to lec mode; the tool starts in setup mode
set_system_mode lec -nomap

# map key points and save them to file; can be loaded from file later
map_key_points
write_mapped_points mapped_points.mp.txt

# add all compared points to the comparison
add_compared_points *

# throttle up the checker
set_compare_effort high

# enable time reporting and perform comparison
# report_compare_time -enable
compare

# tons of reporting stuff
report_compare_time
report_compare_data
report_statistics
usage
