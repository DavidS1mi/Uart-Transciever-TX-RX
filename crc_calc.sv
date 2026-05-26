`timescale 1ns / 1ps

module crc_calc(
input logic [7:0] in,
output logic out
    );
    
    assign out = ^in;
    
endmodule
