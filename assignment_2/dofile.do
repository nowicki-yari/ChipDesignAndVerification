vcom ALU.vhd

vlog -sv driver.sv
vlog -sv environment.sv
vlog -sv gb_iface.sv
vlog -sv gbprocessor.sv 
vlog -sv test.sv
vlog -sv top.sv 

vsim -voptargs="+acc" Top
