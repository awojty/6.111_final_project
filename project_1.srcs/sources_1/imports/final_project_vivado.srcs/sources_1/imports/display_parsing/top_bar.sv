`default_nettype none
module top_bar( input wire pixel_clock,
                input wire clock,
                input wire reset,
                input wire start, 
                input wire top_values,
               input wire [12:0] hcount, 
               input wire [12:0] vcount,
               output logic [11:0] pixel_out);
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
 
reg [39:0] top_vals [19:0]  = {40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011,
                               40'b0000_0000_0000_0000_0000_0000_0001_0010_0111_0011};

logic [4:0] row_addr;
logic [6:0] col_addr;
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
        row_addr <= row_addr + 1;
        col_addr <= 0; 
        top_vals[col_addr][row_addr] <= top_values;
    end else if (filling) begin
        top_vals[col_addr][row_addr] <= top_values;
        col_addr <= col_addr +1;
    end 
end
//assign our number value based on our referenced address 
assign   address_x = (hcount - OFFSET) >> 4;
assign  address_y = (vcount) >> 4;  
assign upper_x = address_x<<2;
assign num_val = top_vals[address_y][upper_x +: 3];
assign empty = 12'hfff;

assign x_in = address_x << 4;
assign y_in = address_y << 4;                     
assign pixel_out =  num_val == 1 ? 12'h000 : 12'hfff;                       


ones_pixels #(.WIDTH(16), .HEIGHT(16)) one(.pixel_clk_in(pixel_clock), .x_in(0), .y_in(0), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_1));
twos_pixels #(.WIDTH(16), .HEIGHT(16)) two(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_2));
threes_pixels #(.WIDTH(16), .HEIGHT(16)) three(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_3));
fours_pixels #(.WIDTH(16), .HEIGHT(16)) four(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_4));
fives_pixels #(.WIDTH(16), .HEIGHT(16)) five(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_5));
sixes_pixels #(.WIDTH(16), .HEIGHT(16)) six(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_6));
sevens_pixels #(.WIDTH(16), .HEIGHT(16)) seven(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_7));
eights_pixels #(.WIDTH(16), .HEIGHT(16)) eight(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_8));
nines_pixels #(.WIDTH(16), .HEIGHT(16)) nine(.pixel_clk_in(pixel_clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_9));

//assign none when not in desired region of screen
//assign pixel_out = (hcount > OFFSET & hcount < OFFSET + 16*20 & vcount < OFFSET + 1) ? pixel_out : 12'h000; 
    
endmodule

//returns index into register of values for our top grid, using this index we get what value to display,
//using our known sizes, we can use our index to get the offsets to feed into our image blob

`default_nettype wire