`timescale 1ns/1ps

module tb_cache_controller_top;


parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;


// Clock Reset

logic clk;
logic rst_n;


// CPU Interface

logic cpu_req;
logic cpu_read;

logic [ADDR_WIDTH-1:0] cpu_addr;

wire [DATA_WIDTH-1:0] cpu_read_data;
wire cpu_ready;



// DUT

cache_controller_top dut
(
    .clk(clk),
    .rst_n(rst_n),

    .cpu_req(cpu_req),
    .cpu_read(cpu_read),

    .cpu_addr(cpu_addr),

    .cpu_read_data(cpu_read_data),
    .cpu_ready(cpu_ready)

);



// Clock

always #5 clk = ~clk;



// Dump

initial
begin

    $dumpfile("cache_controller_top.vcd");
    $dumpvars(0,tb_cache_controller_top);

end



// CPU READ TASK

task cpu_read_access(input [31:0] addr);

begin

    @(posedge clk);

    cpu_req  <= 1;
    cpu_read <= 1;
    cpu_addr <= addr;


    @(posedge clk);

    cpu_req  <= 0;
    cpu_read <= 0;


    wait(cpu_ready);


    #2;

    $display("----------------------------------");
    $display("CPU READ COMPLETE");
    $display("Address : %h",addr);
    $display("Data    : %h",cpu_read_data);
    $display("Ready   : %b",cpu_ready);
    $display("----------------------------------");


end

endtask



initial
begin


    $display("\n=================================");
    $display(" CACHE CONTROLLER V1 TEST START ");
    $display("=================================\n");


    clk = 0;

    rst_n = 0;

    cpu_req  = 0;
    cpu_read = 0;
    cpu_addr = 0;



    // Reset

    #20;

    rst_n = 1;



    //-------------------------------------------------
    // TEST 1 : FIRST READ (MISS)
    //-------------------------------------------------

    $display("\nTEST CASE 1 : FIRST READ MISS");

    cpu_read_access(32'h00000020);



    //-------------------------------------------------
    // TEST 2 : SAME ADDRESS READ (HIT)
    //-------------------------------------------------

    $display("\nTEST CASE 2 : READ SAME ADDRESS HIT");

    cpu_read_access(32'h00000020);



    //-------------------------------------------------
    // TEST 3 : DIFFERENT ADDRESS
    //-------------------------------------------------

    $display("\nTEST CASE 3 : READ DIFFERENT ADDRESS");

    cpu_read_access(32'h00002000);



    //-------------------------------------------------
    // TEST 4 : BACK TO BACK READ
    //-------------------------------------------------

    $display("\nTEST CASE 4 : BACK TO BACK");

    cpu_read_access(32'h00003000);

    cpu_read_access(32'h00003000);



    #50;


    $display("\n=================================");
    $display(" TEST COMPLETED ");
    $display("=================================\n");


    $finish;


end


endmodule