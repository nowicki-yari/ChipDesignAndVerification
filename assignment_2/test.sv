/*
`include "gb_iface.sv"
`include "environment.sv"

program test (gb_iface ifc);
*/
`include "generator.sv"
program test();
  /*
  environment env = new(ifc);

  initial
  begin
    env.run();
  end
  */

  generator gen = new();

  initial
  begin
    gen.run();
  end

endprogram : test
