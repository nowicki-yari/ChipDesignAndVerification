`include "driver.sv"

class environment;

  virtual gb_iface ifc;

  driver drv;

  function new(virtual gb_iface ifc);
    this.drv = new(ifc);
  endfunction : new


  /* Task : run
   * Parameters :
   * Returns :
  **/
  task run();
    this.drv.run_addition();
  endtask : run

endclass : environment
