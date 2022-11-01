//------------------------------------------------------------------------------
// KU Leuven - ESAT/COSIC- Embedded Systems & Security
//------------------------------------------------------------------------------
// Module Name:     gbprocessor - Behavioral
// Project Name:    CD and Verif
// Description:     The processor, containing the ALU and registers
//
// Revision     Date       Author     Comments
// v0.1         20211322   VlJo       Initial version
//
//------------------------------------------------------------------------------

module gbprocessor (
    input reset,
    input clock,
    input [7:0] instruction,
    input valid,
    output [2*8-1:0] probe
);

    logic [7:0] regA, regB, regC, regD, regE, regF, regH, regL;
    logic load_regA, load_regF;

    logic [7:0] alu_B, alu_Z;
    logic [3:0] alu_flags_out;


    assign load_regA = instruction[7] & ~instruction[6] & valid;
    assign load_regF = instruction[7] & ~instruction[6] & valid;
    assign probe = {regA, regF};

    /* second operand selector MUX */
    always_comb
    begin
        case(instruction[2:0])
            3'h0: alu_B <= regB;
            3'h1: alu_B <= regC;
            3'h2: alu_B <= regD;
            3'h3: alu_B <= regE;
            3'h4: alu_B <= regH;
            3'h5: alu_B <= regL;
            3'h6: alu_B <= 8'h0;
            default: alu_B <= regA;
        endcase
    end

    /* ALU */
    ALU ALU_inst00(
        .A(regA),
        .B(alu_B),
        .flags_in(regF[7:4]),
        .operation(instruction[5:3]),
        .Z(alu_Z),
        .flags_out(alu_flags_out));

    /* REGISTERS */
    always_ff @(posedge clock)
    begin
        if (reset)
        begin
            regA = 8'h0;
            regB = 8'h1;
            regC = 8'h2;
            regD = 8'h3;
            regE = 8'h4;
            regF = 8'h0;
            regH = 8'h5;
            regL = 8'h6;
        end else begin
            if (load_regA == 1'b1)
                regA = alu_Z;
            if (load_regF == 1'b1)
                regF = { alu_flags_out, 4'h0 };
        end
    end

endmodule
