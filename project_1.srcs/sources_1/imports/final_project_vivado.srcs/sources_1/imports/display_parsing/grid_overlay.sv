`default_nettype none
module overlay(input wire clock,
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
top_bar top(.clock(clock), .reset(reset), .start(start), .hcount(hcount), .vcount(vcount), .top_vals(top_vals), .pixel_out(top_pixels));     

left_bar left(.clock(clock), .reset(reset), .start(start), .hcount(hcount), .vcount(vcount), .left_vals(left_vals), .pixel_out (left_pixels));

assign grid_pixels = (hcount > 160 | vcount > 160) ? (hcount % 16 ==0) | (vcount % 16 ==0) ? 12'h000 : 12'hfff : 12'h000;

assign pixel_out = grid_pixels == 12'h000 | top_pixels == 12'h000 | left_pixels == 12'h000 ? 12'h000 : 12'hfff;
 
endmodule

`default_nettype wire
