`include "gb_iface.sv"
`include "test.sv"

module Top;
    logic clock=0;

    // clock generation - 100 MHz
    always #5 clock = ~clock;

    // instantiate an interface
    gb_iface gb_i (
        .clock(clock)
    );

    // instantiate the DUT and connect it to the interface
    gbprocessor dut (
        .reset(gb_i.reset),
        .clock(clock),
        .instruction(gb_i.instruction),
        .valid(gb_i.valid),
        .probe(gb_i.probe)
    );

    // SV testing 
    test tst(gb_i);

endmodule : top
