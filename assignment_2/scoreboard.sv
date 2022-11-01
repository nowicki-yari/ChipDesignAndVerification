class scoreboard;
    
    mailbox #(bit) chk2scr;

    bit c2s;
    int total_tests;
    int correct_tests;
    int incorrect_tests;


    /* constructor */
    function new(mailbox #(bit) c2s);
        this.chk2scr = c2s;
    endfunction : new

    task score();

        total_tests = 0;
        correct_tests = 0;
        incorrect_tests = 0;

        forever begin
            this.chk2scr.get(c2s);
            total_tests += 1;
            $display("Received at scoreboard: %u", c2s);
            if (c2s == 1)
            begin
                correct_tests += 1;
            end else begin
                incorrect_tests += 1;
            end
        end
    endtask : score


    task result();
        $display("Total tests: %i", total_tests);
        $display("Correct tests: %i", total_tests);
        $display("Incorrect tests: %i", total_tests);
    endtask;

endclass : scoreboard