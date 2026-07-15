module tag_ram #(
    parameter TAG_BITS = 22,
    parameter CACHE_LINES = 64
)(
    input  logic clk,
    input  logic rst_n,

    // Tag Write Interface
    input  logic tag_we,

    input  logic [$clog2(CACHE_LINES)-1:0] index,

    input  logic [TAG_BITS-1:0] tag_in,
    input  logic valid_in,

    // Dirty Update Interface
    input  logic dirty_we,
    input  logic dirty_in,


    // Read Interface
    output logic [TAG_BITS-1:0] tag_out,
    output logic valid_out,
    output logic dirty_out
);


    //------------------------------------------------------------
    // Memory Arrays
    //------------------------------------------------------------

    logic [TAG_BITS-1:0] tag_mem [0:CACHE_LINES-1];

    logic valid_mem [0:CACHE_LINES-1];

    logic dirty_mem [0:CACHE_LINES-1];


    integer i;

always_ff @(posedge clk or negedge rst_n)
begin

    if(!rst_n)
    begin

        for(i=0;i<CACHE_LINES;i=i+1)
        begin

            valid_mem[i] <= 1'b0;
            dirty_mem[i] <= 1'b0;
            tag_mem[i] <= '0;

        end

    end

    else
    begin

        if(tag_we)
        begin

            tag_mem[index] <= tag_in;
            valid_mem[index] <= valid_in;
            dirty_mem[index] <= dirty_in;

        end

    end

end


    //------------------------------------------------------------
    // Asynchronous Read
    //------------------------------------------------------------

    assign tag_out   = tag_mem[index];

    assign valid_out = valid_mem[index];

    assign dirty_out = dirty_mem[index];


endmodule