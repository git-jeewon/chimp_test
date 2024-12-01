`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 04:33:10 PM
// Design Name: 
// Module Name: player
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module player(
    input clk, rst, left, right, up, down,
    output [1:0] row, output [1:0] col
);

    reg [1:0] row_reg, col_reg;
    reg left_d = 0;
    reg right_d = 0;
    reg up_d = 0;
    reg down_d = 0; // Previous states of buttons
    reg left_edge, right_edge, up_edge, down_edge; // Edge detection signals
    
    localparam rowMax = 2;
    localparam colMax = 2;

    // Detect rising edge for the left, right, up, down buttons
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            left_d <= 0;
            right_d <= 0;
            up_d <= 0;
            down_d <= 0;
        end else begin
            left_d <= left;
            right_d <= right;
            up_d <= up;
            down_d <= down;
        end
    end

    // Edge detection (detect rising edge)
    always @(posedge clk) begin
        left_edge <= left && ~left_d;    // Rising edge on left button
        right_edge <= right && ~right_d; // Rising edge on right button
        up_edge <= up && ~up_d;          // Rising edge on up button
        down_edge <= down && ~down_d;    // Rising edge on down button
    end

    // Movement logic based on edge detection
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            row_reg <= 0;
            col_reg <= 0;
        end else begin
            if (left_edge) begin
                if (col_reg >= 1)
                    col_reg <= col_reg - 1;
            end
            if (right_edge) begin
                if (col_reg + 1 <= colMax)
                    col_reg <= col_reg + 1;
            end
            if (up_edge) begin
                if (row_reg >= 1)
                    row_reg <= row_reg - 1;
            end
            if (down_edge) begin
                if (row_reg + 1 <= rowMax)
                    row_reg <= row_reg + 1;
            end
        end
    end

    // Assign the final row and column output
    assign row = row_reg;
    assign col = col_reg;

endmodule
