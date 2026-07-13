module memory_interface #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  logic                   clk,
    input  logic                   rst_n,

    // From Cache FSM
    input  logic                   mem_read_req,
    input  logic [ADDR_WIDTH-1:0]  cache_addr,

    // From Main Memory
    input  logic                   mem_ready,
    input  logic [DATA_WIDTH-1:0]  mem_rdata,

    // To Main Memory
    output logic                   mem_read,
    output logic [ADDR_WIDTH-1:0]  mem_addr,

    // To Cache FSM
    output logic                   data_valid,
    output logic [DATA_WIDTH-1:0]  cache_data
);

    typedef enum logic [1:0] {
        IDLE,
        WAIT_MEM,
        DONE
    } state_t;

    state_t state, next_state;

    
    // State Register
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    // Next-State Logic
    always_comb begin

        next_state = state;

        case(state)

            IDLE:
                if(mem_read_req)
                    next_state = WAIT_MEM;

            WAIT_MEM:
                if(mem_ready)
                    next_state = DONE;

            DONE:
                next_state = IDLE;

            default:
                next_state = IDLE;

        endcase

    end

    
    // Output Logic
    always_comb begin

        mem_read   = 0;
        mem_addr   = cache_addr;

        data_valid = 0;
        cache_data = mem_rdata;

        case(state)

            WAIT_MEM:
                mem_read = 1;

            DONE:
                data_valid = 1;

        endcase

    end

endmodule