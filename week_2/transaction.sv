class transaction;
  byte instruction;

  function new();
    this.instruction = 8'h8c;
  endfunction : new

  function string toString();
    return $sformatf("Instruction: %08x", this.instruction);
  endfunction : toString

endclass : transaction;
