`default_nettype none
module manual_disp(
                   input wire clock,
                   input wire reset,
                   input wire left,
                   input wire right,
                   input wire up,
                   input wire down,
                   input wire center,
                   input wire memory_read_start,
                   input wire [79:0] constraint_vals,
                   input wire [12:0] hcount,
                   input wire [12:0] vcount,
                   input wire [15:0] switch,
                   output logic [11:0] pixel_out);
    
    logic receiving; //lets the system know if it is in receiving mode or not              
    logic [6:0] count_num; //counts from 0-19 to keep track of indexing with clock cycles for the 80x80 constraints
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
    
    //values we use to control our "cursor"
    reg [5:0] cursor_x;
    reg [5:0] cursor_y;
    logic [11:0] cursor_pixels;
    logic [11:0] cursor_color;
    logic center_old; //we change the value of a tile only on rising edge of center
    assign cursor_color = 12'hf0f;
    
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
    
   
     //30x40 array to store 1 and 0s of our grid for display
    logic  vals [0:29][0:39] = {'{0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1},
                             '{0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1},
                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
                             '{0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1},
                             '{0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1},
                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
                             '{0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1},
                             '{1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
                            '{1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0},
                            '{0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
                            '{0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1},
                             '{0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1},
                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
                             '{0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1},
                             '{0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1},
                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
                             '{0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1},
                             '{1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
                            '{1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0},
                            '{0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
                            '{0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1},
                             '{0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1},
                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
                             '{0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1},
                             '{0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1},
                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
                             '{0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1},
                             '{1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
                            '{1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0},
                            '{0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0}
                            };         

    
    logic  constraints [0:119][0:119];// =  '{'{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 0,0,1,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 0,1,0,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 0,1,0,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0},
                                        
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1, 0,0,0,1},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,1},
                                        //'{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0, 0,0,0,1},
                                        //'{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,1},
                                        //'{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1, 0,1,0,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0, 0,1,0,0},
                                       // '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0, 0,0,1,0},
                                      //  '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0}};   

    //create addressing system
    assign address_x = (hcount) >> 4;
    assign address_y = (vcount) >> 4;
    assign address_x_shift = (hcount -320) >>4;
    assign address_y_shift = (vcount - 80) >>4;
    assign lower_x = address_x<<2;
    assign lower_y = address_y<<2;
    
    assign x_in = address_x << 4;
    assign y_in = address_y << 4;
    
    
    assign top_val = {constraints[address_x_shift][lower_y +0],constraints[address_x_shift][lower_y +1],
                      constraints[address_x_shift][lower_y +2],constraints[address_x_shift][lower_y +3]};
    
    assign left_val = {constraints[address_y_shift+10][lower_x+0],constraints[address_y_shift+10][lower_x+1],
                       constraints[address_y_shift+10][lower_x+2],constraints[address_y_shift+10][lower_x+3]};
    
    assign top_pixels = (hcount > 320 & hcount < 960 & vcount <240) ? top_val==4'b0001 ? one_pixels : top_val==4'b0010 ?
                         two_pixels : top_val==4'b0011 ? three_pixels : top_val==4'b0100 ? four_pixels : 
                         top_val==4'b0101 ? five_pixels : top_val==4'b0110 ? six_pixels : top_val==4'b0111 ?
                         seven_pixels : top_val==4'b1000 ? eight_pixels : top_val==4'b1001 ? nine_pixels :12'hfff : 12'hfff;
   
    assign left_pixels = (vcount > 240 & vcount < 720 & hcount <320) ? left_val==4'b0001 ? one_pixels : left_val==4'b0010 ?
                         two_pixels : left_val==4'b0011 ? three_pixels : left_val==4'b0100 ? four_pixels : 
                         left_val==4'b0101 ? five_pixels : left_val==4'b0110 ? six_pixels : left_val==4'b0111 ?
                         seven_pixels : left_val==4'b1000 ? eight_pixels : left_val==4'b1001 ? nine_pixels :12'hfff : 12'hfff;
    
    assign grid_pixels = (hcount > 320 | vcount > 240) ? ((hcount % 16 ==0) | (vcount % 16 ==0)) ? 12'h000 : 12'hfff : 12'h000;
    assign tile_pixels = (hcount > 320 & vcount > 240 & hcount < 960 & vcount < 720) ? vals[address_y_shift][address_x_shift] ? 12'h000 : 12'hfff : 12'hfff;
    assign cursor_pixels = (hcount > 320 & vcount > 240 & hcount < 960 & vcount < 720) ? (address_x_shift == cursor_x & address_y_shift ==cursor_y) ? cursor_color : 12'hfff : 12'hfff;
    assign pixel_out = (hcount < 961 & vcount < 721) ? ~(~top_pixels + ~left_pixels + ~grid_pixels + ~tile_pixels + ~cursor_pixels) : 12'hfff  ;
    
    //logic to generate number grid values
    logic [4:0] count2;
   
    always_ff @(posedge clock) begin
        //logic to control position of cursor
        if (down & cursor_y==29) cursor_y <=cursor_y;
        else if (down) cursor_y <= cursor_y + 6'd1;
        else if (left & cursor_x)cursor_x <= cursor_x;
        else if (left) cursor_x <= cursor_x - 6'd1;
        else if (up & cursor_y ==0)cursor_y<= cursor_y;
        else if (up) cursor_y <= cursor_y - 6'd1;
        else if (right & cursor_x==39) cursor_x<=cursor_x;
        else if (right) cursor_y <= cursor_y + 6'd1;

        if (center & center != center_old) begin
            vals[cursor_y][cursor_x] <= ~vals[cursor_y][cursor_x];
        end

        
        
        if (reset) begin
            constraints <= '{default:79'd0};
            vals <= '{default:1'b0};
            count_num <= 7'b0;
            center_old<=1'b1;
            receiving <= 1'b0;
            cursor_x <= 7'd0;
            cursor_y <= 7'd0;
        end else if (memory_read_start) begin
            constraints[count_num][19] <= constraint_vals[0];
            constraints[count_num][18] <= constraint_vals[1];
            constraints[count_num][17] <= constraint_vals[2];
            constraints[count_num][16] <= constraint_vals[3];
            constraints[count_num][15] <= constraint_vals[4];
            constraints[count_num][14] <= constraint_vals[5];
            constraints[count_num][13] <= constraint_vals[6];
            constraints[count_num][12] <= constraint_vals[7];
            constraints[count_num][11] <= constraint_vals[8];
            constraints[count_num][10] <= constraint_vals[9];
            constraints[count_num][9] <= constraint_vals[10];
            constraints[count_num][8] <= constraint_vals[11];
            constraints[count_num][7] <= constraint_vals[12];
            constraints[count_num][6] <= constraint_vals[13];
            constraints[count_num][5] <= constraint_vals[14];
            constraints[count_num][4] <= constraint_vals[15];
            constraints[count_num][3] <= constraint_vals[16];
            constraints[count_num][2] <= constraint_vals[17];
            constraints[count_num][1] <= constraint_vals[18];
            constraints[count_num][0] <= constraint_vals[19];  
            count_num <= count_num + 5'b1;          

            if (count_num > 19) receiving <= 1'b0;
            
            
        end  
        center_old <= center;
    end
endmodule
`default_nettype wire