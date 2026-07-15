module data_ram #(
    parameter DATA_WIDTH = 32,
    parameter CACHE_LINES = 64,
    parameter WORDS_PER_LINE = 4
)(
    input  logic clk,
    input  logic rst_n,
    input  logic we,

    input  logic [$clog2(CACHE_LINES)-1:0] index,

    input  logic [$clog2(WORDS_PER_LINE)-1:0] word_offset,

    input  logic [DATA_WIDTH-1:0] data_in,

    output logic [DATA_WIDTH-1:0] data_out
);


    logic [DATA_WIDTH-1:0]
        data_mem [0:CACHE_LINES-1][0:WORDS_PER_LINE-1];


    integer i,j;


    always_ff @(posedge clk or negedge rst_n)
    begin

        if(!rst_n)
        begin

            for(i=0;i<CACHE_LINES;i=i+1)
            begin

                for(j=0;j<WORDS_PER_LINE;j=j+1)
                begin
                    data_mem[i][j] <= '0;
                end

            end

        end


        else if(we)
        begin
            data_mem[index][word_offset] <= data_in;

        end

    end



    assign data_out = data_mem[index][word_offset];


endmodule