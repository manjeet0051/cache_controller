module cache_fsm_v2 (

    input  logic clk,
    input  logic rst_n,

    
    // CPU Request
    input  logic cpu_req,
    input  logic cpu_read,
    input  logic cpu_write,

    
    // Cache Status
    input  logic cache_hit,
    input  logic dirty,

    
    // Memory Interface
    input  logic mem_ready,

    
    // Control Outputs
    output logic cache_read,
    output logic cache_write,

    output logic mem_read,
    output logic mem_write,

    output logic update_cache,

    output logic cpu_ready,

    // Debug
    output logic [3:0] state_dbg

);

    // State Encoding
    typedef enum logic [3:0] {

        IDLE         = 4'd0,
        COMPARE_TAG  = 4'd1,
        READ_HIT     = 4'd2,
        WRITE_HIT    = 4'd3,
        CHECK_DIRTY  = 4'd4,
        WRITE_BACK   = 4'd5,
        ALLOCATE     = 4'd6,
        UPDATE_CACHE = 4'd7,
        COMPLETE     = 4'd8

    } state_t;

    state_t state, next_state;

    
    // State Register
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    // Debug Output
    assign state_dbg = state;

    
    // Next-State Logic
    always_comb begin

        next_state = state;

        case (state)

            IDLE:
                if (cpu_req)
                    next_state = COMPARE_TAG;

            COMPARE_TAG:
                if (cache_hit) begin
                    if (cpu_read)
                        next_state = READ_HIT;
                    else if (cpu_write)
                        next_state = WRITE_HIT;
                end
                else begin
                    next_state = CHECK_DIRTY;
                end

            READ_HIT:
                next_state = COMPLETE;

            WRITE_HIT:
                next_state = COMPLETE;

            CHECK_DIRTY:
                if (dirty)
                    next_state = WRITE_BACK;
                else
                    next_state = ALLOCATE;

            WRITE_BACK:
                if (mem_ready)
                    next_state = ALLOCATE;

            ALLOCATE:
                if (mem_ready)
                    next_state = UPDATE_CACHE;

            UPDATE_CACHE:
                next_state = COMPLETE;

            COMPLETE:
                next_state = IDLE;

            default:
                next_state = IDLE;

        endcase

    end

    // Output Logic
    always_comb begin

        cache_read   = 1'b0;
        cache_write  = 1'b0;
        mem_read     = 1'b0;
        mem_write    = 1'b0;
        update_cache = 1'b0;
        cpu_ready    = 1'b0;

        case (state)

            READ_HIT:
                cache_read = 1'b1;

            WRITE_HIT:
                cache_write = 1'b1;

            WRITE_BACK:
                mem_write = 1'b1;

            ALLOCATE:
                mem_read = 1'b1;

            UPDATE_CACHE:
                update_cache = 1'b1;

            COMPLETE:
                cpu_ready = 1'b1;

            default: ;

        endcase

    end

endmodule