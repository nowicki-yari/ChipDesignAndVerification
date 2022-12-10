`ifndef SR_TRA_TRANSACTION
`define SR_TRA_TRANSACTION

class transaction;
  rand bit [1:0] instruction_type;
  rand bit [2:0] instruction_selection;
  rand bit [2:0] operand_selection;
  /*
  constraint instruction_starting_with_A {
    (instruction_selection inside {3'h0,3'h1,3'h4});
  }
  */

  // The amount of arithmetic operations should roughly be 3 times the amount of logical operations
  constraint arithmetic_and_logical {
    instruction_type == 2'b10;
  }

  constraint no_sbc {
    instruction_selection != 3'b011;
  }

  constraint no_cp {
    instruction_selection != 3'b111;
  }
  
  function new();
    this.instruction_type = 2'h0;
    this.instruction_selection = 3'h0;
    this.operand_selection = 3'h0;

    this.instruction_type.rand_mode(0);
    this.instruction_type = 2'h2;
  endfunction : new

  function string toString();
    return $sformatf("Instruction: %02x %02x %02x (%02x) ", this.instruction_type, this.instruction_selection, this.operand_selection, this.toByte);
  endfunction : toString

  function byte toByte();
    return byte'(this.instruction_type * 2**(6) + this.instruction_selection * 2**(3) + this.operand_selection);
  endfunction : toByte;

endclass : transaction

`endif