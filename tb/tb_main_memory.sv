`timescale 1ns/1ps

module tb_main_memory;

    //------------------------------------------------------------
    // Parameters
    //------------------------------------------------------------

    parameter ADDR_WIDTH = 32;
    parameter DATA_WIDTH = 32;
    parameter MEM_DEPTH  = 256;
    parameter LATENCY    = 2;

    //------------------------------------------------------------
    // Clock & Reset
    //------------------------------------------------------------

    logic clk;
    logic rst_n;

    //------------------------------------------------------------
    // DUT Inputs
    //------------------------------------------------------------

    logic                     memory_read;
    logic                     memory_write;

    logic [ADDR_WIDTH-1:0]    memory_addr;
    logic [DATA_WIDTH-1:0]    memory_write_data;

    //------------------------------------------------------------
    // DUT Outputs
    //------------------------------------------------------------

    logic [DATA_WIDTH-1:0]    memory_read_data;
    logic                     memory_ready;
    logic                     busy;
    logic [2:0]               state_dbg;

    //------------------------------------------------------------
    // DUT
    //------------------------------------------------------------

    main_memory #(

        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .MEM_DEPTH(MEM_DEPTH),
        .LATENCY(LATENCY)

    ) dut (

        .clk(clk),
        .rst_n(rst_n),

        .memory_read(memory_read),
        .memory_write(memory_write),

        .memory_addr(memory_addr),
        .memory_write_data(memory_write_data),

        .memory_read_data(memory_read_data),
        .memory_ready(memory_ready),
        .busy(busy),

        .state_dbg(state_dbg)

    );

    //------------------------------------------------------------
    // Clock Generation
    //------------------------------------------------------------

    always #5 clk = ~clk;

    //------------------------------------------------------------
    // State Printer
    //------------------------------------------------------------

    task automatic print_state;

    begin

        case(state_dbg)

            3'd0 : $write("IDLE");
            3'd1 : $write("READ_WAIT");
            3'd2 : $write("READ_DONE");
            3'd3 : $write("WRITE_WAIT");
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

        $display("\n===================================================");

        $write("Time : %0t | State : ", $time);
        print_state();
        $display("");

        $display("---------------------------------------------------");

        $display("memory_read       = %0b", memory_read);
        $display("memory_write      = %0b", memory_write);

        $display("");

        $display("memory_addr       = %h", memory_addr);
        $display("write_data        = %h", memory_write_data);

        $display("");

        $display("read_data         = %h", memory_read_data);
        $display("memory_ready      = %0b", memory_ready);
        $display("busy              = %0b", busy);

        $display("===================================================\n");

    end

    endtask;

    //------------------------------------------------------------
    // Test Sequence
    //------------------------------------------------------------

    initial
    begin

        $dumpfile("main_memory.vcd");
        $dumpvars(0, tb_main_memory);

        $display("\n===== MAIN MEMORY SIMULATION START =====\n");

        //--------------------------------------------------------
        // Initialize Signals
        //--------------------------------------------------------

        clk = 0;
        rst_n = 0;

        memory_read = 0;
        memory_write = 0;

        memory_addr = 0;
        memory_write_data = 0;

        //--------------------------------------------------------
        // Reset
        //--------------------------------------------------------

        #20;
        rst_n = 1;

        //--------------------------------------------------------
        // TEST CASE 1 : WRITE OPERATION
        //--------------------------------------------------------

        $display("TEST CASE 1 : WRITE");

        @(posedge clk);

        memory_write      <= 1;
        memory_addr       <= 32'h00000020;
        memory_write_data <= 32'hCAFEBABE;

        @(posedge clk);

        memory_write <= 0;

                //--------------------------------------------------------
        // Wait for Write Completion
        //--------------------------------------------------------

        repeat(LATENCY + 2) @(posedge clk);

        print_status();

        //--------------------------------------------------------
        // TEST CASE 2 : READ OPERATION
        //--------------------------------------------------------

        $display("TEST CASE 2 : READ");

        @(posedge clk);

        memory_read <= 1;
        memory_addr <= 32'h00000020;

        @(posedge clk);

        memory_read <= 0;

        repeat(LATENCY + 2) @(posedge clk);

        print_status();

        //--------------------------------------------------------
        // TEST CASE 3 : READ AFTER WRITE
        //--------------------------------------------------------

        if(memory_read_data == 32'hCAFEBABE)
            $display("PASS : Read After Write Successful");
        else
            $display("FAIL : Expected CAFEBABE, Got %h", memory_read_data);

        //--------------------------------------------------------
        // TEST CASE 4 : WRITE ANOTHER LOCATION
        //--------------------------------------------------------

        $display("\nTEST CASE 4 : WRITE SECOND LOCATION");

        @(posedge clk);

        memory_write      <= 1;
        memory_addr       <= 32'h00000040;
        memory_write_data <= 32'h12345678;

        @(posedge clk);

        memory_write <= 0;

        repeat(LATENCY + 2) @(posedge clk);

        print_status();

        //--------------------------------------------------------
        // TEST CASE 5 : READ SECOND LOCATION
        //--------------------------------------------------------

        $display("\nTEST CASE 5 : READ SECOND LOCATION");

        @(posedge clk);

        memory_read <= 1;
        memory_addr <= 32'h00000040;

        @(posedge clk);

        memory_read <= 0;

        repeat(LATENCY + 2) @(posedge clk);

        print_status();

        if(memory_read_data == 32'h12345678)
            $display("PASS : Second Location Read Successful");
        else
            $display("FAIL : Expected 12345678, Got %h", memory_read_data);

        //--------------------------------------------------------
        // TEST CASE 6 : IDLE CHECK
        //--------------------------------------------------------

        $display("\nTEST CASE 6 : IDLE STATE");

        @(posedge clk);

        print_status();

        //--------------------------------------------------------
        // End Simulation
        //--------------------------------------------------------

        #20;

        $display("\n=========================================");
        $display(" MAIN MEMORY TEST COMPLETED SUCCESSFULLY");
        $display("=========================================\n");

        $finish;

    end

endmodule