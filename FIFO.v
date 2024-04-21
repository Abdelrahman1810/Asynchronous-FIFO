module FIFO #(
    parameter FIFO_WIDTH = 8,
    parameter FIFO_DEPTH = 512
)(
    input clk_a, clk_b, rst,
    input wen_a, ren_b,
    input [FIFO_WIDTH-1:0]din_a,

    output [FIFO_WIDTH-1:0]dout_b,
    output full, empty
);
    wire [FIFO_WIDTH-1:0]w_addr, r_addr;
    wire w_en, r_en;

    assign w_en = wen_a & (~full);
    assign r_en = ren_b & (~empty);

    FIFO_CO #(
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    )controller(
        .clk_a(clk_a), .clk_b(clk_b), .rst(rst),
        .wen_a(wen_a), .ren_b(ren_b),
        
        .full(full), .empty(empty),
        .w_addr(w_addr), .r_addr(r_addr)
    );

    register #(
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    )rg(
        .clk_a(clk_a), .clk_b(clk_b), .rst(rst),
        .w_en(w_en), .r_en(r_en),
        .w_addr(w_addr), .r_addr(r_addr),
        .din_a(din_a),

        .dout_b(dout_b)
    );


endmodule