module testbench ();
    parameter FIFO_WIDTH = 4;
    parameter FIFO_DEPTH = 16;

    bit clk_a, clk_b, rst;
    reg wen_a, ren_b;
    reg [FIFO_WIDTH-1:0]din_a;

    wire [FIFO_WIDTH-1:0]dout_b;
    wire full, empty;

    FIFO #(
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    )fifo(
        .clk_a(clk_a), .clk_b(clk_b), .rst(rst),
        .wen_a(wen_a), .ren_b(ren_b),

        .din_a(din_a), .dout_b(dout_b),

        .full(full), .empty(empty)
    );

    reg [FIFO_WIDTH-1:0]counter;

    initial begin
        forever #1 clk_b = ~clk_b;
    end

    initial begin
        forever #1 clk_a = ~clk_a;
    end

    initial begin
        counter = 0;
        $readmemb ("fifoo.dat", fifo.rg.memory);
        rstchk;

    // Test 1: wen_a = 1 & ren_b = 0
        wen_a = 1; ren_b = 0;
        repeat(FIFO_DEPTH) begin
            din_a = din_a+1;
            if (din_a==0) din_a = 1;
            @(posedge clk_a);
        end
        // it must be FULL now
        repeat(3) begin 
            din_a = 0;
            @(posedge clk_a);
        end

    // Test 2: wen_a = 0 & ren_b = 1
        wen_a = 0; ren_b = 1;
        repeat(FIFO_DEPTH) begin
            @(posedge clk_b);
            if (dout_b != counter) begin
                $display("Error - dout_b");
            end
            counter = counter + 1;
            if (counter == 0) counter = 1;
        end
        // it must be EMPTY now
        repeat(3) @(posedge clk_b);

    // Test 3: wen_a = 1 & ren_b = 1
        wen_a = 1; ren_b = 0;
        din_a = 1;
        @(posedge clk_a);
        wen_a = 1; ren_b = 1;
        repeat(1000) begin
            din_a = $random;
            @(posedge clk_a);
        end
        $stop;
    end

    task rstchk;
        rst = 1;
        din_a = 0;
        @(posedge clk_a);
        @(posedge clk_b);
        if (dout_b || ~empty || full) begin
            $display("Error - rst");
        end
        rst = 0;
    endtask
endmodule