`ifndef SR_TRA_TRANSACTION
`define SR_TRA_TRANSACTION

class transaction;
  rand bit [1:0] instruction_type;
  rand bit [2:0] instruction_selection;
  rand bit [2:0] operand_selection;
  rand bit [7:0] data;
  /*
  constraint instruction_starting_with_A {
    (instruction_selection inside {3'h0,3'h1,3'h4});
  }
  

  // The amount of arithmetic operations should roughly be 3 times the amount of logical operations
  constraint arithmetic_and_logical {
    instruction_type == 2'b10;
  }
 */
  // data is empty when it is not used
  /*
  constraint data_inst {
    instruction_type == 2'b00 -> (data != 8'h00);
    instruction_type != 2'b00 -> (data == 8'h00);
  }
*/
  constraint data_inst_2 {
    instruction_type == 2'b00 -> (operand_selection == 3'b110);  
  }

  constraint no_halt_or_load0 {
    instruction_type == 2'b01 -> (instruction_selection != 3'b110 | operand_selection != 3'b110); // NO HALT INSTRUCTION 
    instruction_type == 2'b01 -> (operand_selection != 3'b110); // NO LOADING 8'H00 --> sets everything to zero eventually
  }

  constraint only_01_or_10_as_type {
    (instruction_type inside {2'b10, 2'b01, 2'b00}); // [4x - Bx]
  }

  constraint limited_data_instructions {
    instruction_type dist { 2'b00 := 1, [1:2] := 20};
  }

  constraint data_is_almost_always_not_null {
    data dist {8'h00 := 1, [1:255] := 20};
  }
  
  function new();
    this.instruction_type = 2'h0;
    this.instruction_selection = 3'h0;
    this.operand_selection = 3'h0;
    this.data = 8'h00;
    //this.instruction_type.rand_mode(0);
    //this.instruction_type = 2'h2;
  endfunction : new

  function string toString();
    return $sformatf("Instruction: %02x %02x %02x (%02x) ", this.instruction_type, this.instruction_selection, this.operand_selection, this.getInstruction);
  endfunction : toString;

  function byte getInstruction();
    return byte'(this.instruction_type * 2**(6) + this.instruction_selection * 2**(3) + this.operand_selection);
  endfunction : getInstruction;

  function byte getData();
    return data;
  endfunction : getData;

  function longint getInstructionAndData();
    return {this.getInstruction, this.getData};
  endfunction : getInstructionAndData;

endclass : transaction

`endif