`timescale 1ns / 1ps

module top(
input logic start,
input logic [7:0] data_in,
input logic clk,
input logic rst,
output logic out_tx
    );
    
    logic w1;
    logic w2;
    logic w3;
    logic [19:0] w4;
    logic w5;
    logic w6;
    logic w7;
    logic [3:0] w8;
    logic w9;
    logic w10;
    logic w11;
    logic w12;
    logic w14;
    logic [10:0] w13;
    logic a;
    logic [10:0] info;
    
    assign info = {1'b1, w1, data_in, 1'b0};
    and(a, w6,w10);
    and(w3,start, ~w2);
    or(w7, w3, a);
    or(w9, a, rst);
    and(w12,w11,w5,start);
    or(out_tx, ~w2, w14);
    
    crc_calc crc_calc0(
    .in(data_in),
    .out(w1)
    );
    
    Counter_baud_rate cnt0(
    .rst(rst),
    .clk(clk),
    .en(w2),
    .rst_sync(w6),
    .out(w4)
    );
    
    equalityverif #(.width_A(20), .width_B(20)) eq1(
    .in1(w4),
    .in2(20'b0),
    .out(w5) 
    ); 
    
    
    equalityverif #(.width_A(20), .width_B(20))eq2(
    .in1(20'd5208),
    .in2(w4),
    .out(w6) 
    ); 
    
    equalityverif #(.width_A(4), .width_B(4)) eq3(
    .in1(w8),
    .in2(4'b0),
    .out(w11) 
    );
    
    equalityverif #(.width_A(4), .width_B(4))eq4(
    .in1(4'd10),
    .in2(w8),
    .out(w10) 
    ); 
    
    toggle_ff tgl(
    .toggle(w7),
    .clk(clk),
    .rst(rst),
    .out(w2)
    );
    
    counter_bit_select cbs(
    .rst(w9),
    .en(w6),
    .clk(clk),
    .out(w8)
    );
    
    reg0 reg1(
    .clk(clk),
    .load(w12),
    .rst(rst),
    .data_in(info),
    .data_out(w13)
    );
    
    mux mux0(
    .sel(w8),
    .in(w13),
    .out(w14)
    );
    
    
endmodule
