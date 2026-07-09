`timescale 1ns/1ps

module tb_tag_ram;

    parameter TAG_BITS = 22;
    parameter CACHE_LINES = 64;

    logic clk;
    logic rst_n;

    logic we;
    logic [$clog2(CACHE_LINES)-1:0] index;

    logic [TAG_BITS-1:0] tag_in;
    logic valid_in;
    logic dirty_in;

    logic [TAG_BITS-1:0] tag_out;
    logic valid_out;
    logic dirty_out;


    tag_ram dut(

        .clk(clk),
        .rst_n(rst_n),

        .we(we),

        .index(index),

        .tag_in(tag_in),
        .valid_in(valid_in),
        .dirty_in(dirty_in),

        .tag_out(tag_out),
        .valid_out(valid_out),
        .dirty_out(dirty_out)

    );

    

    always #5 clk = ~clk;


    task display_status;

        begin

            $display("--------------------------------------------");
            $display("Index  : %0d", index);
            $display("Tag    : %h", tag_out);
            $display("Valid  : %b", valid_out);
            $display("Dirty  : %b", dirty_out);

        end

    endtask


    initial begin

        clk = 0;
        rst_n = 0;

        we = 0;

        index = 0;
        tag_in = 0;
        valid_in = 0;
        dirty_in = 0;


        #20;
        rst_n = 1;

        // Write Line 5
        @(posedge clk);

        we = 1;

        index = 6'd5;
        tag_in = 22'h12345;
        valid_in = 1'b1;
        dirty_in = 1'b0;

        @(posedge clk);

        we = 0;

        #2;

        display_status();

        
        // Write Line 20
        @(posedge clk);

        we = 1;

        index = 6'd20;
        tag_in = 22'h3AAAA;
        valid_in = 1'b1;
        dirty_in = 1'b1;

        @(posedge clk);

        we = 0;

        #2;

        display_status();

        // Read Previous Line
        index = 6'd5;

        #2;

        display_status();

        
        // Read Another Line
        index = 6'd20;

        #2;

        display_status();


        #20;

        $finish;

    end

endmodule