module main_memory
#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter MEM_DEPTH  = 256,
    parameter LATENCY    = 2
)
(
    input  logic clk,
    input  logic rst_n,

    // From memory interface
    input  logic                   mem_read,
    input  logic [ADDR_WIDTH-1:0]  mem_addr,

    // To memory interface
    output logic                   mem_ready,
    output logic [DATA_WIDTH-1:0]  mem_rdata
);


    //--------------------------------------------------
    // Memory Array
    //--------------------------------------------------

    logic [DATA_WIDTH-1:0] memory [0:MEM_DEPTH-1];


    //--------------------------------------------------
    // Registers
    //--------------------------------------------------

    logic [ADDR_WIDTH-1:0] addr_reg;

    logic [$clog2(LATENCY+1)-1:0] count;


    //--------------------------------------------------
    // FSM
    //--------------------------------------------------

    typedef enum logic [1:0]
    {
        IDLE,
        READ_WAIT,
        DONE

    } state_t;


    state_t state,next_state;



    //--------------------------------------------------
    // State Register
    //--------------------------------------------------

    always_ff @(posedge clk or negedge rst_n)
    begin

        if(!rst_n)
            state <= IDLE;

        else
            state <= next_state;

    end



    //--------------------------------------------------
    // Next State
    //--------------------------------------------------

    always_comb
    begin

        next_state = state;

        case(state)

            IDLE:
            begin
                if(mem_read)
                    next_state = READ_WAIT;
            end


            READ_WAIT:
            begin
                if(count == LATENCY-1)
                    next_state = DONE;
            end


            DONE:
            begin
                next_state = IDLE;
            end


            default:
                next_state = IDLE;

        endcase

    end



    //--------------------------------------------------
    // Output Logic
    //--------------------------------------------------

    always_comb
    begin

        mem_ready = 1'b0;

        if(state == DONE)
            mem_ready = 1'b1;

    end



    //--------------------------------------------------
    // Memory Operation
    //--------------------------------------------------

    integer i;


    always_ff @(posedge clk or negedge rst_n)
    begin

        if(!rst_n)
        begin

            addr_reg  <= '0;
            mem_rdata <= '0;
            count     <= '0;


            //--------------------------------------------------
            // Initialize Main Memory
            //--------------------------------------------------

            for(i=0;i<MEM_DEPTH;i=i+1)
                memory[i] <= 32'h00000000;


            // Address 0x20 -> memory[8]
            memory[8]  <= 32'hAAAA1111;


            // Address 0x40 -> memory[16]
            memory[16] <= 32'hBBBB2222;


            // Address 0x80 -> memory[32]
            memory[32] <= 32'hCCCC3333;


        end


        else
        begin

            case(state)


                //--------------------------------------------------
                // Capture request
                //--------------------------------------------------

                IDLE:
                begin

                    count <= 0;

                    if(mem_read)
                    begin

                        addr_reg <= mem_addr;

                    end

                end



                //--------------------------------------------------
                // Wait latency
                //--------------------------------------------------

                READ_WAIT:
                begin

                    if(count < LATENCY)
                        count <= count + 1;


                    if(count == LATENCY-1)
                    begin

                        mem_rdata <= memory[addr_reg[9:2]];


                        $display("--------------------------------");
                        $display("MAIN MEMORY READ");
                        $display("Address : %h",addr_reg);
                        $display("Data    : %h",memory[addr_reg[9:2]]);
                        $display("--------------------------------");

                    end

                end



                //--------------------------------------------------
                // Complete
                //--------------------------------------------------

                DONE:
                begin

                    count <= 0;

                end



                default:
                begin

                    count <= 0;

                end


            endcase

        end

    end


endmodule