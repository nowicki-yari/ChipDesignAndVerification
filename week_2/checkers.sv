`include "transaction.sv"
`include "gameboyprocessor.sv"

class checkers;
    static gameboyprocessor gbmodel;

    /* mailboxes */
    mailbox #(byte) gen2chk; /* 8 bit */
    mailbox #(shortint) mon2chk; /* 16 bit */
    mailbox #(bit) chk2scr; /* single bit */

    byte instr;
    shortint r_ALU;
    shortint result;

    /* constructor */
    function new(mailbox #(byte) g2c, mailbox #(shortint) m2c, mailbox #(bit) c2s);
        this.gen2chk = g2c;
        this.mon2chk = m2c;
        this.chk2scr = c2s;
    endfunction : new

    task check();
        forever begin
            this.mon2chk.get(result);
            this.gen2chk.get(instr);

            r_ALU = gbmodel.executeALUInstruction(instr);
            gbmodel.toString();

            if(r_ALU == result)
            begin
                $display("The result is correct.");
                this.chk2scr.put(1);
            end else begin
                $display("The result is NOT correct.");
                this.chk2scr.put(0);
            end

        end
    endtask : check

endclass : checkers

