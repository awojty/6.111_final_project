`default_nettype none
module solved_disp(
                   input wire clock,
                   input wire reset,
                   input wire done,
                   input wire memory_read_start,
                   input wire [19:0] constraint_vals,
                   input wire [9:0] grid_vals,
                   input wire [12:0] hcount,
                   input wire [12:0] vcount,
                   input wire [15:0] switch,
                   output logic [11:0] pixel_out);
    
    logic done_old; //we use this to keep track of whether or not the done value switches states
    logic receiving; //lets the system know if it is in receiving mode or not              
    logic [3:0] count_grid; //counts from 0-9 to keep track of the indexing with clock cycles for the 10x10 
    logic [4:0] count_num; //counts from 0-19 to keep track of indexing with clock cycles for the 20x20 constraints
    logic [10:0] address_x;
    logic [10:0] address_y;
    logic [10:0] address_x_shift; //coordinates of every 16 pixels, 
    logic [10:0] address_y_shift;
    logic [9:0] x_in; //coordinates upscaled to give display coordinates of image blobs
    logic [9:0] y_in;
    logic [10:0] lower_x; //addressing for registers of values, use [lower +:3] to grab 4 bit val
    logic [10:0] lower_y;
    
    //initialize our different layers of pixels
    logic [11:0] left_pixels;
    logic [11:0] top_pixels;
    logic [11:0] grid_pixels;
    logic [11:0] tile_pixels;
    logic [3:0] top_val;
    logic [3:0] left_val;
    
    //initialize the pixel values of our numbers
    logic [11:0] one_pixels;
    logic [11:0] two_pixels;
    logic [11:0] three_pixels;
    logic [11:0] four_pixels;
    logic [11:0] five_pixels;
    logic [11:0] six_pixels;
    logic [11:0] seven_pixels;
    logic [11:0] eight_pixels;
    logic [11:0] nine_pixels;
    logic [11:0] blank_pixels;
    ones_pixels #(.WIDTH(16), .HEIGHT(16)) one(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(one_pixels));
    twos_pixels #(.WIDTH(16), .HEIGHT(16)) two(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(two_pixels));
    threes_pixels #(.WIDTH(16), .HEIGHT(16)) three(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(three_pixels));
    fours_pixels #(.WIDTH(16), .HEIGHT(16)) four(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(four_pixels));
    fives_pixels #(.WIDTH(16), .HEIGHT(16)) five(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(five_pixels));
    sixes_pixels #(.WIDTH(16), .HEIGHT(16)) six(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(six_pixels));
    sevens_pixels #(.WIDTH(16), .HEIGHT(16)) seven(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(seven_pixels));
    eights_pixels #(.WIDTH(16), .HEIGHT(16)) eight(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(eight_pixels));
    nines_pixels #(.WIDTH(16), .HEIGHT(16)) nine(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(nine_pixels));
    assign blank_pixels = 12'hfff;
    
     //10x10 array to store 1 and 0s of our grid for display
    logic  vals [0:9][0:9]= {'{0,0,0,0,0,0,1,1,1,1},
                             '{0,0,0,1,1,1,0,0,0,1},
                             '{0,0,0,1,0,0,0,1,1,1},
                             '{0,0,0,1,1,1,1,0,0,1},
                             '{0,0,0,1,0,0,0,0,0,1},
                             '{0,0,0,1,0,0,0,1,1,1},
                             '{0,1,1,1,0,0,1,1,1,1},
                             '{1,1,1,1,0,0,1,1,1,1},
                             '{1,1,1,1,0,0,0,1,1,0},
                             '{0,1,1,0,0,0,0,0,0,0}};         

    
    logic  constraints [0:19][0:19] =  '{'{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 0,0,1,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 0,1,0,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 0,1,0,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0},
                                        
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1, 0,0,0,1},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,1},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0, 0,0,0,1},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,1},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1, 0,1,0,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0, 0,1,0,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0, 0,0,1,0},
                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0}};   

    //create addressing system
    assign address_x = (hcount) >> 4;
    assign address_y = (vcount) >> 4;
    assign address_x_shift = (hcount -80) >>4;
    assign address_y_shift = (vcount - 80) >>4;
    assign lower_x = address_x<<2;
    assign lower_y = address_y<<2;
    
    assign x_in = address_x << 4;
    assign y_in = address_y << 4;
    
    
    assign top_val = {constraints[address_x_shift][lower_y +0],constraints[address_x_shift][lower_y +1],
                      constraints[address_x_shift][lower_y +2],constraints[address_x_shift][lower_y +3]};
    
    assign left_val = {constraints[address_y_shift+10][lower_x+0],constraints[address_y_shift+10][lower_x+1],
                       constraints[address_y_shift+10][lower_x+2],constraints[address_y_shift+10][lower_x+3]};
    
    assign top_pixels = (hcount > 80 & hcount < 240 & vcount <80) ? top_val==4'b0001 ? one_pixels : top_val==4'b0010 ?
                         two_pixels : top_val==4'b0011 ? three_pixels : top_val==4'b0100 ? four_pixels : 
                         top_val==4'b0101 ? five_pixels : top_val==4'b0110 ? six_pixels : top_val==4'b0111 ?
                         seven_pixels : top_val==4'b1000 ? eight_pixels : top_val==4'b1001 ? nine_pixels :12'hfff : 12'hfff;
   
    assign left_pixels = (vcount > 80 & vcount < 240 & hcount <80) ? left_val==4'b0001 ? one_pixels : left_val==4'b0010 ?
                         two_pixels : left_val==4'b0011 ? three_pixels : left_val==4'b0100 ? four_pixels : 
                         left_val==4'b0101 ? five_pixels : left_val==4'b0110 ? six_pixels : left_val==4'b0111 ?
                         seven_pixels : left_val==4'b1000 ? eight_pixels : left_val==4'b1001 ? nine_pixels :12'hfff : 12'hfff;
    
    assign grid_pixels = (hcount > 80 | vcount > 80) ? ((hcount % 16 ==0) | (vcount % 16 ==0)) ? 12'h000 : 12'hfff : 12'h000;
    assign tile_pixels = (hcount > 80 & vcount > 80 & hcount < 240 & vcount < 240) ? vals[address_y_shift][address_x_shift] ? 12'h000 : 12'hfff : 12'hfff;
    assign pixel_out = (hcount < 241 & vcount < 241) ? ~(~top_pixels + ~left_pixels + ~grid_pixels + ~tile_pixels) : 12'hfff  ;
    
    //logic to generate number grid values
   

    always_ff @(posedge clock) begin
        if (reset) begin
            constraints <= '{default:20'b000000000000000000000};
            vals <= '{default:1'b0};
            count_grid <= 4'b0;
            count_num <= 5'b0;
            done_old<=1'b0;
            receiving <= 1'b0;
        end else if (memory_read_start) begin
            constraints[count_num][19:0] <= constraint_vals;
            count_num <= count_num + 5'b1;
        end else if (done != done_old & done==1'b1) begin
            receiving <= 1'b1;
            vals[count_grid][9:0] <= grid_vals;
            count_grid <= count_grid + 1;
        end else if(receiving) begin
            vals[count_grid][9:0] <= grid_vals;
            count_grid <= count_grid + 1;
            if (count_grid==4'd10) count_grid <= 0;
        end
        done_old <= done;
    end
endmodule
`default_nettype wire