`include "transaction.sv"

class driver;

  virtual gb_iface ifc;
  mailbox #(transaction) gen2drv;

  function new(virtual gb_iface ifc, mailbox #(transaction) g2d);
    this.ifc = ifc;
    this.gen2drv = g2d;
  endfunction : new

  task run_addition();
    string s;
    transaction tra;
    
    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | DRV] I will start driving from the mailbox", $time);
    $display(s);

    
    forever begin
        
        this.ifc.valid <= 1'b0;
        this.gen2drv.get(tra);

        @(posedge this.ifc.clock);

        this.ifc.valid <= 1'b1;
        s = $sformatf("[%t | DRV] I will execute instruction %x", $time, tra.toByte());
        $display(s);
        this.ifc.instruction <= tra.toByte();

        @(posedge this.ifc.clock);

    end /* forever */
    

    s = $sformatf("[%t | DRV] done", $time);
    $display(s);
         
  endtask : run_addition
  
  task do_reset();
    string s;
    $timeformat(-9,0, " ns", 10);
    s = $sformatf("[%t | DRV] performing reset", $time);
    $display(s);
    this.ifc.reset <= 1'b1;
    repeat (10) @(posedge this.ifc.clock);
    this.ifc.reset <= 1'b0;
  endtask : do_reset
  

endclass : driver
