module testbench_2 ();
    parameter FIFO_WIDTH = 4;
    parameter FIFO_DEPTH = 16;
    parameter CLK_W_TIME = 2;
    parameter CLK_R_TIME = 1;

    bti clk_w, clk_r, rst;
    reg wen, ren;
    reg [FIFO_WIDTH-1:0]din;

    wire [FIFO_WIDTH-1:0]dout;
    wire full, empty;

    FIFO #(
        .FIFO_WIDTH(FIFO_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH)
    )fifo(
        .clk_w(clk_w), .clk_r(clk_r), .rst(rst),
        .wen(wen), .ren(ren),

        .din(din), .dout(dout),

        .full(full), .empty(empty)
    );

    reg [FIFO_WIDTH-1:0]counter;

    initial begin
        forever  #1 clk_r = ~clk_r;
    end

    initial begin
        forever #2 clk_w = ~clk_w;
    end

// Write block
    initial begin
        //$readmemb ("fifoo.dat", fifo.rg.memory);
        rstchk;

    // Test 1: wen = 1 & ren = 0
        wen = 1;
        repeat(FIFO_DEPTH) begin
            din = din+1;
            if (din==0) din = 1;
            @(posedge clk_w);
        end
        // it must be FULL now
        repeat(3) begin 
            din = 0;
            @(posedge clk_w);
        end
        $display("FINSH W");
        $stop;
    end

// Read block
    initial begin
        rstchk;
        counter = 0;
        //$readmemb ("fifoo.dat", fifo.rg.memory);
        @(posedge clk_w);
        @(posedge clk_w);
    // Test 2: wen = 0 & ren = 1
        ren = 1;
        //repeat(FIFO_DEPTH) begin
        //    @(posedge clk_r);
        //    @(posedge clk_r);
        //    wen = 0; ren = 1;
        //end
            
        /*
        repeat(FIFO_DEPTH * 2) begin
            @(posedge clk_r);
            if (dout != counter && ~empty) begin
                $display("Error - dout");
            end
            if (~empty)
                counter = counter + 1;
            if (counter == 0) counter = 1;
        end
        // it must be EMPTY now
        repeat(3) @(posedge clk_r);
        */
        $display("FINSH R");
        $display("%0d",(FIFO_DEPTH * (1 + CLK_W_TIME-CLK_R_TIME)));
        //$stop;
    end
    
    task rstchk;
        rst = 1;
        ren = 0;
        wen = 0;
        din = 0;
        #3;
        if (dout || ~empty || full) begin
            $display("Error - rst");
        end
        rst = 0;
    endtask
endmodule