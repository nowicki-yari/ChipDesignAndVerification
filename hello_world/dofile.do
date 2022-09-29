vlib work

vlog -sv ALU_i.sv
vcom alu.vhd
vlog -sv top.sv

vsim -voptargs="+acc" Top

add wave sim:/Top/dut/A
add wave sim:/Top/dut/B
add wave sim:/Top/dut/flags_in
add wave sim:/Top/dut/flags_out
add wave sim:/Top/dut/operation
add wave sim:/Top/dut/Z

restart -f

run -a

