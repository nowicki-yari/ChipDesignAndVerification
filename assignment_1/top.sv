module ALU(ALU_iface alu_i);

/*** Test environment ***/
module Top;
    logic clock=0;

    // clock generation - 100 MHz
    always #5 clock = ~clock;

    // instantiate an interface
    ALU_iface theInterface (
        .clock(clock)
    );

    ALU dut(
        .alu_i(theInterface)
    );

    initial begin
        theInterface.data_a <= 8'h0;
        theInterface.data_b <= 8'h0;
        theInterface.flags_in <= 4'h0;
        theInterface.operation <= 3'h0;
        for (int i = 0; i <= 255; i++) begin
            repeat (10) @(posedge clock);
            theInterface.data_b += 8'b1;
        end
        repeat (1000) @(posedge clock);
        //$finish;
    end

endmodule