`timescale 1ns/1ps

module tb_address_decoder;

    logic [31:0] addr;

    logic [21:0] tag;
    logic [5:0]  index;
    logic [3:0]  offset;

    address_decoder dut(
        .addr(addr),
        .tag(tag),
        .index(index),
        .offset(offset)
    );

    task display_result;
        begin
            $display("--------------------------------------");
            $display("Address : %h", addr);
            $display("Tag     : %h", tag);
            $display("Index   : %0d (0x%h)", index, index);
            $display("Offset  : %0d (0x%h)", offset, offset);
        end
    endtask

    initial begin

        //-------
        addr = 32'h12345678;
        #10;
        display_result();

        //-------
        addr = 32'hABCDEF12;
        #10;
        display_result();

        //--------
        addr = 32'h00000020;
        #10;
        display_result();

        //------
        addr = 32'hFFFFFFFF;
        #10;
        display_result();

        //---------
        $finish;

    end

endmodule