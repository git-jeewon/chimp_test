module vga_test
    (
        input clk, rst, left, right, up, down, sel,
        output hsync, vsync,
        output [11:0] rgb
    );
    
    wire db_left;
    wire db_right;
    wire db_up;
    wire db_down;
    
    debouncer left_db(.clk(clk), .button(left), .button_state(db_left));
    debouncer right_db(.clk(clk), .button(right), .button_state(db_right));
    debouncer up_db(.clk(clk), .button(up), .button_state(db_up));
    debouncer down_db(.clk(clk), .button(down), .button_state(db_down));
    debouncer sel_db(.clk(clk), .button(sel), .button_state(db_sel));

    // Parameters for grid dimensions
    localparam GRID_SIZE_X = 213; // 640 / 3 (approx)
    localparam GRID_SIZE_Y = 160; // 480 / 3 (approx)

    // Wires for VGA sync signals
    wire [9:0] x, y;
    wire video_on;

    // Instantiate vga_sync module
    vga_sync vga_sync_unit (
        .clk(clk),  
        .rst(rst),
        .hsync(hsync), 
        .vsync(vsync),
        .video_on(video_on), 
        .p_tick(), 
        .x(x), 
        .y(y)
    );
    
    wire [11:0] rgb_easy;
    
    easy_update easy (
        .clk(clk),
        .rst(rst),
//        .num_numbers(5),
        .x(x),
        .y(y),
        .rgb(rgb_easy),
        .left(db_left),
        .right(db_right),
        .up(db_up),
        .down(db_down),
        .sel(db_sel)
        
    );
    // Register for RGB output
    reg [11:0] rgb_reg;

    // Determine the current grid cell
    wire [1:0] grid_x = x / GRID_SIZE_X;
    wire [1:0] grid_y = y / GRID_SIZE_Y;

    // Assign colors to grid cells (one cell is different)
    always @* begin
//        if (grid_x == 1 && grid_y == 1) begin
//            // The unique square (center)
//            rgb_reg = 12'hF00; // Red
//        end else if ((grid_x + grid_y) % 2 == 0) begin
//            // Checkerboard pattern
//            rgb_reg = 12'h0F0; // Green
//        end else begin
//            rgb_reg = 12'h00F; // Blue
//        end
        rgb_reg <= rgb_easy;
        
    end

    // Output RGB signal only when video is on
    assign rgb = (video_on) ? rgb_reg : 12'b0;

endmodule

