`default_nettype none
module SolutionParser(
    input wire done,
    input wire sol_vals,
    input wire clk_in,
    input wire pixel_clock,
    input wire reset,
    input wire [12:0] hcount,
    input wire [12:0] vcount,
    input wire left_vals,
    input wire top_vals,
    output logic [11:0] pixel_out


);
    logic [9:0] size; //number of pixels along a side for one tile
    logic receiving; //1 while receiving data, 0 otherwise
    logic [7:0] row_addr;
    logic [7:0] col_addr;
    logic sized; //switches to 1 when sizing compete
    logic [9:0] index_x;
    logic [9:0] index_y;
    logic [12:0] hcount_old;
    logic [12:0] vcount_old;
    logic [9:0] address_x;
    logic [9:0] address_y;
    logic [11:0] pixel_squares;
    logic [11:0] pixel_overlay;
    logic displaying;


    logic [0:9] vals [0:9]= {10'b1001110101,10'b1110011000,10'b1010101010,10'b1111100000,10'b1100110011,
                               10'b0101010101,10'b1111111111,10'b1000000001,10'b1000100000,10'b1110001100};         

    
    assign   address_x = (hcount - 160) >> 4;  
    assign  address_y = (vcount-160) >> 4;  
    assign pixel_squares = (hcount > 160 & vcount > 160 & hcount < 320 & vcount < 320) ? vals[address_x][address_y] ? 12'h000 : 12'hfff : 12'hfff;
    
    
    overlay over(.clock(clk_in), .pixel_clock(pixel_clock),.reset(reset), .hcount(hcount), .vcount(vcount), .start(done), .top_vals(top_vals), .left_vals(left_vals), .pixel_out(pixel_overlay));
    assign pixel_out = ~( ~pixel_squares + ~pixel_overlay);//pixel_squares == 12'h000 ? 12'h000 : pixel_overlay == 12'h000 ? 12'h000 : 12'hfff;  
   
    always_ff @(posedge clk_in) begin
        
        if (reset) begin
            row_addr <= 8'd0;
            col_addr <= 8'd0;
            receiving <= 0;
            size <= 10'd103; //way oversize this, leave enough such that we dont get 0 if 200x200, instead get the max size of 3 for a 200x200
        end else if (done) begin
            receiving <= 1'b1;
        end else if (receiving & !displaying) begin //we now begin building up our gridarray
            if (col_addr == 10 & row_addr == 10) begin
                //vals[row_addr][col_addr] <= sol_vals; 
                displaying <= 1'b1;
                row_addr <= 8'd0;
                col_addr <= 8'd0;
            end else if(col_addr == 10) begin
                //vals[row_addr][col_addr] <= sol_vals;
                col_addr <= 8'd0; //reset count at end of row
                row_addr <= row_addr + 8'd1;
            end else begin
                //vals[row_addr][col_addr] <= sol_vals;
            end
        end else begin
            //note to self need to have this registered so it changes on the clock, or just port out the data to the display module and have it clock itself
            //we offset the display of our nonogram by 16*10 in both directions to accomodate our numbers
            //pixel_out <= pixel_squares == 12'h000 ? 12'h000 : pixel_overlay == 12'h000 ? 12'h000 : 12'hfff;
        end
    end

endmodule

`default_nettype wire