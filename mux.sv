`timescale 1ns / 1ps

module mux(
input logic [10:0] in,
input logic [3:0] sel,
output logic out
    );
    assign out = in[sel];
    
endmodule
