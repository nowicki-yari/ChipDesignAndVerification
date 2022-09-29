/***
 * The interface
 ***/
interface demo_iface ( input logic clock );
  logic [7:0] data_in;
  logic data_valid;
  logic [7:0] data_out;
endinterface

/***
 * The DUT
 ***/
module inverting_register(demo_iface di);
  always @(posedge di.clock)
  begin
    if(di.data_valid)
      di.data_out <= ~di.data_in;
  end
endmodule



/***
 * Test environment
 ***/
module Top;
  logic clock=0;

  // clock generation - 100 MHz
  always #5 clock = ~clock;

  // instantiate an interface
  demo_iface theInterface (
    .clock(clock)
  );

  // instantiate the DUT and connect it to the interface
  inverting_register dut (
    .di(theInterface)
  );

  // provide stimuli
  initial begin
    theInterface.data_in <= 8'h0;
    theInterface.data_valid <= 1'b0;
    repeat (10) @(posedge clock);

    theInterface.data_in <= 8'h12;
    theInterface.data_valid <= 1'b1;
    @(posedge clock);
    theInterface.data_valid <= 1'b0;
    @(posedge clock);

    theInterface.data_in <= 8'h55;
    theInterface.data_valid <= 1'b1;
    @(posedge clock);
    theInterface.data_valid <= 1'b0;
    @(posedge clock);

    repeat (1000) @(posedge clock);
    $finish;
  end

endmodule
