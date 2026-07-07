module cache_controller #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter CACHE_LINES = 64
)(
    input  logic                     clk,
    input  logic                     rst_n,

    //================ CPU Interface ================
    input  logic                     cpu_read,
    input  logic                     cpu_write,
    input  logic [ADDR_WIDTH-1:0]    cpu_addr,
    input  logic [DATA_WIDTH-1:0]    cpu_wdata,

    output logic [DATA_WIDTH-1:0]    cpu_rdata,
    output logic                     cpu_ready,

    //============== Memory Interface ==============
    output logic                     mem_read,
    output logic                     mem_write,
    output logic [ADDR_WIDTH-1:0]    mem_addr,
    output logic [DATA_WIDTH-1:0]    mem_wdata,

    input  logic [DATA_WIDTH-1:0]    mem_rdata,
    input  logic                     mem_ready
);

    
    // Internal Signals
    logic hit;
    logic valid;
    logic dirty;

    logic [19:0] tag;
    logic [5:0]  index;
    logic [5:0]  offset;

   
    // Temporary Logic
    always_comb begin

        cpu_rdata = '0;
        cpu_ready = 1'b0;

        mem_read  = 1'b0;
        mem_write = 1'b0;
        mem_addr  = '0;
        mem_wdata = '0;

    end

endmodule