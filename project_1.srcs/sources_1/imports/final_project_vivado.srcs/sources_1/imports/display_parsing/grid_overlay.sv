`default_nettype none
module overlay(input wire clock,
               input wire pixel_clock,
               input wire reset,
               input wire [12:0] hcount,
               input wire [12:0] vcount,
               input wire start,
               input wire top_vals,
               input wire left_vals,
               output logic [11:0]pixel_out

);

logic [11:0] top_pixels;
logic [11:0] left_pixels;
logic [11:0] grid_pixels;
top_bar top(.clock(clock), .reset(reset), .start(start), .hcount(hcount), .vcount(vcount), .top_values(top_vals), .pixel_out(top_pixels));     

left_bar left(.clock(clock), .reset(reset), .start(start), .hcount(hcount), .vcount(vcount), .left_values(left_vals), .pixel_out (left_pixels));

assign grid_pixels = (hcount > 160 | vcount > 160) ? ((hcount % 16 ==0) | (vcount % 16 ==0)) ? 12'h000 : 12'hfff : 12'h000;

logic [11:0] pixel_test;
logic [9:0] address_x;
logic [9:0] address_y;
logic [12:0] x_in;
logic [12:0] y_in;
assign   address_x = (hcount) >> 4;
assign  address_y = (vcount) >> 4;  
assign x_in = address_x << 4;
assign y_in = address_y << 4;   
ones_pixels #(.WIDTH(16), .HEIGHT(16)) one(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_test));
    
assign pixel_out = ~( ~top_pixels + ~grid_pixels);//grid_pixels == 12'h000 | top_pixels == 12'h000 | left_pixels == 12'h000 ? 12'h000 : 12'hfff;
 
endmodule

`default_nettype wire
