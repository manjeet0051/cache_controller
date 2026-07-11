`timescale 1ns/1ps

module tb_tag_comparator;

    parameter TAG_BITS = 22;

    logic [TAG_BITS-1:0] req_tag;
    logic [TAG_BITS-1:0] stored_tag;
    logic valid;

    logic hit;
    logic miss;

    

    tag_comparator dut(

        .req_tag(req_tag),
        .stored_tag(stored_tag),
        .valid(valid),

        .hit(hit),
        .miss(miss)

    );

    

    task check;

        begin

            #1;

            $display("--------------------------------------");
            $display("Requested Tag : %h", req_tag);
            $display("Stored Tag    : %h", stored_tag);
            $display("Valid         : %b", valid);
            $display("Hit           : %b", hit);
            $display("Miss          : %b", miss);

        end

    endtask

    

    initial begin


        req_tag    = 22'h12345;
        stored_tag = 22'h12345;
        valid      = 1'b1;

        check();

        
        // Case 2 : Tag Mismatch
        req_tag    = 22'h12345;
        stored_tag = 22'h54321;
        valid      = 1'b1;

        check();

        
        // Case 3 : Invalid Line
        req_tag    = 22'hAAAA;
        stored_tag = 22'hAAAA;
        valid      = 1'b0;

        check();

        
        // Case 4 : Different Tag + Invalid
        req_tag    = 22'h11111;
        stored_tag = 22'h22222;
        valid      = 1'b0;

        check();

        

        #10;

        $finish;

    end

endmodule