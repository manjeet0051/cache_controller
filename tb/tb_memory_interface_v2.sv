`timescale 1ns/1ps

module tb_memory_interface_v2;

    //------------------------------------------------------------
    // Parameters
    //------------------------------------------------------------

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;

    //------------------------------------------------------------
    // Clock & Reset
    //------------------------------------------------------------

    logic clk;
    logic rst_n;

    //------------------------------------------------------------
    // Cache Controller Interface
    //------------------------------------------------------------

    logic mem_read_req;
    logic mem_write_req;

    logic [ADDR_WIDTH-1:0] cache_addr;
    logic [DATA_WIDTH-1:0] cache_write_data;

    //------------------------------------------------------------
    // Memory Model Interface
    //------------------------------------------------------------

    logic memory_ready;
    logic [DATA_WIDTH-1:0] memory_read_data;

    //------------------------------------------------------------
    // DUT Outputs
    //------------------------------------------------------------

    logic memory_read;
    logic memory_write;

    logic [ADDR_WIDTH-1:0] memory_addr;
    logic [DATA_WIDTH-1:0] memory_write_data;

    logic [DATA_WIDTH-1:0] cache_read_data;

    logic mem_ready;
    logic data_valid;
    logic busy;

    logic [2:0] state_dbg;

    //------------------------------------------------------------
    // DUT
    //------------------------------------------------------------

    memory_interface_v2 #(

        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)

    ) dut (

        .clk(clk),
        .rst_n(rst_n),

        .mem_read_req(mem_read_req),
        .mem_write_req(mem_write_req),

        .cache_addr(cache_addr),
        .cache_write_data(cache_write_data),

        .memory_ready(memory_ready),
        .memory_read_data(memory_read_data),

        .memory_read(memory_read),
        .memory_write(memory_write),

        .memory_addr(memory_addr),
        .memory_write_data(memory_write_data),

        .cache_read_data(cache_read_data),

        .mem_ready(mem_ready),
        .data_valid(data_valid),
        .busy(busy),

        .state_dbg(state_dbg)

    );

    //------------------------------------------------------------
    // Clock Generation
    //------------------------------------------------------------

    always #5 clk = ~clk;

    //------------------------------------------------------------
    // FSM State Printer
    //------------------------------------------------------------

    task automatic print_state;

    begin

        case(state_dbg)

            3'd0 : $write("IDLE");
            3'd1 : $write("READ_REQ");
            3'd2 : $write("READ_DONE");
            3'd3 : $write("WRITE_REQ");
            3'd4 : $write("WRITE_DONE");

            default :
                $write("UNKNOWN");

        endcase

    end

    endtask;

    //------------------------------------------------------------
    // Status Printer
    //------------------------------------------------------------

    task automatic print_status;

    begin

        $display("\n======================================================");

        $write("Time : %0t | State : ",$time);
        print_state();
        $display("");

        $display("------------------------------------------------------");

        $display("mem_read_req      = %0b",mem_read_req);
        $display("mem_write_req     = %0b",mem_write_req);

        $display("");

        $display("cache_addr        = %h",cache_addr);
        $display("write_data        = %h",cache_write_data);

        $display("");

        $display("memory_ready      = %0b",memory_ready);
        $display("memory_read_data  = %h",memory_read_data);

        $display("");

        $display("memory_read       = %0b",memory_read);
        $display("memory_write      = %0b",memory_write);

        $display("memory_addr       = %h",memory_addr);
        $display("memory_write_data = %h",memory_write_data);

        $display("");

        $display("cache_read_data   = %h",cache_read_data);

        $display("mem_ready         = %0b",mem_ready);
        $display("data_valid        = %0b",data_valid);
        $display("busy              = %0b",busy);

        $display("======================================================\n");

    end

    endtask;

    //------------------------------------------------------------
    // Test Sequence
    //------------------------------------------------------------

    initial begin

        $dumpfile("memory_interface_v2.vcd");
        $dumpvars(0,tb_memory_interface_v2);

        $display("\n===== MEMORY INTERFACE V2 SIMULATION START =====\n");

        clk = 0;
        rst_n = 0;

        mem_read_req = 0;
        mem_write_req = 0;

        cache_addr = 0;
        cache_write_data = 0;

        memory_ready = 0;
        memory_read_data = 0;

        //--------------------------------------------------------
        // Reset
        //--------------------------------------------------------

        #20;
        rst_n = 1;

        //--------------------------------------------------------
        // TEST CASE 1 : MEMORY READ
        //--------------------------------------------------------

        $display("TEST CASE 1 : MEMORY READ");

        @(posedge clk);

        mem_read_req <= 1;
        cache_addr   <= 32'h00001000;

        @(posedge clk);

        mem_read_req <= 0;

                //--------------------------------------------------------
        // Memory responds with data
        //--------------------------------------------------------

        @(posedge clk);

        memory_ready     <= 1;
        memory_read_data <= 32'hDEADBEEF;

        @(posedge clk);

        print_status();

        memory_ready <= 0;

        //--------------------------------------------------------
        // READ_DONE -> IDLE
        //--------------------------------------------------------

        @(posedge clk);

        print_status();

        //--------------------------------------------------------
        // TEST CASE 2 : MEMORY WRITE
        //--------------------------------------------------------

        $display("TEST CASE 2 : MEMORY WRITE");

        @(posedge clk);

        mem_write_req    <= 1;
        cache_addr       <= 32'h00002000;
        cache_write_data <= 32'hCAFEBABE;

        @(posedge clk);

        mem_write_req <= 0;

        //--------------------------------------------------------
        // Memory accepts write
        //--------------------------------------------------------

        @(posedge clk);

        memory_ready <= 1;

        @(posedge clk);

        print_status();

        memory_ready <= 0;

        //--------------------------------------------------------
        // WRITE_DONE -> IDLE
        //--------------------------------------------------------

        @(posedge clk);

        print_status();

        //--------------------------------------------------------
        // TEST CASE 3 : BACK-TO-BACK READ REQUESTS
        //--------------------------------------------------------

        $display("TEST CASE 3 : BACK TO BACK READ");

        @(posedge clk);

        mem_read_req <= 1;
        cache_addr   <= 32'h00003000;

        @(posedge clk);

        mem_read_req <= 0;

        @(posedge clk);

        memory_ready     <= 1;
        memory_read_data <= 32'h12345678;

        @(posedge clk);

        print_status();

        memory_ready <= 0;

        @(posedge clk);

        print_status();

        //--------------------------------------------------------
        // End Simulation
        //--------------------------------------------------------

        #20;

        $display("\n==============================================");
        $display(" MEMORY INTERFACE V2 TEST COMPLETED");
        $display("==============================================\n");

        $finish;

    end

endmodule