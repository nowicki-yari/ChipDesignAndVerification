/* A new class is made f| the model :) */
class gameboyprocessor;
    string s;
    byte carry;
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
      (except f| those of A & F).*/
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
      /*
    task toString();
        $display("REG A : %02X \t\t REG F : %02X", this.A, this.F);
        $display("REG B : %02X \t\t REG C : %02X", this.B, this.C);
        $display("REG D : %02X \t\t REG E : %02X", this.D, this.E);
        $display("REG H : %02X \t\t REG L : %02X", this.H, this.L);
    endtask : toString
*/
    task toString();
        $timeformat(-9,0," ns" , 10); /* format timing */
        s = $sformatf("[%t | GBP] I sampled %x (with actual gameboymodel)", $time, {this.A, this.B, this.C, this.D, this.E, this.F, this.H, this.L});
        $display(s);
    endtask : toString

    /* Here is the bread-&-butter of the 
       model. Similar to the DUT, an instruction
       can be fed to the model. The model 
       perf|ms the same operation on its 
       internal registers as the DUT. */
    function longint executeALUInstruction(byte instr);
        /******** content should go here ********/
        
        // Arithmetic | logic
        if (instr[7:6] == 2'b10)
        begin
            if(instr[5:3] == 3'b000) // ADD
            begin
                this.F[4] = 1'b0;
                if(instr[2:0] == 3'b000) // B
                begin
                    carry = computeCarry(this.B, 1'b0); 
                    this.A = this.A + this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    carry = computeCarry(this.C, 1'b0); 
                    this.A = this.A + this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    carry = computeCarry(this.D, 1'b0); 
                    this.A = this.A + this.D;
                    this.F[5] = carry[3];
                    this.F[4] = carry[7];
                end else if(instr[2:0] == 3'b011) // E
                begin
                    carry = computeCarry(this.E, 1'b0);
                    this.A = this.A + this.E;                   
                end else if(instr[2:0] == 3'b100) // H
                begin
                    carry = computeCarry(this.H, 1'b0); 
                    this.A = this.A + this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    carry = computeCarry(this.L, 1'b0); 
                    this.A = this.A + this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    carry = computeCarry(8'h00, 1'b0);
                    this.A = this.A + 8'h00;
                end else begin // A
                    carry = computeCarry(this.A, 1'b0); 
                    this.A = this.A + this.A;  
                end
                if (this.A == 0)
                begin
                    this.F[7] = 1'b1; // Set if result is 0
                end else begin
                    this.F[7] = 1'b0;
                end
                this.F[6] = 1'b0; // Reset
                this.F[5] = carry[3];
                this.F[4] = carry[7];
            end else if (instr[5:3] == 3'b001) // ADC
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    carry = computeCarry(this.B, 1'b0); 
                    this.A = this.A + this.B;
                    
                end else if(instr[2:0] == 3'b001) // C
                begin
                     carry = computeCarry(this.C, 1'b0); 
                    this.A = this.A + this.C;
                   
                end else if(instr[2:0] == 3'b010) // D
                begin
                    carry = computeCarry(this.D, 1'b0); 
                    this.A = this.A + this.D;
                    
                end else if(instr[2:0] == 3'b011) // E
                begin
                    carry = computeCarry(this.E, 1'b0); 
                    this.A = this.A + this.E;
                    
                end else if(instr[2:0] == 3'b100) // H
                begin
                    carry = computeCarry(this.H, 1'b0); 
                    this.A = this.A + this.H;
                    
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    carry = computeCarry(this.L, 1'b0); 
                    this.A = this.A + this.L;
                   
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    carry = computeCarry(8'h00, 1'b0); 
                    this.A = this.A + 8'h00 + carry[7];
                    
                end else begin // A
                    carry = computeCarry(this.A, 1'b0); 
                    this.A = this.A + this.A;
                    
                end
                if (this.A == 0)
                begin
                    this.F[7] = 1'b1; // Set if result is 0
                end else begin
                    this.F[7] = 1'b0;
                end
                this.F[6] = 1'b0;
                this.F[5] = carry[3];
                this.F[4] = carry[7];
            end else if ((instr[5:3] == 3'b010)) // SUB
            begin
                this.F[4] = 1'b1;
                if(instr[2:0] == 3'b000) // B
                begin
                    carry = computeCarry(this.B, 1'b1); 
                    this.A = this.A - this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    carry = computeCarry(this.C, 1'b1); 
                    this.A = this.A - this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    carry = computeCarry(this.D, 1'b1); 
                    this.A = this.A - this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    carry = computeCarry(this.E, 1'b1); 
                    this.A = this.A - this.E;
                end else if(instr[2:0] == 3'b100) // H
                begin
                    carry = computeCarry(this.H, 1'b1); 
                    this.A = this.A - this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    carry = computeCarry(this.L, 1'b1); 
                    this.A = this.A - this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    carry = computeCarry(8'h00, 1'b1); 
                    this.A = this.A - 8'h00;
                end else begin // A
                carry = computeCarry(this.A, 1'b1); 
                    this.A = this.A - this.A;
                end
                if (this.A == 0)
                begin
                    this.F[7] = 1'b1; // Set if result is 0
                end else begin
                    this.F[7] = 1'b0;
                end
                this.F[6] = 1'b1;
                this.F[5] = !carry[3];
                this.F[4] = !carry[7];
            end else if (instr[5:3] == 3'b011) // SBC
            begin
                this.F[4] = !this.F[4];
                if(instr[2:0] == 3'b000) // B
                begin
                    carry = computeCarry(this.B, 1'b1);  
                    this.A = this.A - this.B;
                    
                end else if (instr[2:0] == 3'b001) // C
                begin
                    carry = computeCarry(this.C, 1'b1);  
                    this.A = this.A - this.C;
                    
                end else if(instr[2:0] == 3'b010) // D
                begin
                    carry = computeCarry(this.D, 1'b1);  
                    this.A = this.A - this.D;
                    
                end else if(instr[2:0] == 3'b011) // E
                begin
                    carry = computeCarry(this.E, 1'b1);  
                    this.A = this.A - this.E;
                    
                end else if(instr[2:0] == 3'b100) // H
                begin
                    carry = computeCarry(this.H, 1'b1);  
                    this.A = this.A - this.H;
                    
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    carry = computeCarry(this.L, 1'b1);  
                    this.A = this.A - this.L;
                  
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    carry = computeCarry(8'h00, 1'b1); 
                    this.A = this.A - 8'h00;
                     
                end else begin // A
                    carry = computeCarry(this.A, 1'b1);  
                    this.A = this.A - this.A; 
                end
                if (this.A == 0)
                begin
                    this.F[7] = 1'b1;
                end else begin
                    this.F[7] = 1'b0;
                end
                this.F[6] = 1'b1;
                this.F[5] = !carry[3];
                this.F[4] = !carry[7];
            end else if (instr[5:3] == 3'b100) // &
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.A = this.A & this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.A = this.A & this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.A = this.A & this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.A = this.A & this.E;
                end else if(instr[2:0] == 3'b100) // H
                begin
                    this.A = this.A & this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.A = this.A & this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.A = this.A & 8'h00;
                end else begin // A
                    this.A = this.A & this.A;
                end
                if (this.A == 0)
                begin
                    this.F[7] = 1'b1; // Set if result is 0
                end else begin
                    this.F[7] = 1'b0;
                end
                this.F[6:4] = 3'b010;
            end else if (instr[5:3] == 3'b101) // ^
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.A = this.A ^ this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.A = this.A ^ this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.A = this.A ^ this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.A = this.A ^ this.E;
                end else if(instr[2:0] == 3'b100) // H
                begin
                    this.A = this.A ^ this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.A = this.A ^ this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.A = this.A ^ 8'h00;
                end else begin // A
                    this.A = this.A ^ this.A;
                end
                this.F[6:4] = 3'b000;
                if (this.A == 0)
                begin
                    this.F[7] = 1'b1;
                end else begin
                    this.F[7] = 1'b0;
                end
            end else if (instr[5:3] == 3'b110) // |
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.A = this.A | this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.A = this.A | this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.A = this.A | this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.A = this.A | this.E;
                end else if(instr[2:0] == 3'b100) // H
                begin
                    this.A = this.A | this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.A = this.A | this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.A = this.A | 8'h00;
                end else begin // A
                    this.A = this.A | this.A;
                end
                this.F[6:4] = 3'b000;
                if (this.A == 0)
                begin
                    this.F[7] = 1'b1;
                end else begin
                    this.F[7] = 1'b0;
                end
            end else begin // CP
                this.F[4] = 1'b1;
                this.F[6] = 1'b1; // set N
                this.F[7] = 1'b0; // set Z to zero, only changes if cp is equal
                if(instr[2:0] == 3'b000) // B
                begin
                    if (this.A == this.B)
                    begin
                        this.F[7] = 1'b1; // Z
                    end
                    carry = computeCarry(this.B, 1'b1);           
                end else if(instr[2:0] == 3'b001) // C
                begin
                    if (this.A == this.C)
                    begin
                        this.F[7] = 1'b1; // Z
                    end
                    carry = computeCarry(this.C, 1'b1); 
                end else if(instr[2:0] == 3'b010) // D
                begin
                    if (this.A == this.D)
                    begin
                        this.F[7] = 1'b1; // Z
                    end 
                    carry = computeCarry(this.D, 1'b1); 
                end else if(instr[2:0] == 3'b011) // E
                begin
                    if (this.A == this.E)
                    begin
                        this.F[7] = 1'b1; // Z
                    end 
                    carry = computeCarry(this.E, 1'b1); 
                end else if(instr[2:0] == 3'b100) // H
                begin
                    if (this.A == this.H)
                    begin
                        this.F[7] = 1'b1; // Z
                    end
                    carry = computeCarry(this.H, 1'b1);
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    if (this.A == this.H)
                    begin
                        this.F[7] = 1'b1; // Z
                    end 
                    carry = computeCarry(this.L, 1'b1); 
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    if (this.A == 8'h00)
                    begin
                        this.F[7] = 1'b1; // Z
                    end
                    carry = computeCarry(8'h00, 1'b1); 
                end else begin // A
                    carry = computeCarry(this.A, 1'b1); 
                    this.F[7] = 1'b1; // Z  
                end
                this.F[5] = !carry[3];
                this.F[4] = !carry[7];   
            end
        // LOAD
        end else if (instr[7:6] == 2'b01)
        begin
            if(instr[5:3] == 3'b000) // B (operand)
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.B = this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.B = this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.B = this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.B = this.E;
                end else if(instr[2:0] == 3'b100) // H
                begin
                    this.B = this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.B = this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.B = 8'h00;
                end else begin // A
                    this.B = this.A;
                end
            end else if(instr[5:3] == 3'b001) // C (operand)
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.C = this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.C = this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.C = this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.C = this.E;
                end else if(instr[2:0] == 3'b100) // H
                begin
                    this.C = this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.C = this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.C = 8'h00;
                end else begin // A
                    this.C = this.A;
                end
            end else if(instr[5:3] == 3'b010) // D (operand)
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.D = this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.D = this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.D = this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.D = this.E;
                end else if (instr[2:0] == 3'b100) // H
                begin
                    this.D = this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.D = this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.D = 8'h00;
                end else begin // A
                    this.D = this.A;
                end
            end else if(instr[5:3] == 3'b011) // E (oper&)
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.E = this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.E = this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.E = this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.E = this.E;
                end else if (instr[2:0] == 3'b100) // H
                begin
                    this.E = this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.E = this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.E = 8'h00;
                end else begin // A
                    this.E = this.A;
                end
            end else if(instr[5:3] == 3'b100) // H (oper&)
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.H = this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.H = this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.H = this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.H = this.E;
                end else if(instr[2:0] == 3'b100) // H
                begin
                    this.H = this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.H = this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.H = 8'h00;
                end else begin // A
                    this.H = this.A;
                end
            end else if(instr[5:3] == 3'b101) // L (oper&)
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.L = this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.L = this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.L = this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.L = this.E;
                end else if(instr[2:0] == 3'b100) // H
                begin
                    this.L = this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.L = this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.L = 8'h00;
                end else begin // A
                    this.L = this.A;
                end
            end else if(instr[5:3] == 3'b111) // A (oper&)
            begin
                if(instr[2:0] == 3'b000) // B
                begin
                    this.A = this.B;
                end else if(instr[2:0] == 3'b001) // C
                begin
                    this.A = this.C;
                end else if(instr[2:0] == 3'b010) // D
                begin
                    this.A = this.D;
                end else if(instr[2:0] == 3'b011) // E
                begin
                    this.A = this.E;
                end else if(instr[2:0] == 3'b100) // H
                begin
                    this.A = this.H;
                end else if (instr[2:0] == 3'b101) // L
                begin 
                    this.A = this.L;
                end else if (instr[2:0] == 3'b110) // HL
                begin
                    this.A = 8'h00;
                end else begin // A
                    this.A = this.A;
                end
            end
        end
        return {this.A, this.B, this.C, this.D, this.E, this.F, this.H, this.L};

    endfunction : executeALUInstruction

    function byte computeCarry(byte register, bit inv);
        byte carry_f;
        // For SBC, SUB, CP invert register (B_ii)
        carry_f[0] = (this.A[0] & (register[0] ^ inv)) | (this.F[4] & (this.A[0] ^ (register[0] ^ inv)));
        for (int i = 1; i <=7; i++) begin
            carry_f[i] = (this.A[i] & (register[i] ^ inv)) | (carry_f[i-1] & (this.A[i] ^ (register[i] ^ inv)));
        end
        $display("Carry: %x", carry_f);
        return carry_f;
    endfunction : computeCarry



endclass : gameboyprocessor
