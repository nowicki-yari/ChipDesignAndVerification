`ifndef SR_TRA_TRANSACTION
`define SR_TRA_TRANSACTION

class transaction;
  rand bit [1:0] instruction_type;
  rand bit [2:0] instruction_selection;
  rand bit [2:0] operand_selection;

  constraint instruction_starting_with_A {
    (instruction_selection inside {3'h0,3'h1,3'h4});
  }

  constraint cp_twenty_percent {
    instruction_selection dist {7 := 2, [0:6] :/ 8};
  }

  function new();
    this.instruction_type = 2'h0;
    this.instruction_selection = 3'h0;
    this.operand_selection = 3'h0;
  endfunction : new

  function string toString();
    return $sformatf("Instruction: %02x %02x %02x (%02x) ", this.instruction_type, this.instruction_selection, this.operand_selection, this.toByte);
  endfunction : toString

  function byte toByte();
    return byte'(this.instruction_type * 2**(6-1) + this.instruction_selection * 2**(3-1) + this.operand_selection);
  endfunction : toByte;


endclass : transaction;

program assignment3();
    transaction tra;

    int cp_count = 0;
    int total = 0;
    initial
    begin
      /* COMPLETE THIS CODE */
      $display("Starting test 1...");
      // Test 1: 100 tests random operands for each operation (ADD, ADC, SUB, SBC, AND, XOR, OR, CP) specifically (totalling on 800 tests)
      tra = new();
      tra.instruction_type.rand_mode(0);
      tra.instruction_selection.rand_mode(0);

      tra.instruction_type = 2'h2;
      tra.instruction_starting_with_A.constraint_mode(0);
      tra.cp_twenty_percent.constraint_mode(0);
      for(int i=0;i<8;i++)
      begin
        for(int j=0;j<100;j++)
        begin
          
          void'(tra.randomize());

          $display("%s", tra.toString());
        end
        tra.instruction_selection += 1'b1;
      end
      $display("Test 1: Done");

      $display("Starting test 2...");
      // Test 2: 100 tests with random operands for operations that start with an A (ADD, ADC or AND)
      tra.instruction_starting_with_A.constraint_mode(1);
      tra.instruction_selection.rand_mode(1);
      for(int j=0;j<100;j++)
      begin
        
        void'(tra.randomize());

        $display("%s", tra.toString());
      end
      $display("Test 2: Done");

      $display("Starting test 3...");
      // Test 3: 100 tests with random operands and random operations. After a SUB operation, the next operation MUST be XOR
      tra.instruction_starting_with_A.constraint_mode(0);
      for(int j=0;j<100;j++)
      begin
        if (tra.instruction_selection == 3'h2)
        begin
          tra.instruction_selection = 3'h5;
          $display("SUB operation detected, performing XOR next.");
        end else begin
          void'(tra.randomize());
        end
        $display("%s", tra.toString());
      end
      $display("Test 3: Done");

      $display("Starting test 4...");
      // Test 4: 1’000 tests with random operands. Roughly 20% of the tests should be the CP operation. Print a summary of these tests to show the constrained is met.
      tra.cp_twenty_percent.constraint_mode(1);
      for(int j=0;j<1000;j++)
      begin
        total += 1;
        void'(tra.randomize());

        $display("%s", tra.toString());
      
      end
      $display("%d tests out of %d tests were cp instructions", cp_count, total);
      $display("Test 4: Done");
    end

endprogram : assignment3

`endif
