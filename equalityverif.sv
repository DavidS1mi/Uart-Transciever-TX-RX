`timescale 1ns / 1ps

module equalityverif #(parameter width_A = 8, parameter width_B = 16)(
input logic [width_A - 1:0] in1,
input logic [width_B - 1:0] in2,
output logic out
    );
    
    assign out = (in1==in2);
    
endmodule
