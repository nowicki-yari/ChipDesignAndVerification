class driver;

  /* Virtual interface */
  virtual gbprocessor_iface ifc;

  /* Constructor */
  function new(virtual gbprocessor_iface ifc);
    this.ifc = ifc;
  endfunction : new

  /* run_addition method */
  task run_addition();
    string s;
    
    $timeformat(-9,0," ns" , 10); /* format timing */

    /* print message */
    s = $sformatf("[%t | DRV] I will start driving for addition", $time);
    $display(s);
    
    /* start with reset */
    this.ifc.reset <= 1'b1;
    repeat(10) @(posedge this.ifc.clock);

    this.ifc.reset <= 1'b0;
    repeat(10) @(posedge this.ifc.clock);

    /* execute instructions */
    this.ifc.valid <= 1'b1;
    this.ifc.instruction <= 8'h81;
    @(posedge this.ifc.clock);

    this.ifc.valid <= 1'b1;
    this.ifc.instruction <= 8'h82;
    @(posedge this.ifc.clock);

    this.ifc.valid <= 1'b0;
    this.ifc.instruction <= 8'h00;
    @(posedge this.ifc.clock);

    /* print message */
    s = $sformatf("[%t | DRV] done", $time);
    $display(s);
  endtask : run_addition

endclass : driver
