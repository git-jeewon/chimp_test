`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2024 01:26:47 PM
// Design Name: 
// Module Name: seven_segment_display
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


module multiplex_display(
    input clk_multiplex,
    input [6:0] first_cathode,
    input [6:0] second_cathode,
    input [6:0] third_cathode,
    input [6:0] fourth_cathode,
    output wire [3:0] anode,
    output wire [6:0] cathode
    );
    
    reg [3:0] anode_reg;
    reg [6:0] cathode_reg;
    reg [1:0] LED_activating_counter = 2'b0; 
   
    always @(posedge clk_multiplex)
    begin
        if (LED_activating_counter == 3) 
            LED_activating_counter <= 2'b0;
        else 
            LED_activating_counter <= LED_activating_counter + 1;
    end 
    
    always @(LED_activating_counter)
    begin
        case(LED_activating_counter)
        2'b00: begin
            anode_reg <= 4'b0111; 
            cathode_reg = first_cathode;
            end
        2'b01: begin
            anode_reg <= 4'b1011; 
            cathode_reg = second_cathode;
            end
        2'b10: begin
            anode_reg <= 4'b1101; 
            cathode_reg = third_cathode;
            end
        2'b11: begin
            anode_reg <= 4'b1110; 
            cathode_reg = fourth_cathode;
            end
        endcase
    end
   
   assign anode = anode_reg;
   assign cathode = cathode_reg;
   
 endmodule