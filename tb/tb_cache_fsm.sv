`timescale 1ns/1ps

module tb_cache_fsm;

    logic clk;
    logic rst_n;

    logic cpu_req;
    logic cache_hit;
    logic mem_ready;

    logic cache_read;
    logic mem_read;
    logic update_cache;
    logic cpu_ready;


    cache_fsm dut(

        .clk(clk),
        .rst_n(rst_n),

        .cpu_req(cpu_req),
        .cache_hit(cache_hit),
        .mem_ready(mem_ready),

        .cache_read(cache_read),
        .mem_read(mem_read),
        .update_cache(update_cache),
        .cpu_ready(cpu_ready)

    );

    

    always #5 clk = ~clk;

    

    task print_status;

        begin

            $display("----------------------------------------");
            $display("Time         : %0t",$time);
            $display("State Signals");
            $display("cache_read   : %b",cache_read);
            $display("mem_read     : %b",mem_read);
            $display("update_cache : %b",update_cache);
            $display("cpu_ready    : %b",cpu_ready);

        end

    endtask

    

    initial begin

        $dumpfile("cache_fsm.vcd");
        $dumpvars(0,tb_cache_fsm);

        clk = 0;
        rst_n = 0;

        cpu_req = 0;
        cache_hit = 0;
        mem_ready = 0;

        
        // Reset
        #20;
        rst_n = 1;

        
        // Case 1 : Cache Hit
        @(posedge clk);

        cpu_req = 1;

        @(posedge clk);

        cpu_req = 0;
        cache_hit = 1;

        @(posedge clk);
        print_status();

        cache_hit = 0;

        @(posedge clk);
        print_status();

        
        // Case 2 : Cache Miss
        @(posedge clk);

        cpu_req = 1;

        @(posedge clk);

        cpu_req = 0;

        @(posedge clk);

        mem_ready = 1;

        @(posedge clk);
        print_status();

        mem_ready = 0;

        @(posedge clk);
        print_status();

        #20;

        $finish;

    end

endmodule