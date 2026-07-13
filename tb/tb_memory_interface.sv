`timescale 1ns/1ps

module tb_memory_interface;

    logic clk;
    logic rst_n;

    logic mem_read_req;
    logic [31:0] cache_addr;

    logic mem_ready;
    logic [31:0] mem_rdata;

    logic mem_read;
    logic [31:0] mem_addr;

    logic data_valid;
    logic [31:0] cache_data;


    memory_interface dut(

        .clk(clk),
        .rst_n(rst_n),

        .mem_read_req(mem_read_req),
        .cache_addr(cache_addr),

        .mem_ready(mem_ready),
        .mem_rdata(mem_rdata),

        .mem_read(mem_read),
        .mem_addr(mem_addr),

        .data_valid(data_valid),
        .cache_data(cache_data)

    );

    

    always #5 clk = ~clk;

    

    task show;

        begin

            $display("--------------------------------------");
            $display("Time       : %0t", $time);
            $display("mem_read   : %b", mem_read);
            $display("mem_addr   : %h", mem_addr);
            $display("data_valid : %b", data_valid);
            $display("cache_data : %h", cache_data);

        end

    endtask

    

    initial begin

        $dumpfile("memory_interface.vcd");
        $dumpvars(0, tb_memory_interface);

        clk = 0;
        rst_n = 0;

        mem_read_req = 0;
        cache_addr   = 0;

        mem_ready = 0;
        mem_rdata = 0;

        
        // Reset
        #20;
        rst_n = 1;

        
        // Issue Memory Read Request
        @(posedge clk);

        mem_read_req = 1;
        cache_addr   = 32'h00001000;

        @(posedge clk);

        mem_read_req = 0;

        show();

        
        // Memory Responds
        @(posedge clk);

        mem_rdata = 32'hDEADBEEF;
        mem_ready = 1;

        @(posedge clk);

        show();

        mem_ready = 0;

        

        #20;

        $finish;

    end

endmodule