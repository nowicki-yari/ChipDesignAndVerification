'ifndef "transaction"
define "transaction"

class generator;

  mailbox #(transaction) gen2drv;

  function new(mailbox #(transaction) g2d);
    this.gen2drv = g2d;
  endfunction : new

  task run;
    string s;
    transaction tra;

    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | GEN] I will start generating for the mailbox", $time);
    $display(s);

    for(int i=0; i<10; i++)
    begin
      tra = new();
      s = $sformatf("[%t | GEN] new instruction %s", $time, tra.toString());
      $display(s);
      this.gen2drv.put(tra);
    end
  endtask : run

endclass : generator
