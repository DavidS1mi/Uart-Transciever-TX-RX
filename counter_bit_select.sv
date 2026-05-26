`timescale 1ns / 1ps


module counter_bit_select(
input logic en,
input logic rst,
input logic clk,
output logic [3:0] out
    );
    
    always_ff @(posedge clk)
    begin
    if(rst == 1)
    out <= 4'd0;
    else if(en == 1) begin
    out <= out + 4'd1;
    end 
    end
endmodule
