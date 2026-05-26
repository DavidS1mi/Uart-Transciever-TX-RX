`timescale 1ns / 1ps

module Counter_baud_rate(
input logic en,
input logic clk,
input logic rst,
input logic rst_sync,
output logic [19:0] out
    );
    
    always_ff @(posedge clk)
    begin
    if(rst == 1)
    out <= 20'd0;
    else if(rst_sync == 1) begin
    out <= 20'd0;
    end else if(en == 1)
    out <= out + 20'd1;
    end 
    
endmodule
