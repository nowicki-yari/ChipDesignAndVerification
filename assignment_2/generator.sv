`include "transaction.sv"

class generator;

  mailbox #(transaction) gen2drv;
  mailbox #(byte) gen2chk;

  function new(mailbox #(transaction) g2d, mailbox #(byte) g2c);
    this.gen2drv = g2d;
    this.gen2chk = g2c;
  endfunction : new

  task run;
    string s;
    transaction tra;

    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | GEN] I will start generating for the mailbox", $time);
    $display(s);

    //Problem: Program ends when all instructions are placed in the mailbox, but not when everything is received
    //Right now: The incorrect tests are the tests where F is not 00.
    for(int i=0; i<105; i++)
    begin
      tra = new();
      s = $sformatf("[%t | GEN] new instruction %s", $time, tra.toString());
      $display(s);
      this.gen2drv.put(tra);
      this.gen2chk.put(tra.toByte());
    end
  endtask : run

endclass : generator
