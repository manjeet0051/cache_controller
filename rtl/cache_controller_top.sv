module cache_controller_top
#(
    parameter ADDR_WIDTH  = 32,
    parameter DATA_WIDTH  = 32,

    parameter INDEX_WIDTH = 6,
    parameter TAG_WIDTH   = 22,
    parameter OFFSET_WIDTH= 4
)
(
    input logic clk,
    input logic rst_n,


    //--------------------------------------------------
    // CPU Interface
    //--------------------------------------------------

    input logic                    cpu_req,
    input logic                    cpu_read,

    input logic [ADDR_WIDTH-1:0]   cpu_addr,


    output logic [DATA_WIDTH-1:0]  cpu_read_data,
    output logic                   cpu_ready

);



    //--------------------------------------------------
    // Address Decoder
    //--------------------------------------------------

    logic [TAG_WIDTH-1:0] tag;
    logic [INDEX_WIDTH-1:0] index;
    logic [OFFSET_WIDTH-1:0] offset;



    address_decoder
    #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .INDEX_BITS(INDEX_WIDTH),
        .OFFSET_BITS(OFFSET_WIDTH)
    )
    u_decoder
    (
        .addr(cpu_addr),

        .tag(tag),
        .index(index),
        .offset(offset)

    );



    //--------------------------------------------------
    // Tag RAM
    //--------------------------------------------------

    logic [TAG_WIDTH-1:0] stored_tag;

    logic valid_bit;


    logic tag_we;



    tag_ram
    #(
        .TAG_BITS(TAG_WIDTH),
        .CACHE_LINES(1<<INDEX_WIDTH)

    )
    u_tag_ram
    (

        .clk(clk),
        .rst_n(rst_n),

        .tag_we(tag_we),

        .index(index),

        .tag_in(tag),

        .valid_in(tag_we),


        .tag_out(stored_tag),

        .valid_out(valid_bit)

    );




    //--------------------------------------------------
    // Comparator
    //--------------------------------------------------

    logic cache_hit;



    tag_comparator
    #(
        .TAG_BITS(TAG_WIDTH)

    )
    u_comparator
    (

        .req_tag(tag),

        .stored_tag(stored_tag),

        .valid(valid_bit),

        .hit(cache_hit),

        .miss()

    );




    //--------------------------------------------------
    // Data RAM
    //--------------------------------------------------

    logic data_we;

    logic [DATA_WIDTH-1:0] cache_data;

    logic [DATA_WIDTH-1:0] data_in;



    data_ram
    #(
        .DATA_WIDTH(DATA_WIDTH),
        .CACHE_LINES(1<<INDEX_WIDTH),
        .WORDS_PER_LINE(4)

    )
    u_data_ram
    (

        .clk(clk),
        .rst_n(rst_n),

        .we(data_we),

        .index(index),

        .word_offset(offset[1:0]),

        .data_in(data_in),

        .data_out(cache_data)

    );




    //--------------------------------------------------
    // FSM Signals
    //--------------------------------------------------

    logic cache_read;
    logic mem_read;

    logic update_cache;

    logic mem_ready;



    //--------------------------------------------------
    // Cache FSM
    //--------------------------------------------------

    cache_fsm
    u_cache_fsm
    (

        .clk(clk),
        .rst_n(rst_n),


        .cpu_req(cpu_req),

        .cache_hit(cache_hit),

        .mem_ready(mem_ready),


        .cache_read(cache_read),

        .mem_read(mem_read),

        .update_cache(update_cache),

        .cpu_ready(cpu_ready)

    );




    //--------------------------------------------------
    // Memory Interface Signals
    //--------------------------------------------------

    logic memory_read;

    logic [ADDR_WIDTH-1:0] memory_addr;


    logic [DATA_WIDTH-1:0] memory_read_data;


    logic cache_data_valid;

    logic [DATA_WIDTH-1:0] cache_fill_data;




    //--------------------------------------------------
    // Memory Interface
    //--------------------------------------------------

    memory_interface
    #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)

    )
    u_memory_interface
    (

        .clk(clk),
        .rst_n(rst_n),


        .mem_read_req(mem_read),

        .cache_addr(cpu_addr),



        .mem_ready(mem_ready),

        .mem_rdata(memory_read_data),



        .mem_read(memory_read),

        .mem_addr(memory_addr),



        .data_valid(cache_data_valid),

        .cache_data(cache_fill_data)

    );





    //--------------------------------------------------
    // Main Memory
    //--------------------------------------------------


    main_memory
    #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)

    )
    u_main_memory
    (

        .clk(clk),
        .rst_n(rst_n),


        .mem_read(memory_read),

        .mem_addr(memory_addr),


        .mem_ready(mem_ready),

        .mem_rdata(memory_read_data)

    );





    //--------------------------------------------------
    // Cache Update Control
    //--------------------------------------------------

    assign tag_we  = update_cache;

    assign data_we = update_cache;


    assign data_in =
            update_cache ?
            cache_fill_data :
            '0;



    //--------------------------------------------------
    // CPU Read Data
    //--------------------------------------------------

    always_comb
    begin

        cpu_read_data = cache_data;

    end



endmodule