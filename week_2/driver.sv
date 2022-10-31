`include "transaction.sv"

class driver;

  /* Virtual interface */
  virtual gb_iface ifc;
  mailbox #(transaction) gen2drv;

  /* Constructor */
  function new(virtual gb_iface ifc, mailbox #(transaction) g2d);
    this.ifc = ifc;
    this.gen2drv = g2d;
  endfunction : new

  /* run_addition method */
  task run_addition();
    string s;
    transaction tra;
    
    $timeformat(-9,0," ns" , 10); /* format timing */

    /* print message */
     s = $sformatf("[%t | DRV] I will start driving from the mailbox", $time);
    $display(s);
    
    forever 
    begin

        this.ifc.valid = 1'b0;
        this.gen2drv.get(tra);

        @(posedge this.ifc.clock);

        this.ifc.valid = 1'b1;
        //this.ifc.instruction <= 8'h82;
        this.ifc.instruction = tra.toByte();

    end /* forever */


    s = $sformatf("[%t | DRV] done", $time);
    $display(s);

  endtask : run_addition

  task do_reset();
    string s;
    $timeformat(-9,0, " ns", 10);
    s = $sformatf("[%t | DRV] performing reset", $time);
    this.ifc.reset = 1'b1;
    repeat (10) @(posedge this.ifc.clock);
    this.ifc.reset = 1'b0;
  endtask : do_reset

endclass : driver
