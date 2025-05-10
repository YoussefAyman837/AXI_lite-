vlib work
vsim -voptargs=+acc work.AXI_top -classdebug -uvmcontrol=all -cover
add wave /AXI_top/clk
add wave /AXI_top/AXI_interface/*
coverage save AXI_top.ucdb -onexit
run -all