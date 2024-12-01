`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
 
// Create Date: 11/28/2024 04:13:33 PM
// Design Name: 
// Module Name: easy_update
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
 
// Dependencies: 
 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
 
////////////////////////////////////////////////////////////////////////////////


module easy_update(
    //Output
    output [11:0] rgb,
//    //Input
    input clk, rst, left, right, up, down, sel,
//    input [3:0] num_numbers, 
    input [9:0] x, input [9:0] y
    );
    
    reg sel_d;
    reg sel_edge;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sel_d <= 0;
        end else begin
            sel_d <= sel;
        end
    end

    // Edge detection (detect rising edge)
    always @(posedge clk) begin
        sel_edge <= sel && ~sel_d;
    end
    
    
    reg [3:0] grid [0:2][0:2];
    
    always @(*) begin
        grid[0][0] = 4;
        grid[0][1] = 5;
        grid[0][2] = 6;
        grid[1][0] = 1;
        grid[1][1] = 2;
        grid[1][2] = 3;
        grid[2][0] = 7;
        grid[2][1] = 8;
        grid[2][2] = 9;
    end
//    reg [3:0] available_indices[0:8];
//    reg [3:0] num_available;
//    reg [3:0] curr_num;
    
//    reg [3:0] lfsr;
//    wire feedback = lfsr[3] ^ lfsr[2];
//    reg [3:0] rand_value, random_next, random;
//    reg [2:0] count, count_next;
//    integer i, j;
//    integer a, b;
    
//    always @(*) begin
//        random_next = random;
//        count_next = count;
        
//        random_next = {random[2:0], feedback};
//        count_next = count + 1;
        
//        if (count == 4) begin
//            count = 0;
//            rand_value = random;
//        end
//    end
    
//    always @(*) begin

//        for (i = 0; i < 9; i = i + 1) begin
//            available_indices[i] = i;
//        end
////        for (i = 0; i < 3; i = i + 1) begin
////            for (j = 0; j < 3; j = j + 1) begin
////                grid[i][j] = 0; 
////            end
////        end
       
//        num_available = 9;
//        curr_num = 1;
        
////        lfsr = 8'hFF;
    
//        // Loop until we fill 5 numbers in the grid
//        for (curr_num = 1; curr_num < 5; curr_num = curr_num + 1) begin
//            // Generate a random index from the available indices
////            lfsr = {lfsr[6:0], feedback};
            
////            rand_value = lfsr - (lfsr / num_available) * num_available;
////              rand_value = num_available-1; 
    
//            // Place the current number in the corresponding grid position
//            case (available_indices[rand_value])
//                0: grid[0][0] = curr_num;
//                1: grid[0][1] = curr_num;
//                2: grid[0][2] = curr_num;
//                3: grid[1][0] = curr_num;
//                4: grid[1][1] = curr_num;
//                5: grid[1][2] = curr_num;
//                6: grid[2][0] = curr_num;
//                7: grid[2][1] = curr_num;
//                8: grid[2][2] = curr_num;
//            endcase
    
//            // Remove the selected index by shifting the array
//            for (j = rand_value; j < num_available - 1; j = j + 1) begin
//                available_indices[j] = available_indices[j + 1];
//            end
    
//            // Decrement num_available after removing the selected index
//            num_available = num_available - 1;
    
//        end
//    end
   
    
    parameter game_visible = 2'b00;
    parameter game_hidden = 2'b01;
    parameter game_won = 2'b10;
    parameter game_lost = 2'b11;
    
    reg [1:0] state_reg;
    reg [1:0] state_d;
    reg [1:0] state_next;
    reg [11:0] rgb_reg;
    reg [3:0] target_num, target_next;
    
    wire [1:0] p_row, p_col;
   
    player p(
        .clk(clk), 
        .rst(rst),
        .left(left), 
        .right(right),
        .up(up), 
        .down(down), 
        .row(p_row), 
        .col(p_col)
    );
    
    wire [11:0] rgb00, rgb01, rgb02, rgb10, rgb11, rgb12, rgb20, rgb21, rgb22;
    
    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            state_reg <= game_visible;
            state_d <= game_visible;
            target_num <= 1;
            grid[0][0] <= 4;
            grid[0][1] <= 5;
            grid[0][2] <= 6;
            grid[1][0] <= 1;
            grid[1][1] <= 2;
            grid[1][2] <= 3;
            grid[2][0] <= 7;
            grid[2][1] <= 8;
            grid[2][2] <= 9;
        end
        else begin
            state_reg <= state_next;
            state_d <= state_reg;
            target_num <= target_next;
           
            if (state_reg == game_visible || state_reg == game_hidden) begin
                if (sel_edge && grid[p_row][p_col] == target_num) begin
                    grid[p_row][p_col] <= 0; // Set the grid cell to 0 when the target number is matched
                end
        end
        end
    end
    
    display_number display00(.clk(clk), .number(grid[0][0]), .row(0), .col(0), .p_row(p_row), .p_col(p_col), .x(x), .y(y), .state(state_d), .rgb(rgb00));
    display_number display01(.clk(clk), .number(grid[0][1]), .row(0), .col(1), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d), .rgb(rgb01));
    display_number display02(.clk(clk), .number(grid[0][2]), .row(0), .col(2), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d), .rgb(rgb02));
    display_number display10(.clk(clk), .number(grid[1][0]), .row(1), .col(0), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d), .rgb(rgb10));
    display_number display11(.clk(clk), .number(grid[1][1]), .row(1), .col(1), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d), .rgb(rgb11));
    display_number display12(.clk(clk), .number(grid[1][2]), .row(1), .col(2), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d),.rgb(rgb12));
    display_number display20(.clk(clk), .number(grid[2][0]), .row(2), .col(0), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d),.rgb(rgb20));
    display_number display21(.clk(clk), .number(grid[2][1]), .row(2), .col(1), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d),.rgb(rgb21));
    display_number display22(.clk(clk), .number(grid[2][2]), .row(2), .col(2), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d),.rgb(rgb22));
    
    
    always @ (*) begin
        state_next = state_reg;
        target_next = target_num;
        case (state_reg)
            game_visible: begin
                if(sel_edge && grid[p_row][p_col] == target_num) begin
                    state_next = game_hidden;
                    target_next = target_next + 1;
                end
                else if (sel_edge && grid[p_row][p_col] != target_num && grid[p_row][p_col] > 0)
                    state_next = game_lost;
            end
            game_hidden: begin
                if(sel_edge && grid[p_row][p_col] == target_num) begin
                    target_next = target_next + 1;
                    if (target_num == 9)
                        state_next = game_won;
                end
                else if (sel_edge && grid[p_row][p_col] != target_num && grid[p_row][p_col] > 0)
                    state_next = game_lost;
            end
////            game_won: begin
            
////                end
        endcase
    end
    

    always @(*) begin

        if (x <= 213 && y <= 160) begin
            rgb_reg = rgb00;
        end
        else if (x > 213 && x <= 427 && y <= 160) begin
            rgb_reg = rgb01;
        end
        
        if (x > 427 && x <= 640 && y <= 160) begin
            rgb_reg = rgb02;
        end
        
        if (x <= 213 && y > 160 && y <= 320) begin  
            rgb_reg = rgb10;
            
        end
        
        if (x > 213 && x <= 427 && y > 160 && y <= 320) begin
            rgb_reg = rgb11;  
        end
        
        if (x > 427 && x <= 640 && y > 160 && y <= 320) begin
 
            rgb_reg = rgb12;
        end
        
        if (x <= 213 && y > 320 && y <= 480) begin
            rgb_reg = rgb20;
        end
        if (x > 213 && x <= 427 && y > 320 && y <= 480) begin  
            rgb_reg = rgb21;
        end
        
        if (x > 427 && x <= 640 && y > 320 && y <= 480) begin 
            rgb_reg = rgb22;
        end
        
    end
    
    assign rgb = rgb_reg;
endmodule

