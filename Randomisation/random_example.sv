class random_example;

    rand byte something;
    rand byte another_thing;    

    function new();
        this.something = 0;
        this.another_thing = 0;
    endfunction : new

    function string toString();
        return $sformatf("Something is %02x and another thing is %02x", this.something, this.another_thing);
    endfunction : toString

    task printString();
        $display(this.toString());
    endtask : printString

endclass : random_example


program test_random_example();
    random_example re;

    initial
    begin
        re = new();

        for(int i=0;i<20;i++)
            re.printString();

        for(int i=0;i<20;i++)
        begin
            void'(re.randomize());
            re.printString();
        end
    end

endprogram : test_random_example
