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
    gbprocessor DUT (
        .reset(gb_i.reset),
        .clock(clock),
        .instruction(gb_i.instruction),
        .valid(gb_i.valid),
        .probe(gb_i.probe)
    );

    // SV testing 
    test tst(gb_i);

    // Coverage

    // At least 100 XORs are executed after immediately after a SBC
    covergroup cg_XOR_100_after_SBC @(posedge clock);
        option.at_least = 100;
        
        XOR_100_after_SBC: coverpoint gb_iface.instruction[3:5] iff(gb_iface.valid && !gb_iface.reset){
            bins xor_bin = {5};
            bins sbc_bin = {3};

            bins xor_after_sbc = (3 => 5);
        }
    
    endgroup


    // At least 1000 CPs are executed
    covergroup cg_CP_1000 @(posedge clock);
        option.at_least = 1000;
        CP_1000: coverpoint gb_iface.instruction[3:5] iff(gb_iface.valid && !gb_iface.reset){ 
            bins cp_bin = {7};
        }
    endgroup

    // At least 20 SUB instructions should be done with register E
    covergroup cg_SB_20 @(posedge clock);
        
        SB_20: coverpoint gb_iface.instruction[3:5] iff(gb_iface.valid && !gb_iface.reset){ 
            bins sb_bin = {2};
        }

        regE: coverpoint gb_iface.instruction[0:2] iff(gb_iface.valid && !gb_iface.reset){ 
            bins regE_bin = {5};
        }

        cx: cross SB_20, regE {
            bins x1 = binsof(SB_20.sb_bin) && binsof(regE.regE_bin);
        }
    endgroup    


    // The amount of arithmetic operations should roughly be 3 times the amount of logical operations
    //ar3_v_log1: coverpoint gb_iface.instruction; //Constraint?

    
    

    // At least 327 logical instructions are done without register A
    covergroup logical_327_no_regA @(posedge clock);
        option.at_least = 327;

        cp_ALU_instruction_type: coverpoint gb_iface.instruction[5] iff(gb_iface.valid && !gb_iface.reset){ 
            bins arithmetic = {0};
            bins logical = {1};
        }
        cp_regA: coverpoint gb_iface.instruction[2:0] iff(gb_iface.valid && !gb_iface.reset){ 
            bins regA = {0};
        }

        cx: cross cp_ALU_instruction_type, cp_regA {
            bins x1 = binsof(cp_ALU_instruction_type.logical) && !binsof(cp_regA.regA);
        }
    endgroup

    // make an instance of cg1
    initial begin
        cg_XOR_100_after_SBC inst_cg_XOR_100_after_SBC;
        logical_327_no_regA inst_logical_327_no_regA;
        cg_CP_1000 inst_cg_CP_1000;
        cg_SB_20 inst_cg_SB_20;
        
        inst_cg_XOR_100_after_SBC = new();
        inst_logical_327_no_regA = new();
        inst_cg_CP_1000 = new();
        inst_cg_SB_20 = new();

    end

    

endmodule : Top
