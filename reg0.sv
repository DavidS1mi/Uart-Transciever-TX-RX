`timescale 1ns / 1ps

module reg0(
input logic clk,
input logic rst,
input logic load,
input logic [10:0] data_in,
output logic [10:0] data_out
    );
    
    always_ff @(posedge clk) begin
    if(rst == 1)
        data_out <= 11'd0;
    else
        if(load == 1)
        begin
        data_out <= data_in;  
        end
end
    
endmodule
