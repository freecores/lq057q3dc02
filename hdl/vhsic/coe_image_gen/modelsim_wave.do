onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic /lq057q3dc02_tb/rstx
add wave -noupdate -format Logic /lq057q3dc02_tb/clk_lcd
add wave -noupdate -divider -height 30 VSYNCx_Controller
add wave -noupdate -format Literal /lq057q3dc02_tb/uut/v_c/vsyncx_c/line_cntr_cs
add wave -noupdate -format Literal -radix unsigned /lq057q3dc02_tb/uut/v_c/vsyncx_c/line_num
add wave -noupdate -format Logic /lq057q3dc02_tb/vsyncx
add wave -noupdate -divider -height 25 HSYNCx_Controller
add wave -noupdate -format Logic /lq057q3dc02_tb/hsyncx
add wave -noupdate -format Literal -radix unsigned /lq057q3dc02_tb/uut/v_c/hsyncx_c/num_hsyncx_clocks
add wave -noupdate -divider -height 30 ENAB_Controller
add wave -noupdate -format Logic /lq057q3dc02_tb/uut/v_c/enab_c/enab
add wave -noupdate -divider -height 30 P_E_Counter
add wave -noupdate -format Literal -radix unsigned /lq057q3dc02_tb/uut/v_c/p_e_cntr/p_e_clk_num
add wave -noupdate -format Literal /lq057q3dc02_tb/uut/v_c/p_e_cntr/p_e_cntr_curr_st
add wave -noupdate -divider -height 30 Image_Gen
add wave -noupdate -format Logic /lq057q3dc02_tb/uut/image/sinit_wire
add wave -noupdate -format Literal -radix unsigned /lq057q3dc02_tb/uut/image/addr_wire
add wave -noupdate -divider -height 30 {COLOR DATA}
add wave -noupdate -format Literal /lq057q3dc02_tb/r
add wave -noupdate -format Literal /lq057q3dc02_tb/g
add wave -noupdate -format Literal /lq057q3dc02_tb/b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15799505000 ps} 0}
configure wave -namecolwidth 361
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
update
WaveRestoreZoom {15798415982 ps} {15800791221 ps}
