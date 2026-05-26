`timescale 1ns / 1ps

module transceiver (
    input logic clk,
    input logic rst,
    input logic start,
    input logic [7:0] data_in,
    output logic [7:0] data_out,
    output logic valid,
    input  logic rx_pin,  
    output logic tx_pin   
);
    
    
    Receive receiver0(
        .clk(clk),            
        .rst(rst),            
        .rx_in(rx_pin),          
        .data_out(data_out),
        .valid(valid)          
    ); 
  
    
    top top0(
        .clk(clk),          
        .rst(rst),          
        .start(start),        
        .data_in(data_in),
        .out_tx(tx_pin)       
    );  

endmodule