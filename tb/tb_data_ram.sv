`timescale 1ns/1ps

module tb_data_ram;

    parameter DATA_WIDTH = 32;
    parameter CACHE_LINES = 64;
    parameter WORDS_PER_LINE = 4;

    logic clk;
    logic we;

    logic [$clog2(CACHE_LINES)-1:0] index;
    logic [$clog2(WORDS_PER_LINE)-1:0] word_offset;

    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;

    
    data_ram dut(

        .clk(clk),
        .we(we),

        .index(index),
        .word_offset(word_offset),

        .data_in(data_in),
        .data_out(data_out)

    );

    
    always #5 clk = ~clk;


    task display_data;

        begin

            $display("--------------------------------");
            $display("Index       : %0d", index);
            $display("Word Offset : %0d", word_offset);
            $display("Data        : %h", data_out);

        end

    endtask

   

    initial begin

        $dumpfile("data_ram.vcd");
        $dumpvars(0, tb_data_ram);

        clk = 0;

        we = 0;
        index = 0;
        word_offset = 0;
        data_in = 0;

        // Write Line 5 Word 0
        @(posedge clk);

        we = 1;
        index = 6'd5;
        word_offset = 2'd0;
        data_in = 32'hAAAAAAAA;

        @(posedge clk);

        we = 0;

        #2;

        display_data();

        // Write Line 5 Word 2
        @(posedge clk);

        we = 1;
        index = 6'd5;
        word_offset = 2'd2;
        data_in = 32'h12345678;

        @(posedge clk);

        we = 0;

        #2;

        display_data();

        
        // Read Line 5 Word 0
        index = 6'd5;
        word_offset = 2'd0;

        #2;

        display_data();

        
        // Read Line 5 Word 2
        word_offset = 2'd2;

        #2;

        display_data();

        
        // Write Another Cache Line
        @(posedge clk);

        we = 1;

        index = 6'd20;
        word_offset = 2'd1;
        data_in = 32'hCAFEBABE;

        @(posedge clk);

        we = 0;

        #2;

        display_data();


        #20;

        $finish;

    end

endmodule