`default_nettype none
module display_graphics(
input wire clk_in,
input wire reset,
input wire [8:10] assignments_x,
input wire [8:10] assignments_y,
input wire [4:0] dimensions_x,
input wire [4:0] dimensions_y,
input wire [10:0][10:0] grid,
output logic pixel_out);
//each number is 16 pixels wide, so 160 pixels in we start the display of or vertical numbers and the puzzle itself
//to the right we display the current time
endmodule
`default_nettype wire