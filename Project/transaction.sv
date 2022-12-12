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
  

  // The amount of arithmetic operations should roughly be 3 times the amount of logical operations
  constraint arithmetic_and_logical {
    instruction_type == 2'b10;
  }
 */

  constraint no_halt_or_load0 {
    instruction_type == 2'b01 -> (instruction_selection != 3'b110 | operand_selection != 3'b110); // NO HALT INSTRUCTION 
    instruction_type == 2'b01 -> (operand_selection != 3'b110); // NO LOADING 8'H00 --> sets everything to zero eventually
  }

  constraint only_01_or_10_as_type {
    (instruction_type inside {2'b10, 2'b01}); // [4x - Bx]
  }
  
  function new();
    this.instruction_type = 2'h0;
    this.instruction_selection = 3'h0;
    this.operand_selection = 3'h0;

    //this.instruction_type.rand_mode(0);
    //this.instruction_type = 2'h2;
  endfunction : new

  function string toString();
    return $sformatf("Instruction: %02x %02x %02x (%02x) ", this.instruction_type, this.instruction_selection, this.operand_selection, this.toByte);
  endfunction : toString

  function byte toByte();
    return byte'(this.instruction_type * 2**(6) + this.instruction_selection * 2**(3) + this.operand_selection);
  endfunction : toByte;

endclass : transaction

`endif