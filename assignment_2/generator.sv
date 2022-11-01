`include "transaction.sv"

class generator;

  function new;

  endfunction : new

  task run;
    transaction tra;

    for(int i=0; i<10; i++)
    begin
      tra = new();
      $display("%s", tra.toString());
    end
  endtask : run

endclass : generator
