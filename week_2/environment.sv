`include "driver.sv"
`include "monitor.sv"

class environment;

  virtual gb_iface ifc;

  driver drv;
  monitor mon;

  function new(virtual gb_iface ifc);
    this.drv = new(ifc);
    this.mon = new(ifc);
  endfunction : new


  /* Task : run
   * Parameters :
   * Returns :
  **/
  task run();
    this.drv.run_addition();
    this.mon.run();
  endtask : run

endclass : environment
