`timescale 1ns/1ps

module tb_cache_controller;

    logic clk;
    logic rst_n;

    logic cpu_read;
    logic cpu_write;
    logic [31:0] cpu_addr;
    logic [31:0] cpu_wdata;

    logic [31:0] cpu_rdata;
    logic cpu_ready;

    logic mem_read;
    logic mem_write;
    logic [31:0] mem_addr;
    logic [31:0] mem_wdata;

    logic [31:0] mem_rdata;
    logic mem_ready;

   
    // DUT
    cache_controller dut (

        .clk(clk),
        .rst_n(rst_n),

        .cpu_read(cpu_read),
        .cpu_write(cpu_write),
        .cpu_addr(cpu_addr),
        .cpu_wdata(cpu_wdata),

        .cpu_rdata(cpu_rdata),
        .cpu_ready(cpu_ready),

        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_wdata(mem_wdata),

        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready)
    );

    
    // Clock
    always #5 clk = ~clk;

    
    // Test
    initial begin

        clk = 0;
        rst_n = 0;

        cpu_read  = 0;
        cpu_write = 0;
        cpu_addr  = 0;
        cpu_wdata = 0;

        mem_rdata = 32'h12345678;
        mem_ready = 0;

        #20;
        rst_n = 1;

       
        // Read Request
        @(posedge clk);

        cpu_read = 1;
        cpu_addr = 32'h00000020;

        @(posedge clk);

        cpu_read = 0;

        
        // Write Request
        repeat(2) @(posedge clk);

        cpu_write = 1;
        cpu_addr  = 32'h00000040;
        cpu_wdata = 32'hDEADBEEF;

        @(posedge clk);

        cpu_write = 0;

        //----------------------------------

        #100;

        $finish;

    end

endmodule