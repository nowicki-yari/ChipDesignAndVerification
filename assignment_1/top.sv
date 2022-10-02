/*** Test environment ***/
module Top;
    logic clock=0;

    // clock generation - 100 MHz
    always #5 clock = ~clock;

    // instantiate an interface
    ALU_iface theInterface (
        .clock(clock)
    );

    ALU DUT(
        .A(theInterface.data_a),
        .B(theInterface.data_b),
        .flags_in(theInterface.flags_in),
        .Z(theInterface.data_z),
        .flags_out(theInterface.flags_out),
	.operation(theInterface.operation)
    );

    initial begin
        theInterface.data_a <= 8'h0;
        theInterface.data_b <= 8'h0;
        //theInterface.flags_in <= 4'h0;
        //theInterface.operation <= 3'h0;
        for (int i = 0; i <= 255; i++) begin
            @(posedge clock);
            theInterface.data_b += 8'b1;
        end
        //$finish;
    end

endmodule
