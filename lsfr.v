`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2024 04:20:24 PM
// Design Name: 
// Module Name: lsfr
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


module lfsr (
    input clk, 
    input rst, 
    input [3:0] bound,
    output [3:0] rnd
);

    reg [12:0] random, random_next;
    reg [3:0] count, count_next; // to keep track of the shifts
    reg [12:0] random_done; // Hold the final result after 4 shifts
    
    wire feedback = random[12] ^ random[3] ^ random[2] ^  random[0];  // Feedback using MSB and LSB

    // Sequential block for updating random and count
    always @(posedge clk or posedge rst) begin
    
        if (rst) begin
            
            random <= 13'hF;  // Reset to non-zero state (0xF)
            count <= 0;      // Reset shift counter
            random_done <= 13'hF; // Initial random_done value
        end else begin
            random <= random_next; // Update random value
            count <= count_next;   // Update shift counter
        end
    end

    // Combinational block to determine next random value and counter
    always @(*) begin
        random_next = random;  // Default: random stays the same
        count_next = count;    // Default: count stays the same

        // Shift the random register and apply feedback
        random_next = {random[11:0], feedback};

        // Increment counter
        count_next = count + 1;

        // After 4 shifts, store the random number in random_done
        if (count == 13) begin
            random_done = random_next;
            count_next = 0;  // Reset count after 4 shifts
        end
    end

    // Assign the random number modulo 'bound' to the output
    assign rnd = random_done - (random_done/bound) * bound;
    
endmodule
    

//module lfsr (
//    input clk,          // Clock signal
//    input rst,        // Reset signal
//    input [3:0] bound,
//    output reg [3:0] rnd // 4-bit random number output
//);

//    // Internal register for the 4-bit LFSR state
//    reg [3:0] lfsr_state;
//    reg [3:0] random_number;

//    // Feedback polynomial for a 4-bit LFSR: x^4 + x + 1 (feedback = state[3] ^ state[0])
//    wire feedback = lfsr_state[3] ^ lfsr_state[0];

//    // Initialize or update LFSR state
//    always @(posedge clk or posedge reset) begin
//        if (rst) begin
//            lfsr_state <= 4'b1111; // Initialize with a non-zero seed (you can choose a different value)
//        end else begin
//            lfsr_state <= {lfsr_state[2:0], feedback}; // Shift left and insert feedback bit
//        end
//    end

//    // Output the current LFSR state as the random number
//    always @(posedge clk) begin
//        random_number <= lfsr_state;
//    end
    
//    assign rnd = random_number % bound
    

//endmodule



