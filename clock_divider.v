`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 07:12:33 PM
// Design Name: 
// Module Name: clock_divider
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

module clock_divider(
    //Output
    clk_multiplex,
    //Input
    clk
    );
    
input clk;

output clk_multiplex;

reg clk_multiplex_reg;
reg [16:0] clk_multiplex_dv;

always @ (posedge clk) begin
    clk_multiplex_dv <= 17'b0;
    clk_multiplex_reg <= 1'b0;
    if (clk_multiplex_dv == 99999) begin
        clk_multiplex_dv <= 0;
        clk_multiplex_reg <= ~clk_multiplex;
    end else begin
        clk_multiplex_dv <= clk_multiplex_dv + 1;
        clk_multiplex_reg <= clk_multiplex;
    end
end

assign clk_multiplex = clk_multiplex_reg;

endmodule

