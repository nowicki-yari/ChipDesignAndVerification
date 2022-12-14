`include "transaction.sv"

class driver;

  virtual gb_iface ifc;
  mailbox #(shortint) gen2drv;

  function new(virtual gb_iface ifc, mailbox #(shortint) g2d);
    this.ifc = ifc;
    this.gen2drv = g2d;
  endfunction : new

  task run_addition();
    string s;
    shortint tra;
    
    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | DRV] I will start driving from the mailbox", $time);
    $display(s);

    
    forever begin
        
        this.ifc.valid <= 1'b0;
        this.gen2drv.get(tra);

        @(posedge this.ifc.clock);

        this.ifc.valid <= 1'b1;
        this.ifc.instruction <= tra[15:8];
        this.ifc.data <= tra[7:0];

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
