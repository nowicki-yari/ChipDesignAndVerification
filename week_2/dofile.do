vcom ALU.vhd

vlog -sv driver.sv
vlog -sv environment.sv
vlog -sv gb_iface.sv
vlog -sv gbprocessor.sv 
vlog -sv generator.sv
vlog -sv monitor.sv
vlog -sv test.sv
vlog -sv top.sv 
vlog -sv transaction.sv

vsim -voptargs="+acc" Top

add wave sim:/Top/gb_i/clock
add wave sim:/Top/gb_i/reset
add wave sim:/Top/gb_i/valid
add wave sim:/Top/gb_i/instruction
add wave sim:/Top/gb_i/probe

add wave sim:/Top/DUT/regA
add wave sim:/Top/DUT/regB
add wave sim:/Top/DUT/regC
add wave sim:/Top/DUT/regD
add wave sim:/Top/DUT/regE
add wave sim:/Top/DUT/regF
add wave sim:/Top/DUT/regH
add wave sim:/Top/DUT/regL
