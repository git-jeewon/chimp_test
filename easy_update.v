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
    output [11:0] rgb, output [6:0] cathode, output [3:0] anode,
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
    
    
//    always @(*) begin
//        grid[0][0] = 4;
//        grid[0][1] = 5;
//        grid[0][2] = 6;
//        grid[1][0] = 1;
//        grid[1][1] = 2;
//        grid[1][2] = 3;
//        grid[2][0] = 7;
//        grid[2][1] = 8;
//        grid[2][2] = 9;
//    end
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
   
    parameter game_generate = 3'b000;
    parameter game_visible = 3'b001;
    parameter game_hidden = 3'b010;
    parameter game_won = 3'b011;
    parameter game_lost = 3'b100;
    
    reg [3:0] score, score_next;
    reg [3:0] lives, lives_next;
    reg [2:0] state_reg;
    reg [2:0] state_d;
    reg [2:0] state_next;
    
    reg [3:0] target_num, target_next;
    
    reg [3:0] grid [0:2][0:2], grid_next [0:2][0:2];
   
    reg [3:0] largest_num, largest_num_next;
    reg [3:0] curr_num, curr_num_next;
    reg [3:0] available_indices[0:8], available_indices_next[0:8];
    reg [3:0] num_available, num_available_next;
    integer i, j;
    integer randidx;
    
    reg [11:0] rgb_reg;
    
    wire [3:0] rand_value;
    
    lfsr random_gen(.clk(clk), .rst(rst), .bound(num_available), .rnd(rand_value));
    
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
    
        
    display_number display00(.clk(clk), .number(grid[0][0]), .row(0), .col(0), .p_row(p_row), .p_col(p_col), .x(x), .y(y), .state(state_d), .rgb(rgb00));
    display_number display01(.clk(clk), .number(grid[0][1]), .row(0), .col(1), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d), .rgb(rgb01));
    display_number display02(.clk(clk), .number(grid[0][2]), .row(0), .col(2), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d), .rgb(rgb02));
    display_number display10(.clk(clk), .number(grid[1][0]), .row(1), .col(0), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d), .rgb(rgb10));
    display_number display11(.clk(clk), .number(grid[1][1]), .row(1), .col(1), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d), .rgb(rgb11));
    display_number display12(.clk(clk), .number(grid[1][2]), .row(1), .col(2), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d),.rgb(rgb12));
    display_number display20(.clk(clk), .number(grid[2][0]), .row(2), .col(0), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d),.rgb(rgb20));
    display_number display21(.clk(clk), .number(grid[2][1]), .row(2), .col(1), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d),.rgb(rgb21));
    display_number display22(.clk(clk), .number(grid[2][2]), .row(2), .col(2), .p_row(p_row), .p_col(p_col),.x(x), .y(y), .state(state_d),.rgb(rgb22));
    
    
    wire clk_multiplex;

    clock_divider clock_dv(.clk(clk), .clk_multiplex(clk_multiplex));


    wire [6:0] cathode_lives;
    wire [6:0] cathode_score;
    
    cathode_display lives_cathode_(.digit(lives), .cathode(cathode_lives));
    cathode_display score_cathode_(.digit(score), .cathode(cathode_score));
    
    multiplex_display display(.clk_multiplex(clk_multiplex), .lives_cathode(cathode_lives), .score_cathode(cathode_score), .cathode(cathode), .anode(anode));
    
    
    
    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            score <= 5;
            lives <= 3;
            state_reg <= game_generate;
            state_d <= game_generate;
            target_num <= 1;
            
            grid[0][0] <= 0;
            grid[0][1] <= 0;
            grid[0][2] <= 0;
            grid[1][0] <= 0;
            grid[1][1] <= 0;
            grid[1][2] <= 0;
            grid[2][0] <= 0;
            grid[2][1] <= 0;
            grid[2][2] <= 0;
            
            largest_num <= 5;
            curr_num <= 1;
            
            available_indices[0] <= 0;
            available_indices[1] <= 1;
            available_indices[2] <= 2;
            available_indices[3] <= 3;
            available_indices[4] <= 4;
            available_indices[5] <= 5;
            available_indices[6] <= 6;
            available_indices[7] <= 7;
            available_indices[8] <= 8;
            
            num_available <= 9;
        end
        else begin
            score <= score_next;
            lives <= lives_next;
            state_reg <= state_next;
            state_d <= state_reg;
            target_num <= target_next;
            
            grid[0][0] <= grid_next[0][0];
            grid[0][1] <= grid_next[0][1];
            grid[0][2] <= grid_next[0][2];
            grid[1][0] <= grid_next[1][0];
            grid[1][1] <= grid_next[1][1];
            grid[1][2] <= grid_next[1][2];
            grid[2][0] <= grid_next[2][0];
            grid[2][1] <= grid_next[2][1];
            grid[2][2] <= grid_next[2][2];
            
            largest_num <= largest_num_next;
            curr_num <= curr_num_next;
            
            available_indices[0] <= available_indices_next[0];
            available_indices[1] <= available_indices_next[1];
            available_indices[2] <= available_indices_next[2];
            available_indices[3] <= available_indices_next[3];
            available_indices[4] <= available_indices_next[4];
            available_indices[5] <= available_indices_next[5];
            available_indices[6] <= available_indices_next[6];
            available_indices[7] <= available_indices_next[7];
            available_indices[8] <= available_indices_next[8];
            
            
            num_available <= num_available_next;
            
           
//            if (state_reg == game_visible || state_reg == game_hidden) begin
//                if (sel_edge && grid[p_row][p_col] == target_num) begin
//                    grid[p_row][p_col] <= 0; // Set the grid cell to 0 when the target number is matched
//                end
        //end
        end
    end
    
    
    always @ (*) begin
        score_next = score;
        lives_next = lives;
        state_next = state_reg;
        target_next = target_num;
        
        grid_next[0][0] = grid[0][0];
        grid_next[0][1] = grid[0][1];
        grid_next[0][2] = grid[0][2];
        grid_next[1][0] = grid[1][0];
        grid_next[1][1] = grid[1][1];
        grid_next[1][2] = grid[1][2];
        grid_next[2][0] = grid[2][0];
        grid_next[2][1] = grid[2][1];
        grid_next[2][2] = grid[2][2];
        
        largest_num_next = largest_num;
        curr_num_next = curr_num;
       
        available_indices_next[0] = available_indices[0];
        available_indices_next[1] = available_indices[1];
        available_indices_next[2] = available_indices[2];
        available_indices_next[3] = available_indices[3];
        available_indices_next[4] = available_indices[4];
        available_indices_next[5] = available_indices[5];
        available_indices_next[6] = available_indices[6];
        available_indices_next[7] = available_indices[7];
        available_indices_next[8] = available_indices[8];
            
        num_available_next = num_available;
        
        case (state_reg)
            game_generate: begin
//                if (curr_num <= largest_num) begin
//                    randidx = rand_value;
//                    case (available_indices[randidx])
//                        0: grid_next[0][0] = curr_num;
//                        1: grid_next[0][1] = curr_num;
//                        2: grid_next[0][2] = curr_num;
//                        3: grid_next[1][0] = curr_num;
//                        4: grid_next[1][1] = curr_num;
//                        5: grid_next[1][2] = curr_num;
//                        6: grid_next[2][0] = curr_num;
//                        7: grid_next[2][1] = curr_num;
//                        8: grid_next[2][2] = curr_num;
//                    endcase
                    
//                    for (j = randidx; j < 9; j = j + 1) begin
//                        available_indices_next[j] = available_indices_next[j + 1];
//                    end
                    
//                    num_available_next = num_available - 1;
//                    curr_num_next = curr_num + 1;
                //end     
               // else 
                if (largest_num == 5) begin
                   grid_next[0][0] = 5;
                   grid_next[0][1] = 0;
                   grid_next[0][2] = 1;
                   grid_next[1][0] = 2;
                   grid_next[1][1] = 3;
                   grid_next[1][2] = 0;
                   grid_next[2][0] = 4;
                   grid_next[2][1] = 0;
                   grid_next[2][2] = 0;
                   
                end    
                else if (largest_num == 6) begin
                   grid_next[0][0] = 6;
                   grid_next[0][1] = 0;
                   grid_next[0][2] = 2;
                   grid_next[1][0] = 0;
                   grid_next[1][1] = 1;
                   grid_next[1][2] = 0;
                   grid_next[2][0] = 4;
                   grid_next[2][1] = 5;
                   grid_next[2][2] = 3;
                end
                else if (largest_num == 7) begin
                   grid_next[0][0] = 7;
                   grid_next[0][1] = 0;
                   grid_next[0][2] = 2;
                   grid_next[1][0] = 0;
                   grid_next[1][1] = 6;
                   grid_next[1][2] = 3;
                   grid_next[2][0] = 4;
                   grid_next[2][1] = 1;
                   grid_next[2][2] = 5;
                end
                else if (largest_num == 8) begin
                   grid_next[0][0] = 7;
                   grid_next[0][1] = 4;
                   grid_next[0][2] = 0;
                   grid_next[1][0] = 1;
                   grid_next[1][1] = 8;
                   grid_next[1][2] = 5;
                   grid_next[2][0] = 3;
                   grid_next[2][1] = 6;
                   grid_next[2][2] = 2;
                end
                else if (largest_num == 9) begin
                   grid_next[0][0] = 4;
                   grid_next[0][1] = 6;
                   grid_next[0][2] = 1;
                   grid_next[1][0] = 9;
                   grid_next[1][1] = 2;
                   grid_next[1][2] = 8;
                   grid_next[2][0] = 7;
                   grid_next[2][1] = 5;
                   grid_next[2][2] = 3;
                end
                state_next = game_visible;
                //end
            end
            game_visible: begin
                if(sel_edge && grid[p_row][p_col] == target_num) begin                    
                    state_next = game_hidden;
                    target_next = target_next + 1;
                    grid_next[p_row][p_col] = 0;
                    
                end
                else if (sel_edge && grid[p_row][p_col] != target_num && grid[p_row][p_col] > 0)
                    lives_next = lives - 1;
                    
            end
            game_hidden: begin
                if(sel_edge && grid[p_row][p_col] == target_num) begin
                    if (target_num == largest_num) begin
                        if (target_num == 9)
                            state_next = game_won;
                        else begin
                            largest_num_next = largest_num + 1;
                            if (score < largest_num_next) 
                                score_next = largest_num_next;
                            state_next = game_generate;
                            target_next = 1;
                        end
                    end
                    else begin
                        target_next = target_next + 1;
                        grid_next[p_row][p_col] = 0;
                    end
                end
                else if (sel_edge && grid[p_row][p_col] != target_num && grid[p_row][p_col] > 0)
                    lives_next = lives - 1;
                    
            end
            
            game_won: begin
                if (sel_edge) begin
                    score_next = 5;
                    lives_next = 3;
                    largest_num_next = 5;
                    state_next = game_generate;
                    target_next = 1;        
                end
            end
            game_lost: begin
                if (sel_edge) begin
                    score_next = 5;
                    lives_next = 3;
                    largest_num_next = 5;
                    state_next = game_generate;
                    target_next = 1;
                end
            end
        endcase
        
        if (lives_next == 0)
                state_next = game_lost;
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

