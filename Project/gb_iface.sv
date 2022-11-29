`ifndef SV_IFC_ALU
`define SV_IFC_ALU

interface gb_iface(
  input logic clock
);

  bit reset;
  bit valid;

  logic [7:0] instruction;
  logic [63:0] probe;
  logic [7:0] data;

endinterface

`endif
