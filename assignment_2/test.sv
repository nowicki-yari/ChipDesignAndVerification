`include "gb_iface.sv"
`include "environment.sv"

program test (gb_iface ifc);

  environment env = new(ifc);

  initial
  begin
    env.run();
  end

endprogram : test
