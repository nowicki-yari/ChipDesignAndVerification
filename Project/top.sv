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
        .data(gb_i.data),
        .valid(gb_i.valid),
        .probe(gb_i.probe)
    );

    // SV testing 
    test tst(gb_i);

    // Coverage
/*
    // At least 100 XORs are executed after immediately after a SBC
    covergroup cg_XOR_100_after_SBC @(posedge clock);
        option.at_least = 100;
        
        XOR_100_after_SBC: coverpoint gb_i.instruction[5:3] iff(gb_i.valid && !gb_i.reset){
            bins xor_bin = {5};
            bins sbc_bin = {3};

            bins xor_after_sbc = (3 => 5);
        }
    
    endgroup
    */

    
    /*
    // At least 20 SUB instructions should be done with register E
    covergroup cg_SB_20 @(posedge clock);
        option.at_least = 20;
        SB_20: coverpoint gb_i.instruction[5:3] iff(gb_i.valid && !gb_i.reset){ 
            bins sb_bin = {2};
        }

        regE: coverpoint gb_i.instruction[2:0] iff(gb_i.valid && !gb_i.reset){ 
            bins regE_bin = {3};
        }

        cx: cross SB_20, regE {
            bins x1 = binsof(SB_20.sb_bin) && binsof(regE.regE_bin);
        }
    endgroup    


    // The amount of arithmetic operations should roughly be 3 times the amount of logical operations
    //ar3_v_log1: coverpoint gb_iface.instruction; //Constraint

    
    
    */

    // At least 100 CPs are executed
    covergroup cg_CP_100 @(posedge clock);
        option.at_least = 100;
        CP_1000: coverpoint gb_i.instruction[5:3] iff(gb_i.valid && !gb_i.reset){ 
            bins cp_bin = {7};
        }
    endgroup

    // At least 100 logical instructions are done
    covergroup logical_1000@(posedge clock);
        option.at_least = 1000;

        cp_ALU_instruction_type: coverpoint gb_i.instruction[5] iff(gb_i.valid && !gb_i.reset){ 
            bins arithmetic = {0};
            bins logical = {1};
        }
    endgroup

    // At least 100 arithmetic or logical instructions after LD
    covergroup cg_LD_then_AR_or_LOG @(posedge clock);
        option.at_least = 100;
        cp_ALU_instruction_type: coverpoint gb_i.instruction[7:6] iff(gb_i.valid && !gb_i.reset){ 
            bins load = {1};
            bins log_or_ar = {2};

            bins log_or_ar_follows_load = (1 => 2);
        }
    endgroup


    // make an instance of cg1
    initial begin
        logical_1000 inst_logical_1000;
        cg_CP_100 inst_cg_CP_100;
        cg_LD_then_AR_or_LOG inst_cg_LD_then_AR_or_LOG;

        inst_logical_1000 = new();
        inst_cg_CP_100 = new();
        inst_cg_LD_then_AR_or_LOG = new();

    end

    

endmodule : Top
