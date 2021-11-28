`default_nettype none
module SolutionParser(
    input wire [7:0]  num_rows,
    input wire [7:0] num_col,
    input wire done,
    input wire sol_vals,
    input wire clk_in,
    input wire reset,
    input wire hcount,
    input wire vcount,
    output logic displaying,
    output logic pixel_out,
    output logic [10:0][10:0] vals //stores 1 for white, black for zero,

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
    always_ff @(posedge clk_in) begin
        
        if (reset) begin
            row_addr <= 8'd0;
            col_addr <= 8'd0;
            receiving <= 0;
            size <= 10'd103; //way oversize this, leave enough such that we dont get 0 if 200x200, instead get the max size of 3 for a 200x200
            displaying <= 1'b0;
        end else if (done) begin
            receiving <= 1'b1;
        end else if (receiving & !displaying) begin //we now begin building up our gridarray
            if (col_addr == num_col & row_addr == num_rows) begin
                vals[row_addr][col_addr] <= ~sol_vals; //invert values so we can multiply our pixel value by our current location to return correct pixelat
                displaying <= 1'b1;
                row_addr <= 8'd0;
                col_addr <= 8'd0;
            end else if(col_addr == num_col) begin
                vals[row_addr][col_addr] <= ~sol_vals;
                col_addr <= 8'd0; //reset count at end of row
                row_addr <= row_addr + 8'd1;
            end else begin
                vals[row_addr][col_addr] <= ~sol_vals;
            end
        end else if (displaying) begin
            //note to self need to have this registered so it changes on the clock, or just port out the data to the display module and have it clock itself
            //we offset the display of our nonogram by 16*10 in both directions to accomodate our numbers
            if(hcount > 160 & vcount > 160) begin 
                if(
            end
        end
    end

endmodule

`default_nettype wire