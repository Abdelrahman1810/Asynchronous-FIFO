module register #(
    parameter FIFO_WIDTH = 8,
    parameter FIFO_DEPTH = 512
)(
    input clk_a, clk_b, rst,
    input w_en, r_en,
    input [FIFO_WIDTH-1:0] w_addr, r_addr,
    input [FIFO_WIDTH-1:0] din_a,

    output reg [FIFO_WIDTH-1:0] dout_b
);
    // reg [ADDR_SIZE-1:0] ram [MEM_DEPTH-1:0];
    reg [FIFO_WIDTH-1:0] memory [FIFO_DEPTH-1:0];

    always @(posedge clk_b or posedge rst)
        if (rst)
            dout_b <= 0;
        else if (r_en)
            dout_b <= memory[r_addr];
    
    always @(posedge clk_a)
        if (w_en) 
            memory[w_addr] <= din_a;
endmodule