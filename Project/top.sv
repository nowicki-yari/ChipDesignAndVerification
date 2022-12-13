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

    // At least 1000 logical instructions are done
    covergroup cg_logical_1000@(posedge clock);
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

    // At least 100 load instruction with each register
    covergroup cg_load_with_every_register @(posedge clock);
        option.at_least = 100;
        load_instr: coverpoint gb_i.instruction[7:6] iff(gb_i.valid && !gb_i.reset){ 
            bins ld_i = {1};
        }

        regs: coverpoint gb_i.instruction[2:0] iff(gb_i.valid && !gb_i.reset){ 
            bins B = {0};
            bins C = {1};
            bins D = {2};
            bins E = {3};
            bins H = {4};
            bins L = {5};
            bins A = {7};

        }

        cx: cross load_instr, regs {
            bins xB = binsof(load_instr.ld_i) && binsof(regs.B);
            bins xC = binsof(load_instr.ld_i) && binsof(regs.C);
            bins xD = binsof(load_instr.ld_i) && binsof(regs.D);
            bins xE = binsof(load_instr.ld_i) && binsof(regs.E);
            bins xH = binsof(load_instr.ld_i) && binsof(regs.H);
            bins xL = binsof(load_instr.ld_i) && binsof(regs.L);
            bins xA = binsof(load_instr.ld_i) && binsof(regs.A);
        }
    endgroup

    // At least 100 arith and log instructions with each register
    covergroup cg_arithmetic_or_logic_with_every_register @(posedge clock);
        option.at_least = 100;
        instr: coverpoint gb_i.instruction[7:5] iff(gb_i.valid && !gb_i.reset){ 
            bins ar_i = {4}; //100
            bins lg_i = {5}; //101
        }

        regs: coverpoint gb_i.instruction[2:0] iff(gb_i.valid && !gb_i.reset){ 
            bins B = {0};
            bins C = {1};
            bins D = {2};
            bins E = {3};
            bins H = {4};
            bins L = {5};
            bins A = {7};

        }

        cx_ar: cross instr, regs {
            bins xB = binsof(instr.ar_i) && binsof(regs.B);
            bins xC = binsof(instr.ar_i) && binsof(regs.C);
            bins xD = binsof(instr.ar_i) && binsof(regs.D);
            bins xE = binsof(instr.ar_i) && binsof(regs.E);
            bins xH = binsof(instr.ar_i) && binsof(regs.H);
            bins xL = binsof(instr.ar_i) && binsof(regs.L);
            bins xA = binsof(instr.ar_i) && binsof(regs.A);
        }

        cx_lg: cross instr, regs {
            bins xB = binsof(instr.lg_i) && binsof(regs.B);
            bins xC = binsof(instr.lg_i) && binsof(regs.C);
            bins xD = binsof(instr.lg_i) && binsof(regs.D);
            bins xE = binsof(instr.lg_i) && binsof(regs.E);
            bins xH = binsof(instr.lg_i) && binsof(regs.H);
            bins xL = binsof(instr.lg_i) && binsof(regs.L);
            bins xA = binsof(instr.lg_i) && binsof(regs.A);
        }
    endgroup

    // We don't want to LD with zero too much as this will set all registers to zero 
    // (a constraint limits this to 10% with a LD data instruction)
    // but we still want to test this.
    covergroup cg_load_with_zero @(posedge clock);
        option.at_least = 20;
        instr: coverpoint gb_i.instruction[7:6] iff(gb_i.valid && !gb_i.reset){ 
            bins ld_i = {0}; //00
        }

        oper: coverpoint gb_i.instruction[2:0] iff(gb_i.valid && !gb_i.reset){ 
            bins op_i = {6}; //110
        }

        data_i: coverpoint gb_i.data[7:0] iff(gb_i.valid && !gb_i.reset){ 
            bins d_i = {0};
        }

        cx_ld_with_0: cross instr, oper, data_i {
            bins xLD_zero = binsof(instr.ar_i) && binsof(oper.op_i) && binsof(data_i.d_i);
        }
    endgroup



    // make an instance of cg1
    initial begin
        cg_logical_1000 inst_cg_logical_1000;
        cg_CP_100 inst_cg_CP_100;
        cg_LD_then_AR_or_LOG inst_cg_LD_then_AR_or_LOG;
        cg_load_with_every_register inst_cg_load_with_every_register;
        cg_arithmetic_or_logic_with_every_register inst_cg_arithmetic_or_logic_with_every_register;
        cg_load_with_zero inst_cg_load_with_zero; 

        inst_cg_logical_1000 = new();
        inst_cg_CP_100 = new();
        inst_cg_LD_then_AR_or_LOG = new();
        inst_cg_load_with_every_register = new();
        inst_cg_arithmetic_or_logic_with_every_register = new();
        inst_cg_load_with_zero = new();

    end

    

endmodule : Top
