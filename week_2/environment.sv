`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "checkers.sv"

class environment;

  mailbox #(transaction) gen2drv;
  mailbox #(shortint) mon2chk;
  mailbox #(byte) gen2chk;
  mailbox #(bit) chk2scr;

  virtual gb_iface ifc;

  generator gen;
  driver drv;
  monitor mon;
  checkers check;

  function new(virtual gb_iface ifc);
    this.ifc = ifc;

    this.gen2drv = new(5);
    this.mon2chk = new(5);
    this.gen2chk = new(5);
    this.chk2scr = new(5);

    this.gen = new(this.gen2drv, this.gen2chk);
    this.drv = new(ifc, this.gen2drv);
    this.mon = new(ifc, this.mon2chk);
    this.check = new(this.gen2chk, this.mon2chk, this.chk2scr);

  endfunction : new


  /* Task : run
   * Parameters :
   * Returns :
  **/
  task run();
    string s;

    $timeformat(-9,0," ns" , 10);

    s = $sformatf("[%t | ENV] I will set up the components", $time);
    $display(s);

    this.drv.do_reset();

    fork
      this.drv.run_addition();
      this.mon.run();
      this.gen.run();
      this.check.check();
    join_any;

    s = $sformatf("[%t | ENV]  end of run()", $time);
    $display(s);

  endtask : run

endclass : environment
