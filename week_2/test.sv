`include "gb_iface.sv"
`include "environment.sv"
`include "generator.sv"

program test (gb_iface ifc);

  environment env = new(ifc);
  generator gen = new();

  initial
  begin
    gen.run();
  end

endprogram : test
