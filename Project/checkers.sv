`include "transaction.sv"
`include "gameboyprocessor.sv"

class checkers;
    static gameboyprocessor gbmodel;

    /* mailboxes */
    mailbox #(shortint) gen2chk; /* 16 bit */
    mailbox #(longint) mon2chk; /* 64 bit */
    mailbox #(bit) chk2scr; /* single bit */

    shortint instr;
    longint r_ALU;
    longint result;

    /* constructor */
    function new(mailbox #(shortint) g2c, mailbox #(longint) m2c, mailbox #(bit) c2s);
        this.gen2chk = g2c;
        this.mon2chk = m2c;
        this.chk2scr = c2s;
    endfunction : new

    task check();
        string s;
        $timeformat(-9,0," ns" , 10);
        gbmodel = new();

        forever 
        begin
            this.mon2chk.get(result);
            this.gen2chk.get(instr);
            
            r_ALU = gbmodel.executeALUInstruction(instr[15:8], instr[7:0]);
           
            gbmodel.toString();
            
            if(r_ALU == result)
            begin
                s = $sformatf("[%t | CHK] The result is correct.", $time);
                this.chk2scr.put(1);
            end else begin
                s = $sformatf("[%t | CHK] The result is NOT correct.", $time);
                this.chk2scr.put(0);
            end
            $display(s);

        end
    endtask : check

endclass : checkers

