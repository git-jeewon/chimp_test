`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 05:01:47 PM
// Design Name: 
// Module Name: cathode_display
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


module score_display(
    anode, cathode, 
    clk,
    );

    input clk;
    output [3:0] anode;
    output [6:0] cathode;

    wire clk_multiplex;

    clock_divider clock_dv(.clk(clk), .clk_multiplex(clk_multiplex));

    wire [6:0] first_cathode;
    wire [6:0] second_cathode;
    wire [6:0] third_cathode;
    wire [6:0] fourth_cathode;    

    cathode_display c_min1(.digit(0), .cathode(first_cathode));
    cathode_display c_min0(.digit(0), .cathode(second_cathode));
    cathode_display c_sec1(.digit(0), .cathode(third_cathode));
    cathode_display c_sec0(.digit(3), .cathode(fourth_cathode));

    multiplex_display display(.clk_multiplex(clk_multiplex), .first_cathode(first_cathode), .second_cathode(second_cathode), .third_cathode(third_cathode), .fourth_cathode(fourth_cathode), .anode(anode), .cathode(cathode));

endmodule