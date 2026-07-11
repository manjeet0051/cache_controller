module tag_comparator #(
    parameter TAG_BITS = 22
)(
    input  logic [TAG_BITS-1:0] req_tag,
    input  logic [TAG_BITS-1:0] stored_tag,
    input  logic                valid,

    output logic                hit,
    output logic                miss
);

    always_comb begin

        if(valid && (req_tag == stored_tag))
            hit = 1'b1;
        else
            hit = 1'b0;

        miss = ~hit;

    end

endmodule