/* A new class is made for the model :) */
class gameboyprocessor;

    /* Eight 8-bit registers */
    byte A;
    byte B;
    byte C;
    byte D;
    byte E;
    byte F;
    byte H;
    byte L;

    /* Upon creating an object, the registers
      are initialised. A simplication was done,
      because the LOAD instructions are not 
      implemented. Hence, all values are constant 
      (except for those of A and F).*/
    function new();
        this.A = 0;
        this.B = 1;
        this.C = 2;
        this.D = 3;
        this.E = 4;
        this.F = 0;
        this.H = 5;
        this.L = 6;
    endfunction : new

    /* A simple to string function to 
      consult the internals. */
    task toString();
        $display("REG A : %02X \t\t REG F : %02X", this.A, this.F);
        $display("REG B : %02X \t\t REG C : %02X", this.B, this.C);
        $display("REG D : %02X \t\t REG E : %02X", this.D, this.E);
        $display("REG H : %02X \t\t REG L : %02X", this.H, this.L);
    endtask : toString


    /* Here is the bread-and-butter of the 
       model. Similar to the DUT, an instruction
       can be fed to the model. The model 
       performs the same operation on its 
       internal registers as the DUT. */
    function shortint executeALUInstruction(byte instr);
      
        /******** content should go here ********/
        byte prev_value;
        //Returns the probe
        if (instr == 8'h8C)
        begin
            prev_value = this.A;
            this.A += this.H;
            if(this.A == 0)
            begin
                this.F = 8'h08;
            end else if (prev_value[4] != this.A[4] || prev_value[5] != this.A[5] || prev_value[6] != this.A[6] || prev_value[7] != this.A[7])
            begin
                this.F = 8'h02;
            end else if (prev_value > 128 && this.A < 8)
            begin
                this.F = 8'h03;
            end
        end
        return {this.A, this.F};

    endfunction : executeALUInstruction

endclass : gameboyprocessor


/* A small program to test the model */
program test_cpumodel;
    static gameboyprocessor gbmodel;
    shortint r;
    initial 
    begin
        /* instantiate model */
        gbmodel = new();

        /* show the initial values of the register file*/
        gbmodel.toString();

        /* ADC H => A = A + H + Cin => 0 + 5 + 0 = 5 = 0x5*/ 
        $display("Executing instruction 0x8C");
        r = gbmodel.executeALUInstruction(8'h8C);

        /* show the final values of the register file*/
        gbmodel.toString();


        $display("Executing instruction 0x8C");
        r = gbmodel.executeALUInstruction(8'h8C);
        gbmodel.toString();

        $display("Executing instruction 0x8C");
        r = gbmodel.executeALUInstruction(8'h8C);
        gbmodel.toString();

        $display("Executing instruction 0x8C");
        r = gbmodel.executeALUInstruction(8'h8C);
        gbmodel.toString();

    end
  
endprogram : test_cpumodel
