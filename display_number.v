`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 07:57:25 PM
// Design Name: 
// Module Name: display_number
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


module display_number(
    input clk, input [3:0] number, input [1:0] row, input [1:0] col, input [1:0] p_row, input [1:0] p_col, input [9:0] x, input [9:0] y, input [2:0] state,
    output reg [11:0] rgb
    );
    
    localparam xMax = 213;
    localparam yMax = 160; 
//    localparam xCenter_offset = 107;
//    localparam yCenter_offset = 80;
    localparam width = 20;
    
    wire [9:0] borderL = col * xMax + 75;
    wire [9:0] borderR = col * xMax + 139;
    wire [9:0] borderU = row * yMax + 16;
    wire [9:0] borderD = row * yMax + 144;
    wire [9:0] centerX = col * xMax + 107;
    wire [9:0] centerY = row * yMax + 80;
    //[10:0] rom_addr;
//    reg [6:0] char_addr;
//    reg [3:0] row_addr;
//    reg [2:0] bit_addr;         
//    wire [7:0] rom_data;  
//    wire ascii_bit;
      
//    ascii_rom ascii_unit(.clk(clk), .addr(rom_addr), .data(rom_data));
    
//    assign rom_addr = {ascii_char, char_row};
//    assign ascii_bit = rom_data[~bit_addr];
//    assign ascii_char = {y[5:4], x[7:3]};
//    assign char_row = y[3:0];
//    assign bit_addr = x[2:0];

    always @ (posedge clk) begin
        rgb = 12'h000;
        case (state)
            1: begin
                if (p_row == row && p_col == col)
                    rgb = 12'hF00;
                if (x > borderL && x < borderR && y > borderU && y < borderD) begin
                    if (number == 1)
                        if (x > centerX - width/2 && x < centerX + width/2) 
                            rgb = 12'hFFF;
                    if (number == 2)
                        if ((y < borderU + width) || 
                           (x > borderR - width && y < centerY) ||
                           (y > centerY - width/2 && y < centerY + width/2) ||
                           (x < borderL + width && y > centerY) ||
                           (y > borderD - width)) 
                                rgb = 12'hFFF;
                          
                    if (number == 3)
                        if ((y < borderU + width) ||
                            (x > borderR - width) ||
                            (y > centerY - width/2 && y < centerY + width/2) ||
                            (y > borderD - width)) 
                                rgb = 12'hFFF; 
                    
                    if (number == 4)
                        if ((x < borderL + width && y < centerY) ||
                            (x > borderR - width) ||
                            (y > centerY - width/2 && y < centerY + width/2))
                                rgb = 12'hFFF;
                    
                    if (number == 5) 
                        if ((y < borderU + width) || 
                           (x > borderR - width && y > centerY) ||
                           (y > centerY - width/2 && y < centerY + width/2) ||
                           (x < borderL + width && y < centerY) ||
                           (y > borderD - width)) 
                                rgb = 12'hFFF;
                                
                    if (number == 6)
                        if ((y < borderU + width) || 
                           (x > borderR - width && y > centerY) ||
                           (y > centerY - width/2 && y < centerY + width/2) ||
                           (x < borderL + width) ||
                           (y > borderD - width)) 
                                rgb = 12'hFFF;
                                
                    if (number == 7)
                        if ((y < borderU + width) ||
                            (x > borderR - width))
                                rgb = 12'hFFF; 
                                
                    if (number == 8)
                        if ((y < borderU + width) ||
                            (x < borderL + width) ||
                            (y > centerY - width/2 && y < centerY + width/2) ||
                            (x > borderR - width) ||
                            (y > borderD - width))
                                rgb = 12'hFFF;
                    
                    if (number == 9)
                        if ((x < borderL + width && y < centerY) ||
                            (y < borderU + width) ||
                            (x > borderR - width) ||
                            (y > centerY - width/2 && y < centerY + width/2))
                                rgb = 12'hFFF;                     
                 end    
            end
                
            2: begin
                if (number > 0)
                    rgb = 12'hFFF;
                if (p_row == row && p_col == col)
                    if ((x < col * xMax + width) ||
                        (x > (col+1) * xMax - width) ||
                        (y < row * yMax + width) ||
                        (y > (row + 1) * yMax - width))
                            rgb = 12'hF00;
            end
               
            3: begin
                rgb = 12'h0F0;
            end
            4: begin
                rgb = 12'h000;
            end
         endcase
    end

endmodule
