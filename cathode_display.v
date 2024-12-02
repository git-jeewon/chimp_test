`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/01/2024 07:15:30 PM
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


module cathode_display(
    //Output
    cathode,
    //Input
    digit
    );
    
    input wire [3:0] digit;
    output wire [6:0] cathode;
    
    reg [6:0] cathode_reg;
    
    always @(*)
        begin
            case(digit)
            0: cathode_reg = 7'b0000001; // "0"     
            1: cathode_reg = 7'b1001111; // "1" 
            2: cathode_reg = 7'b0010010; // "2" 
            3: cathode_reg = 7'b0000110; // "3" 
            4: cathode_reg = 7'b1001100; // "4" 
            5: cathode_reg = 7'b0100100; // "5" 
            6: cathode_reg = 7'b0100000; // "6" 
            7: cathode_reg = 7'b0001111; // "7" 
            8: cathode_reg = 7'b0000000; // "8"     
            9: cathode_reg = 7'b0000100; // "9" 
            default: cathode_reg = 7'b0000001; // "0"
            endcase
        end
   assign cathode = cathode_reg;
endmodule

