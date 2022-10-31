`include "gb_iface.sv"
`include "test.sv"

/*** Test environment ***/
module Top;
    logic clock=0;

    // clock generation - 100 MHz
    always #5 clock = ~clock;

    // instantiate an interface
    gb_iface gb_i (
        .clock(clock)
    );

    gbprocessor DUT(
        .clock(gb_i.clock),
        .reset(gb_i.reset),
        .valid(gb_i.valid),
        .instruction(gb_i.instruction),
        .probe(gb_i.probe)
    );

    // SV testing 
    test tst(gb_i);

endmodule : Top
