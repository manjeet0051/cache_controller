module cache_fsm(

    input  logic clk,
    input  logic rst_n,

    input  logic cpu_req,
    input  logic cache_hit,
    input  logic mem_ready,

    output logic cache_read,
    output logic mem_read,
    output logic update_cache,
    output logic cpu_ready

);

    typedef enum logic[2:0] {

        IDLE,
        CHECK_CACHE,
        CACHE_HIT,
        MEM_READ,
        UPDATE_CACHE,
        COMPLETE

    } state_t;

    state_t state,next_state;

    //-----------------------------------------
    // State Register
    //-----------------------------------------

    always_ff @(posedge clk or negedge rst_n) begin

        if(!rst_n)
            state <= IDLE;
        else
            state <= next_state;

    end

    //-----------------------------------------
    // Next State Logic
    //-----------------------------------------

    always_comb begin

        next_state = state;

        case(state)

            IDLE:
                if(cpu_req)
                    next_state = CHECK_CACHE;

            CHECK_CACHE:
                if(cache_hit)
                    next_state = CACHE_HIT;
                else
                    next_state = MEM_READ;

            CACHE_HIT:
                next_state = COMPLETE;

            MEM_READ:
                if(mem_ready)
                    next_state = UPDATE_CACHE;

            UPDATE_CACHE:
                next_state = COMPLETE;

            COMPLETE:
                next_state = IDLE;

            default:
                next_state = IDLE;

        endcase

    end

    //-----------------------------------------
    // Output Logic
    //-----------------------------------------

    always_comb begin

        cache_read  = 0;
        mem_read    = 0;
        update_cache= 0;
        cpu_ready   = 0;

        case(state)

            CACHE_HIT:
                cache_read = 1;

            MEM_READ:
                mem_read = 1;

            UPDATE_CACHE:
                update_cache = 1;

            COMPLETE:
                cpu_ready = 1;

        endcase

    end

endmodule