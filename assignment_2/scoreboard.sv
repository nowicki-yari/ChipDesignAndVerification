class scoreboard;
    
    mailbox #(bit) chk2scr;

    bit c2s;
    int total_tests;
    int correct_tests;
    int incorrect_tests;


    /* constructor */
    function new(mailbox #(bit) c2s);
        this.chk2scr = c2s;
        total_tests = 0;
        correct_tests = 0;
        incorrect_tests = 0;
    endfunction : new

    task score();

        while(total_tests<100)
        begin
            this.chk2scr.get(c2s);
            total_tests += 1;
            if (c2s == 1)
            begin
                correct_tests += 1;
            end else begin
                incorrect_tests += 1;
            end
        end
    endtask : score


    task result();
        $display("Total tests: %d", total_tests);
        $display("Correct tests: %d", correct_tests);
        $display("Incorrect tests: %d", incorrect_tests);
    endtask;

endclass : scoreboard