module vga_test
    (
        input wire clk, reset,
        output wire hsync, vsync,
        output wire [11:0] rgb
    );

    // Parameters for grid dimensions
    localparam GRID_SIZE_X = 213; // 640 / 3 (approx)
    localparam GRID_SIZE_Y = 160; // 480 / 3 (approx)

    // Wires for VGA sync signals
    wire [9:0] x, y;
    wire video_on;

    // Instantiate vga_sync module
    vga_sync vga_sync_unit (
        .clk(clk), 
        .reset(reset), 
        .hsync(hsync), 
        .vsync(vsync),
        .video_on(video_on), 
        .p_tick(), 
        .x(x), 
        .y(y)
    );

    // Register for RGB output
    reg [11:0] rgb_reg;

    // Determine the current grid cell
    wire [1:0] grid_x = x / GRID_SIZE_X;
    wire [1:0] grid_y = y / GRID_SIZE_Y;

    // Assign colors to grid cells (one cell is different)
    always @* begin
        if (grid_x == 1 && grid_y == 1) begin
            // The unique square (center)
            rgb_reg = 12'hF00; // Red
        end else if ((grid_x + grid_y) % 2 == 0) begin
            // Checkerboard pattern
            rgb_reg = 12'h0F0; // Green
        end else begin
            rgb_reg = 12'h00F; // Blue
        end
    end

    // Output RGB signal only when video is on
    assign rgb = (video_on) ? rgb_reg : 12'b0;

endmodule

