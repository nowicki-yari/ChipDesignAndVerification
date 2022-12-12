//------------------------------------------------------------------------------
// KU Leuven - ESAT/COSIC- Embedded Systems & Security
//------------------------------------------------------------------------------
// Module Name:     ALU - Behavioral
// Project Name:    CD and Verif
// Description:     The ALU that will be tested on
//
// Revision     Date       Author     Comments
// v0.1         20211322   VlJo       Initial version
// v0.2         20221115   VlJo       Adding load instructions
//------------------------------------------------------------------------------

module gbprocessor (
    input reset,
    input clock,
    input [7:0] instruction,
    input [7:0] data,
    input valid,
    output [8*8-1:0] probe
);

    /* registers*/
    logic [7:0] regA, regB, regC, regD, regE, regF, regH, regL;
    logic load_regA_with_reg, load_regB_with_reg, load_regC_with_reg, load_regD_with_reg, load_regE_with_reg, load_regH_with_reg, load_regL_with_reg;
    logic load_regA_with_data, load_regB_with_data, load_regC_with_data, load_regD_with_data, load_regE_with_data, load_regH_with_data, load_regL_with_data;
    logic load_regA_fromALU;

    /* ALU */
    logic [7:0] alu_B, alu_BB, alu_Z;
    logic [3:0] alu_flags_out;

    logic [255:0] shifter;

    /* attach the probe to ALL the registers */
    assign probe = {regA, regB, regC, regD, regE, regF, regH, regL};


    /* control signals for load instructions */
    /* control signals for ALU instructions */
    assign load_regA_fromALU = instruction[7] & ~instruction[6];
    assign load_regF = instruction[7] & ~instruction[6];
    /*   from another register */
    assign load_regB_with_reg  = ~instruction[7] & instruction[6] & ~instruction[5] & ~instruction[4] & ~instruction[3];
    assign load_regC_with_reg  = ~instruction[7] & instruction[6] & ~instruction[5] & ~instruction[4] & instruction[3];
    assign load_regD_with_reg  = ~instruction[7] & instruction[6] & ~instruction[5] & instruction[4] & ~instruction[3];
    assign load_regE_with_reg  = ~instruction[7] & instruction[6] & ~instruction[5] & instruction[4] & instruction[3];

    assign load_regH_with_reg  = ~instruction[7] & instruction[6] & instruction[5] & ~instruction[4] & ~instruction[3];
    assign load_regL_with_reg  = ~instruction[7] & instruction[6] & instruction[5] & ~instruction[4] & instruction[3];
    assign load_regA_with_reg  = ~instruction[7] & instruction[6] & instruction[5] & instruction[4] & instruction[3];
    /*   from databus */
    assign load_regB_with_data = (instruction == 8'h06) ? 1'b1 : 1'b0;
    assign load_regC_with_data = (instruction == 8'h0E) ? 1'b1 : 1'b0;
    assign load_regD_with_data = (instruction == 8'h16) ? 1'b1 : 1'b0;
    assign load_regE_with_data = (instruction == 8'h1E) ? 1'b1 : 1'b0;
    // REG F
    assign load_regH_with_data = (instruction == 8'h26) ? 1'b1 : 1'b0;
    assign load_regL_with_data = (instruction == 8'h2E) ? 1'b1 : 1'b0;
    assign load_regA_with_data = (instruction == 8'h3E) ? 1'b1 : 1'b0;


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
            if (valid == 1'h1)
            begin
                if (load_regA_fromALU == 1'b1)
                    regA = alu_Z;
                else if (load_regA_with_data == 1'b1)
                    regA = data;
                else if (load_regA_with_reg == 1'b1)
                    regA = alu_B; // Changed alu_BB to alu_B

                if (load_regF == 1'b1)
                    regF = { alu_flags_out, 4'h0 };

                if (load_regB_with_data == 1'b1)
                    regB = data;
                else if (load_regB_with_reg == 1'b1)
                    regB = alu_B;

                if (load_regC_with_data == 1'b1)
                    regC = data;
                else if (load_regC_with_reg == 1'b1)
                    regC = alu_B;

                if (load_regD_with_data == 1'b1)
                    regD = data; //changed C with D
                else if (load_regD_with_reg == 1'b1)
                    regD = alu_B;

                if (load_regE_with_data == 1'b1)
                    regE = data;
                else if (load_regE_with_reg == 1'b1)
                    regE = alu_B;

                if (load_regH_with_data == 1'b1)
                    regH = data;
                else if (load_regH_with_reg == 1'b1)
                    regH = alu_B; // Changed L to H
                    
                if (load_regL_with_data == 1'b1)
                    regL = data;
                else if (load_regL_with_reg == 1'b1)
                    regL = alu_B;
            end
        end
    end

    always_ff @(posedge clock)
    begin
        if (reset)
            shifter = 256'h1;
        else
            shifter = (shifter << 1) | shifter >> (256-1);
    end

    always_comb
    begin
        alu_BB = alu_B[7:6] | alu_B[5] & shifter[176] | alu_B[4:0];
    end

endmodule
