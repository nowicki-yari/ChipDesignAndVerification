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
        .reset(gb_i.reset),
        .valid(gb_i.valid),
        .instruction(gb_i.instruction),
        .probe(gb_i.probe)
    );

    initial begin
        gb_i.reset <= 1'h1;
        repeat(5) @(posedge clock);
        gb_i.reset <= 1'h0;
        repeat(10) @(posedge clock);
        gb_i.instruction <= 8'h8c;
        gb_i.valid <= 1'h1;
        repeat(10) @(posedge clock);
    end

endmodule
