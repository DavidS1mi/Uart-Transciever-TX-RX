`timescale 1ns / 1ps

module tb_transceiver();

    logic clk;
    logic rst;
    logic start;
    logic [7:0] data_in;
    logic [7:0] data_out;
    logic valid;
    logic auxwire;

    transceiver UUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .tx_pin(auxwire), 
        .rx_pin(auxwire), 
        .data_out(data_out),
        .valid(valid)
    );

   initial
        begin
	    clk = 0;
	forever
		    begin
		#5 clk = ~clk;
		    end
    end

    initial begin
        rst = 1;
        start = 0;
        data_in = 8'h00;
        
        #100;
        rst = 0;
        #100;

        data_in = 8'hAB; 
        start = 1;       
        #10;             
        start = 0;       
        #600000;
        
        data_in = 8'h55; 
        start = 1;
        #10;
        start = 0;
        #600000;
        
        #1000;
        $stop;
    end

endmodule
