module address_decoder #(
    parameter ADDR_WIDTH = 32,
    parameter INDEX_BITS = 6,
    parameter OFFSET_BITS = 4
)(
    input  logic [ADDR_WIDTH-1:0] addr,

    output logic [ADDR_WIDTH-INDEX_BITS-OFFSET_BITS-1:0] tag,
    output logic [INDEX_BITS-1:0] index,
    output logic [OFFSET_BITS-1:0] offset
);

    localparam TAG_BITS = ADDR_WIDTH - INDEX_BITS - OFFSET_BITS;

    assign offset = addr[OFFSET_BITS-1:0];
    assign index  = addr[OFFSET_BITS + INDEX_BITS - 1 : OFFSET_BITS];
    assign tag    = addr[ADDR_WIDTH-1 : OFFSET_BITS + INDEX_BITS];

endmodule