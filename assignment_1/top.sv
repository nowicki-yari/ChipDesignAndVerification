module DUT(
    input wire A,
    input wire B,
    input wire flags_in,
    input wire operation,
    output wire Z,
    output wire flags_out,
);
endmodule

/*** Test environment ***/
module Top;
    logic clock=0;

    // clock generation - 100 MHz
    always #5 clock = ~clock;

    // instantiate an interface
    ALU_iface theInterface (
        .clock(clock)
    );

    DUT ALU(
        .A(theInterface.data_a)
        .B(theInterface.data_b)
        .flags_in(theInterface.flags_in)
        .operation(theInterface.operation)
        .Z(theInterface.data_z)
        .flags_out(theInterface.flags_out)
    );

    initial begin
        theInterface.data_a <= 8'h0;
        theInterface.data_b <= 8'h0;
        theInterface.flags_in <= 4'h0;
        theInterface.operation <= 3'h0;
        for (int i = 0; i <= 255; i++) begin
            @(posedge clock);
            theInterface.data_b += 8'b1;
        end
        repeat (1000) @(posedge clock);
        //$finish;
    end

endmodule