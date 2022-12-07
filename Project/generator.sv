`include "transaction.sv"

class generator;

  mailbox #(byte) gen2drv;
  mailbox #(byte) gen2chk;

  function new(mailbox #(byte) g2d, mailbox #(byte) g2c);
    this.gen2drv = g2d;
    this.gen2chk = g2c;
  endfunction : new

  task run;
    string s;
    transaction tra;
    byte instr;
    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | GEN] I will start generating for the mailbox", $time);
    $display(s);

    //Problem: Program ends when all instructions are placed in the mailbox, but not when everything is received
    //Right now: The incorrect tests are the tests where F is not 00.
    //for(int i=0; i<100; i++)
    tra = new();
    forever
    begin
      void'(tra.randomize());
      instr = tra.toByte();
      this.gen2chk.put(instr);
      this.gen2drv.put(instr);

      s = $sformatf("[%t | GEN] new instruction %s", $time, tra.toString());
      $display(s);
      
    end
  endtask : run

endclass : generator
