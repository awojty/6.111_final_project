`default_nettype none
module left_bar(input wire clock,
               input wire reset,
               input wire pixel_clock, 
               input wire [12:0] hcount, 
               input wire [12:0] vcount,
               input wire start, //starts the intake process of values from our 
               input wire [7:0] values,
               output logic pixel_out);
parameter OFFSET = 160;
logic [9:0] address_x;
logic [9:0] address_y;
logic [3:0] num_val;
logic [4:0] upper_x;
logic [4:0] lower_x;

//xy locations for each image blob
logic [12:0] x_in;
logic [12:0] y_in;
//pixels from different sources
logic [11:0] pixel_0;
logic [11:0] pixel_1;
logic [11:0] pixel_2;
logic [11:0] pixel_3;
logic [11:0] pixel_4;
logic [11:0] pixel_5;
logic [11:0] pixel_6;
logic [11:0] pixel_7;
logic [11:0] pixel_8;
logic [11:0] pixel_9;
logic [11:0] empty;
//register to store the number values

//need to have a setup of all of the x,y ins for each blob instance 
reg [19:0][39:0] left_vals; 


logic [4:0] col_addr;
logic [6:0] row_addr;
logic filling; //keeps track if we are filling in the register yet
always_ff @(posedge clock) begin
    if (reset) begin
        col_addr <= 5'd0;
        row_addr <= 5'd0;
    end else if (start) begin
        filling <= 1;
    end else if (filling & col_addr > 19 & row_addr==39) begin
        filling <= 0;
    end else if (filling & col_addr > 19) begin
        row_addr <= row_addr + 8;
        col_addr <= 0; 
        left_vals[col_addr][row_addr +:7] <= values;
    end else if (filling) begin
        left_vals[col_addr][row_addr +:7] <= values;
        col_addr <= col_addr +1;
    end 
end
//assign our number value based on our referenced address 
assign   address_x = (hcount - OFFSET) >> 4;
assign  address_y = (vcount) >> 4;  
assign upper_x = address_x<<2;
assign num_val = left_vals[address_y][upper_x +: 3];
assign empty = 12'h000;

assign x_in = address_x << 4;
assign y_in = address_y << 4;                     
assign pixel_out = num_val==4'd0 ? pixel_0 : num_val==4'd1 ? pixel_1 : num_val==4'd2 ? 
                   pixel_2 : num_val==4'd3 ? pixel_3 : num_val==4'd4 ? pixel_4 :
                   num_val==4'd5 ? pixel_5 : num_val==4'd6 ? pixel_6 : num_val==4'd7 ?
                   pixel_7 : num_val==4'd8 ? pixel_8 : num_val==4'd9 ? pixel_9 : empty;                       


ones_pixels #(.WIDTH(16), .HEIGHT(16)) one(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));
twos_pixels #(.WIDTH(16), .HEIGHT(16)) two(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));
threes_pixels #(.WIDTH(16), .HEIGHT(16)) three(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));
fours_pixels #(.WIDTH(16), .HEIGHT(16)) four(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));
fives_pixels #(.WIDTH(16), .HEIGHT(16)) five(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));
sixes_pixels #(.WIDTH(16), .HEIGHT(16)) six(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));
sevens_pixels #(.WIDTH(16), .HEIGHT(16)) seven(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));
eights_pixels #(.WIDTH(16), .HEIGHT(16)) eight(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));
nines_pixels #(.WIDTH(16), .HEIGHT(16)) nine(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));

//assign none when not in desired region of screen
assign pixel_out = ( hcount < OFFSET + 1 & vcount > OFFSET & vcount < OFFSET + 16*20) ? pixel_out : 12'h000;    
endmodule

//returns index into register of values for our top grid, using this index we get what value to display,
//using our known sizes, we can use our index to get the offsets to feed into our image blob

`default_nettype wire