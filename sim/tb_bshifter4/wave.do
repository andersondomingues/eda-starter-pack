onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mux2x1/mux_a/clock
add wave -noupdate /tb_mux2x1/mux_a/reset
add wave -noupdate /tb_mux2x1/mux_a/a
add wave -noupdate /tb_mux2x1/mux_a/b
add wave -noupdate /tb_mux2x1/mux_a/sel
add wave -noupdate /tb_mux2x1/mux_a/out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {55814 ps} {60221 ps}
