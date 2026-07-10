module data_ram #(
    parameter DATA_WIDTH = 32,
    parameter CACHE_LINES = 64,
    parameter WORDS_PER_LINE = 4
)(
    input  logic clk,
    input  logic we,

    // Cache line index
    input  logic [$clog2(CACHE_LINES)-1:0] index,

    // Word within cache line
    input  logic [$clog2(WORDS_PER_LINE)-1:0] word_offset,

    input  logic [DATA_WIDTH-1:0] data_in,

    output logic [DATA_WIDTH-1:0] data_out
);

    
    // Memory Declaration
    logic [DATA_WIDTH-1:0]
        data_mem [0:CACHE_LINES-1][0:WORDS_PER_LINE-1];

    
    // Write
    always_ff @(posedge clk) begin

        if (we)
            data_mem[index][word_offset] <= data_in;

    end

    
    // Read (Asynchronous)
    assign data_out = data_mem[index][word_offset];

endmodule