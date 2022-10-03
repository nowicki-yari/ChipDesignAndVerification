vcom ALU.vhd

vlog -sv gbprocessor.sv 
vlog -sv top.sv 
vlog -sv ALU_i.sv

vsim -voptargs="+acc" Top