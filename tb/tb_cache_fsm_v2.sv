`timescale 1ns/1ps

module tb_cache_fsm_v2;

    
    // Clock & Reset
    logic clk;
    logic rst_n;

    
    // CPU Interface
    logic cpu_req;
    logic cpu_read;
    logic cpu_write;

    
    // Cache Status
    logic cache_hit;
    logic dirty;

    
    // Memory Interface
    logic mem_ready;

    
    // DUT Outputs
    logic cache_read;
    logic cache_write;

    logic mem_read;
    logic mem_write;

    logic update_cache;

    logic cpu_ready;

    logic [3:0] state_dbg;

    
    // DUT
    cache_fsm_v2 dut(

        .clk(clk),
        .rst_n(rst_n),

        .cpu_req(cpu_req),
        .cpu_read(cpu_read),
        .cpu_write(cpu_write),

        .cache_hit(cache_hit),
        .dirty(dirty),

        .mem_ready(mem_ready),

        .cache_read(cache_read),
        .cache_write(cache_write),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .update_cache(update_cache),

        .cpu_ready(cpu_ready),

        .state_dbg(state_dbg)

    );

    
    // Clock Generation
    always #5 clk = ~clk;

    // State Name Printer
    task automatic print_state;

    begin

        case(state_dbg)

            4'd0 : $write("IDLE");
            4'd1 : $write("COMPARE_TAG");
            4'd2 : $write("READ_HIT");
            4'd3 : $write("WRITE_HIT");
            4'd4 : $write("CHECK_DIRTY");
            4'd5 : $write("WRITE_BACK");
            4'd6 : $write("ALLOCATE");
            4'd7 : $write("UPDATE_CACHE");
            4'd8 : $write("COMPLETE");

            default:
                $write("UNKNOWN");

        endcase

    end

    endtask

    // Status Printer
    task automatic print_status;

    begin


        $write("Time : %0t | State : ",$time);
        print_state();
        $display("");


        $display("cpu_req      = %0b",cpu_req);
        $display("cpu_read     = %0b",cpu_read);
        $display("cpu_write    = %0b",cpu_write);

        $display("");

        $display("cache_hit    = %0b",cache_hit);
        $display("dirty        = %0b",dirty);

        $display("");

        $display("mem_ready    = %0b",mem_ready);

        $display("");

        $display("cache_read   = %0b",cache_read);
        $display("cache_write  = %0b",cache_write);

        $display("mem_read     = %0b",mem_read);
        $display("mem_write    = %0b",mem_write);

        $display("update_cache = %0b",update_cache);

        $display("cpu_ready    = %0b",cpu_ready);


    end

    endtask

    
    // Test Sequence
    initial begin

        $dumpfile("cache_fsm_v2.vcd");
        $dumpvars(0,tb_cache_fsm_v2);

        $display("\n CACHE FSM v2 SIMULATION START \n");

        clk = 0;

        rst_n = 0;

        cpu_req   = 0;
        cpu_read  = 0;
        cpu_write = 0;

        cache_hit = 0;
        dirty     = 0;

        mem_ready = 0;

        
        // RESET
        #20;
        rst_n = 1;

        
        // TEST CASE 1 : READ HIT
        $display("TEST CASE 1 : READ HIT");

        @(posedge clk);

        cpu_req   <= 1;
        cpu_read  <= 1;
        cache_hit <= 1;

        @(posedge clk);

        cpu_req <= 0;

        repeat(3) begin
            @(posedge clk);
            print_status();
        end

        cpu_read  <= 0;
        cache_hit <= 0;

        
        // TEST CASE 2 : WRITE HIT
        $display("TEST CASE 2 : WRITE HIT");

        @(posedge clk);

        cpu_req    <= 1;
        cpu_write  <= 1;
        cache_hit  <= 1;

        @(posedge clk);

        cpu_req <= 0;

        repeat(3) begin
            @(posedge clk);
            print_status();
        end

        cpu_write <= 0;
        cache_hit <= 0;

                
        // TEST CASE 3 : READ MISS (CLEAN CACHE LINE)
        $display("TEST CASE 3 : READ MISS (CLEAN)");

        @(posedge clk);

        cpu_req    <= 1;
        cpu_read   <= 1;

        cache_hit  <= 0;
        dirty      <= 0;

        @(posedge clk);

        cpu_req <= 0;

        // COMPARE_TAG -> CHECK_DIRTY
        @(posedge clk);
        print_status();

        // CHECK_DIRTY -> ALLOCATE
        @(posedge clk);
        print_status();

        // Memory returns data
        mem_ready <= 1;

        @(posedge clk);
        print_status();

        mem_ready <= 0;

        // UPDATE_CACHE
        @(posedge clk);
        print_status();

        // COMPLETE
        @(posedge clk);
        print_status();

        cpu_read <= 0;

        // TEST CASE 4 : WRITE MISS (DIRTY CACHE LINE)
        $display("TEST CASE 4 : WRITE MISS (DIRTY)");

        @(posedge clk);

        cpu_req    <= 1;
        cpu_write  <= 1;

        cache_hit  <= 0;
        dirty      <= 1;

        @(posedge clk);

        cpu_req <= 0;

        // CHECK_DIRTY
        @(posedge clk);
        print_status();

        // WRITE_BACK
        @(posedge clk);
        print_status();

        
        // Old cache line written back
        mem_ready <= 1;

        @(posedge clk);
        print_status();

        mem_ready <= 0;

        
        // Allocate new cache line
        @(posedge clk);

        mem_ready <= 1;

        @(posedge clk);
        print_status();

        mem_ready <= 0;

        
        // UPDATE_CACHE
        @(posedge clk);
        print_status();

        
        // COMPLETE
        @(posedge clk);
        print_status();

        cpu_write <= 0;
        dirty     <= 0;

        
        // End Simulation
        #20;
        $display(" ALL TEST CASES EXECUTED SUCCESSFULLY");

        $finish;

    end

endmodule