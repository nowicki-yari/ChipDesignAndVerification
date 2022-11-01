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

  task run();
    fork
      this.drv.run_addition();
      this.mon.run();
    join_any;

    $display("[ENV]: end of run()");

  endtask : run

endclass : environment
