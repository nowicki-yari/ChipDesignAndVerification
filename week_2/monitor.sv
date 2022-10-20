class monitor;

  /* Virtual interface */
  virtual gb_iface ifc;

  /* Constructor */
  function new(virtual gb_iface ifc);
    this.ifc = ifc;
  endfunction : new

  /* run method */
  task run();
    string s;
    byte a, b, z;
    bit sample = 0;
    byte instruction;
    
    $timeformat(-9,0," ns" , 10); /* format timing */

    /* print message */
    s = $sformatf("[%t | MON] I will start monitoring", $time);
    $display(s);

    forever begin
      /* wait for falling edge of the clock */
      @(negedge this.ifc.clock);

      /* if sampling is required, sample */
      if(sample == 1)
      begin
        s = $sformatf("[%t | MON] I sampled %x (with %x)", $time, this.ifc.probe, instruction);
        $display(s);

        sample = 0;
      end 

      /* determine whether sampling is required */
      if(this.ifc.valid == 1)
      begin
        sample = 1;
        instruction = this.ifc.instruction;
      end /* if valid */
        
    end /* forever */
  endtask : run

endclass : monitor
