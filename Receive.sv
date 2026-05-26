`timescale 1ns / 1ps

module Receive(
input logic clk,
input logic rst,
input logic rx_in,
output logic [7:0] data_out,
output logic valid
    );
    
localparam idle  = 3'b000; 
localparam start = 3'b001;
localparam data = 3'b010;
localparam parity = 3'b011;
localparam stop = 3'b100;
logic [2:0] state;
logic [19:0] baud_cnt;
logic [3:0]  bit_cnt;
logic [7:0]  shift_reg;
localparam baud_rate = 5208;
localparam baud_rate_partial = 2604;

always_ff @(posedge clk) begin
        if (rst) begin
            state <= idle;
            baud_cnt <= 0;
            bit_cnt <= 0;
            valid <= 0;
            data_out <= 0;
        end else begin
            valid <= 0; 

            case (state)
                idle: begin
                    baud_cnt <= 0;
                    bit_cnt <= 0;
                    if (rx_in == 1'b0) begin
                        state <= start;
                    end
                end

                start: begin
                    if (baud_cnt == baud_rate_partial) begin
                        baud_cnt <= 0;
                        if (rx_in == 1'b0) begin
                            state <= data;
                        end else begin
                            state <= idle;
                        end
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end

                data: begin
                    if (baud_cnt == baud_rate) begin
                        baud_cnt <= 0;
                        shift_reg <= {rx_in, shift_reg[7:1]};
                        bit_cnt   <= bit_cnt + 1;
                        
                        if (bit_cnt == 7) begin
                            state <= parity;
                        end
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end

                parity: begin
                    if (baud_cnt == baud_rate) begin
                        baud_cnt <= 0;
                        state <= stop;
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end

                stop: begin 
                    if (baud_cnt == baud_rate) begin
                        baud_cnt <= 0;
                        if (rx_in == 1'b1) begin 
                            data_out <= shift_reg;
                            valid <= 1'b1;
                        end
                        state <= idle;
                    end else begin
                        baud_cnt <= baud_cnt + 1;
                    end
                end
                
                default: state <= idle;
            endcase
        end
    end
endmodule

