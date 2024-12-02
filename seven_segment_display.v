`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 07:14:24 PM
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
    input [6:0] lives_cathode, [6:0] score_cathode,
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
        if (LED_activating_counter == 0) begin
            anode_reg <= 4'b0111; 
            cathode_reg = score_cathode;
        end
        else if (LED_activating_counter == 3) begin
            anode_reg <= 4'b1110; 
            cathode_reg = lives_cathode;
        end
  
    end
   
   assign anode = anode_reg;
   assign cathode = cathode_reg;
   
 endmodule

