module address_decoder #(

parameter ADDR_WIDTH = 32,
parameter INDEX_BITS = 6,
parameter OFFSET_BITS = 4

)(

input logic [ADDR_WIDTH-1:0] addr,

output logic [ADDR_WIDTH-INDEX_BITS-OFFSET_BITS-1:0] tag,
output logic [INDEX_BITS-1:0] index,
output logic [OFFSET_BITS-1:0] offset

);


always_comb
begin

    offset = addr[OFFSET_BITS-1:0];

    index  = addr[OFFSET_BITS + INDEX_BITS -1 : OFFSET_BITS];

    tag    = addr[ADDR_WIDTH-1 :
                  OFFSET_BITS + INDEX_BITS];

end


endmodule