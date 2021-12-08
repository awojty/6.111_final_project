`default_nettype none
module manual_disp_30_40(
                   input wire clock,
                   input wire reset,
                   input wire left,
                   input wire right,
                   input wire up,
                   input wire down,
                   input wire center,
                   input wire start_sending_constraint,
                   input wire [119:0] constraint_vals,
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
    logic [5:0] top_val;
    logic [5:0] left_val;
    
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
    logic [11:0] nine_pixels;
    logic [11:0] ten_pixels;
    logic [11:0] eleven_pixels;
    logic [11:0] twelve_pixels;
    logic [11:0] thirteen_pixels;
    logic [11:0] fourteen_pixels;
    logic [11:0] fifteen_pixels;
    logic [11:0] sixteen_pixels;
    logic [11:0] seventeen_pixels;
    logic [11:0] eighteen_pixels;
    logic [11:0] nineteen_pixels;
    logic [11:0] twenty_pixels;
    logic [11:0] twentyone_pixels;
    logic [11:0] twentytwo_pixels;
    logic [11:0] twentythree_pixels;
    logic [11:0] twentyfour_pixels;
    logic [11:0] twentyfive_pixels;
    logic [11:0] twentysix_pixels;
    logic [11:0] twentyseven_pixels;
    logic [11:0] twentyeight_pixels;
    logic [11:0] twentynine_pixels;
    logic [11:0] thirty_pixels;
    logic [11:0] thirtyone_pixels;
    logic [11:0] thirtytwo_pixels;
    logic [11:0] thirtythree_pixels;
    logic [11:0] thirtyfour_pixels;
    logic [11:0] thirtyfive_pixels;
    logic [11:0] thirtysix_pixels;
    logic [11:0] thirtyseven_pixels;
    logic [11:0] thirtyeight_pixels;
    logic [11:0] thirtynine_pixels;
    logic [11:0] forty_pixels;
    
    
    logic [11:0] blank_pixels;
    
    //values we use to control our "cursor"
    reg [6:0] cursor_x;
    reg [6:0] cursor_y;
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
    tens_pixels #(.WIDTH(16), .HEIGHT(16)) ten(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(ten_pixels));
    elevens_pixels #(.WIDTH(16), .HEIGHT(16)) eleven(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(eleven_pixels));
    twelves_pixels #(.WIDTH(16), .HEIGHT(16)) twelve(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twelve_pixels));
    thirteens_pixels #(.WIDTH(16), .HEIGHT(16)) thirteen(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirteen_pixels));
    forteens_pixels #(.WIDTH(16), .HEIGHT(16)) fourteen(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(fourteen_pixels));
    fifteens_pixels #(.WIDTH(16), .HEIGHT(16)) fifteen(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(fifteen_pixels));
    sixteens_pixels #(.WIDTH(16), .HEIGHT(16)) sixteen(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(sixteen_pixels));
    seventeens_pixels #(.WIDTH(16), .HEIGHT(16)) seventeen(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(seventeen_pixels));
    eighteens_pixels #(.WIDTH(16), .HEIGHT(16)) eighteen(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(eighteen_pixels));
    nineteens_pixels #(.WIDTH(16), .HEIGHT(16)) nineteen(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(nineteen_pixels));
    twenties_pixels #(.WIDTH(16), .HEIGHT(16)) twenty(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twenty_pixels));
    twentyones_pixels #(.WIDTH(16), .HEIGHT(16)) twentyone(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twentyone_pixels));
    twentytwos_pixels #(.WIDTH(16), .HEIGHT(16)) twentytwo(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twentytwo_pixels));
    twentythrees_pixels #(.WIDTH(16), .HEIGHT(16)) twentythree(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twentythree_pixels));
    twentyfours_pixels #(.WIDTH(16), .HEIGHT(16)) twentyfour(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twentyfour_pixels));
    twentyfives_pixels #(.WIDTH(16), .HEIGHT(16)) twentyfive(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twentyfive_pixels));
    twentysixes_pixels #(.WIDTH(16), .HEIGHT(16)) twentysix(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twentysix_pixels));
    twentysevens_pixels #(.WIDTH(16), .HEIGHT(16)) twentyseven(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twentyseven_pixels));
    twentyeights_pixels #(.WIDTH(16), .HEIGHT(16)) twentyeight(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twentyeight_pixels));
    twentynines_pixels #(.WIDTH(16), .HEIGHT(16)) twentynine(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(twentynine_pixels));
    thirties_pixels #(.WIDTH(16), .HEIGHT(16)) thirty(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirty_pixels));
    thirtyones_pixels #(.WIDTH(16), .HEIGHT(16)) thirtyone(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirtyone_pixels));
    thirtytwos_pixels #(.WIDTH(16), .HEIGHT(16)) thirtytwo(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirtytwo_pixels));
    thirtythrees_pixels #(.WIDTH(16), .HEIGHT(16)) thirtythree(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirtythree_pixels));
    thirtyfours_pixels #(.WIDTH(16), .HEIGHT(16)) thirtyfour(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirtyfour_pixels));
    thirtyfives_pixels #(.WIDTH(16), .HEIGHT(16)) thirtyfive(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirtyfive_pixels));
    thirtysixes_pixels #(.WIDTH(16), .HEIGHT(16)) thirtysix(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirtysix_pixels));
    thirtysevens_pixels #(.WIDTH(16), .HEIGHT(16)) thirtyseven(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirtyseven_pixels));
    thirtyeights_pixels #(.WIDTH(16), .HEIGHT(16)) thirtyeight(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirtyeight_pixels));
    thirtynines_pixels #(.WIDTH(16), .HEIGHT(16)) thirtynine(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(thirtynine_pixels));
    forties_pixels #(.WIDTH(16), .HEIGHT(16)) forty(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(forty_pixels));
    
    assign blank_pixels = 12'hfff;
    
   
     //30x40 array to store 1 and 0s of our grid for display
    logic  vals [0:29][0:39];// = {'{0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1},
//                             '{0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1},
//                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
//                             '{0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1},
//                             '{0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1},
//                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
//                             '{0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1},
//                             '{1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
//                             '{1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0},
//                             '{0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
//                             '{0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1},
//                             '{0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1},
//                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
//                             '{0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1},
//                             '{0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1},
//                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
//                             '{0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1},
//                             '{1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
//                             '{1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0},
//                             '{0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0},
//                             '{0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,1,1,1,1},
//                             '{0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1},
//                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
//                             '{0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1,0,0,0,1,1,1,1,0,0,1},
//                             '{0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,1},
//                             '{0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1,0,0,0,1,0,0,0,1,1,1},
//                             '{0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1,0,1,1,1,0,0,1,1,1,1},
//                             '{1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1,1,1,1,1,0,0,1,1,1,1},
//                             '{1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0,1,1,1,1,0,0,0,1,1,0},
//                             '{0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0}};         

                                               //1          2            3              4          5           6             7           8               9            10          11            12              13       14             15          16          
    logic  constraints [0:69][0:119];
    
    //create addressing system
    assign address_x = (hcount) >> 4;
    assign address_y = (vcount) >> 4;
    assign address_x_shift = (hcount -320) >>4;
    assign address_y_shift = (vcount - 240) >>4;
    assign lower_x = ((address_x<<2) + (address_x<<1));
    assign lower_y = ((address_y<<2) + (address_y<<1));
    
    assign x_in = address_x << 4;
    assign y_in = address_y << 4;
    
    
    assign top_val = {constraints[address_x_shift][lower_y +30],constraints[address_x_shift][lower_y +31],//30 added on top because we skip the first 5 tiles (they dont exist)
                      constraints[address_x_shift][lower_y +32],constraints[address_x_shift][lower_y +33],
                      constraints[address_x_shift][lower_y +34],constraints[address_x_shift][lower_y+35]};
    
    assign left_val = {constraints[address_y_shift][lower_x+0],constraints[address_y_shift][lower_x+1], 
                      constraints[address_y_shift][lower_x+2],constraints[address_y_shift][lower_x+3],
                       constraints[address_y_shift][lower_x+4],constraints[address_y_shift][lower_x+5]};
    
    assign top_pixels = (hcount > 320 & hcount < 960 & vcount <240) ? top_val==6'b000001 ? one_pixels : top_val==6'b000010 ?
                         two_pixels : top_val==6'b000011 ? three_pixels : top_val==6'b000100 ? four_pixels : 
                         top_val==6'b000101 ? five_pixels : top_val==6'b000110 ? six_pixels : top_val==6'b000111 ?
                         seven_pixels : top_val==6'b001000 ? eight_pixels : top_val==6'b001001 ? nine_pixels :
                         top_val==6'b001010 ? ten_pixels : top_val==6'b001011 ? eleven_pixels : top_val==6'b001100 ? 
                         twelve_pixels : top_val==6'b001101 ? thirteen_pixels : top_val==6'b001110 ? fourteen_pixels :
                         top_val==6'b001111 ? fifteen_pixels : top_val==6'b010000 ? sixteen_pixels : top_val==6'b010001 ?
                         seventeen_pixels : top_val==6'b010010 ? eighteen_pixels : top_val==6'b010011 ? nineteen_pixels :
                         top_val==6'b010100 ? twenty_pixels : top_val==6'b010101 ? twentyone_pixels : top_val==6'b010110 ?
                         twentytwo_pixels : top_val==6'b010111 ? twentythree_pixels : top_val==6'b011000 ? twentyfour_pixels : 
                         top_val==6'b011001 ? twentyfive_pixels : top_val==6'b011010 ? twentysix_pixels : top_val==6'b011011 ?
                         twentyseven_pixels: top_val==6'b011100 ? twentyeight_pixels : top_val==6'b011101 ? twentynine_pixels :
                         top_val==6'b011110 ? thirty_pixels : top_val==6'b011111 ? thirtyone_pixels : top_val==6'b100000 ?
                         thirtytwo_pixels : top_val==6'b100001 ? thirtythree_pixels : top_val==6'b100010 ? thirtyfour_pixels :
                         top_val==6'b100011 ? thirtyfive_pixels : top_val==6'b100100 ? thirtysix_pixels : top_val==6'b100101 ?
                         thirtyseven_pixels : top_val==6'b100110 ? thirtyeight_pixels : top_val==6'b100111 ? thirtynine_pixels :
                         top_val==6'b101000 ? forty_pixels :12'hfff : 12'hfff;
   
    assign left_pixels =(vcount > 240 & vcount < 720 & hcount <320) ? left_val==6'b000001 ? one_pixels : left_val==6'b000010 ?
                         two_pixels : left_val==6'b000011 ? three_pixels : left_val==6'b000100 ? four_pixels :
                         left_val==6'b000101 ? five_pixels : left_val==6'b000110 ? six_pixels : left_val==6'b000111 ?
                         seven_pixels : left_val==6'b001000 ? eight_pixels : left_val==6'b001001 ? nine_pixels :
                         left_val==6'b001010 ? ten_pixels : left_val==6'b001011 ? eleven_pixels : left_val==6'b001100 ?
                         twelve_pixels : left_val==6'b001101 ? thirteen_pixels : left_val==6'b001110 ? fourteen_pixels :
                         left_val==6'b001111 ? fifteen_pixels : left_val==6'b010000 ? sixteen_pixels : left_val==6'b010001 ?
                         seventeen_pixels : left_val==6'b010010 ? eighteen_pixels : left_val==6'b010011 ? nineteen_pixels :
                         left_val==6'b010100 ? twenty_pixels : left_val==6'b010101 ? twentyone_pixels : left_val==6'b010110 ?
                         twentytwo_pixels : left_val==6'b010111 ? twentythree_pixels : left_val==6'b011000 ? twentyfour_pixels :
                         left_val==6'b011001 ? twentyfive_pixels : left_val==6'b011010 ? twentysix_pixels : left_val==6'b011011 ?
                         twentyseven_pixels: left_val==6'b011100 ? twentyeight_pixels : left_val==6'b011101 ? twentynine_pixels :
                         left_val==6'b011110 ? thirty_pixels : left_val==6'b011111 ? thirtyone_pixels : left_val==6'b100000 ?
                         thirtytwo_pixels : left_val==6'b100001 ? thirtythree_pixels : left_val==6'b100010 ? thirtyfour_pixels :
                         left_val==6'b100011 ? thirtyfive_pixels : left_val==6'b100100 ? thirtysix_pixels : left_val==6'b100101 ?
                         thirtyseven_pixels : left_val==6'b100110 ? thirtyeight_pixels : left_val==6'b100111 ? thirtynine_pixels :
                         left_val==6'b101000 ? forty_pixels :12'hfff : 12'hfff;
    
    assign grid_pixels = (hcount > 320 | vcount > 240) ? ((hcount % 16 ==0) | (vcount % 16 ==0)) ? 12'h000 : 12'hfff : 12'h000;
    assign tile_pixels = (hcount > 320 & vcount > 240 & hcount < 960 & vcount < 720) ? vals[address_y_shift][address_x_shift] ? 12'h000 : 12'hfff : 12'hfff;
    assign cursor_pixels = (hcount > 320 & vcount > 240 & hcount < 960 & vcount < 720) ? (address_x_shift == cursor_x & address_y_shift ==cursor_y) ? cursor_color : 12'hfff : 12'hfff;
    assign pixel_out = (hcount < 961 & vcount < 721) ? ~(~top_pixels + ~left_pixels + ~grid_pixels + ~tile_pixels + ~cursor_pixels) : 12'hfff  ;
    
    //logic to generate number grid values
    logic [4:0] count2;
   
   //keeping track of previous states of buttons so we can assign on rising edge of buttons
   logic left_old,right_old,up_old,down_old,center_old;
   logic movel,mover,moveu,moved,select;
   assign movel = (left_old != left & left==1) ? 1 : 0;
   assign mover = (right_old != right & right==1) ? 1 : 0;
   assign moved = (down_old != down & down==1) ? 1 : 0;
   assign moveu = (up_old != up & up==1) ? 1 : 0;
   assign select = (center_old != center & center==1) ? 1 : 0;
    always_ff @(posedge clock) begin
        //logic to control position of cursor

        if (reset) begin
            constraints <= '{default:79'd0};
            vals <= '{default:1'b0};
            count_num <= 7'b0;
            center_old<=1'b1;
            receiving <= 1'b0;
            cursor_x <= 7'd0;
            cursor_y <= 7'd0;
            count_num <= 5'b0;
            receiving <= 1'b0;
        end else if (start_sending_constraint && (count_num < 70)) begin
            constraints[count_num][0] <= constraint_vals[119];
            constraints[count_num][1] <= constraint_vals[118];
            constraints[count_num][2] <= constraint_vals[117];
            constraints[count_num][3] <= constraint_vals[116];
            constraints[count_num][4] <= constraint_vals[115];
            constraints[count_num][5] <= constraint_vals[114];
            constraints[count_num][6] <= constraint_vals[113];
            constraints[count_num][7] <= constraint_vals[112];
            constraints[count_num][8] <= constraint_vals[111];
            constraints[count_num][9] <= constraint_vals[110];
            constraints[count_num][10] <= constraint_vals[109];
            constraints[count_num][11] <= constraint_vals[108];
            constraints[count_num][12] <= constraint_vals[107];
            constraints[count_num][13] <= constraint_vals[106];
            constraints[count_num][14] <= constraint_vals[105];
            constraints[count_num][15] <= constraint_vals[104];
            constraints[count_num][16] <= constraint_vals[103];
            constraints[count_num][17] <= constraint_vals[102];
            constraints[count_num][18] <= constraint_vals[101];
            constraints[count_num][19] <= constraint_vals[100];
            constraints[count_num][20] <= constraint_vals[99];
            constraints[count_num][21] <= constraint_vals[98];
            constraints[count_num][22] <= constraint_vals[97];
            constraints[count_num][23] <= constraint_vals[96];
            constraints[count_num][24] <= constraint_vals[95];
            constraints[count_num][25] <= constraint_vals[94];
            constraints[count_num][26] <= constraint_vals[93];
            constraints[count_num][27] <= constraint_vals[92];
            constraints[count_num][28] <= constraint_vals[91];
            constraints[count_num][29] <= constraint_vals[90];
            constraints[count_num][30] <= constraint_vals[89];
            constraints[count_num][31] <= constraint_vals[88];
            constraints[count_num][32] <= constraint_vals[87];
            constraints[count_num][33] <= constraint_vals[86];
            constraints[count_num][34] <= constraint_vals[85];
            constraints[count_num][35] <= constraint_vals[84];
            constraints[count_num][36] <= constraint_vals[83];
            constraints[count_num][37] <= constraint_vals[82];
            constraints[count_num][38] <= constraint_vals[81];
            constraints[count_num][39] <= constraint_vals[80];
            constraints[count_num][40] <= constraint_vals[79];
            constraints[count_num][41] <= constraint_vals[78];
            constraints[count_num][42] <= constraint_vals[77];
            constraints[count_num][43] <= constraint_vals[76];
            constraints[count_num][44] <= constraint_vals[75];
            constraints[count_num][45] <= constraint_vals[74];
            constraints[count_num][46] <= constraint_vals[73];
            constraints[count_num][47] <= constraint_vals[72];
            constraints[count_num][48] <= constraint_vals[71];
            constraints[count_num][49] <= constraint_vals[70];
            constraints[count_num][50] <= constraint_vals[69];
            constraints[count_num][51] <= constraint_vals[68];
            constraints[count_num][52] <= constraint_vals[67];
            constraints[count_num][53] <= constraint_vals[66];
            constraints[count_num][54] <= constraint_vals[65];
            constraints[count_num][55] <= constraint_vals[64];
            constraints[count_num][56] <= constraint_vals[63];
            constraints[count_num][57] <= constraint_vals[62];
            constraints[count_num][58] <= constraint_vals[61];
            constraints[count_num][59] <= constraint_vals[60];
            constraints[count_num][60] <= constraint_vals[59];
            constraints[count_num][61] <= constraint_vals[58];
            constraints[count_num][62] <= constraint_vals[57];
            constraints[count_num][63] <= constraint_vals[56];
            constraints[count_num][64] <= constraint_vals[55];
            constraints[count_num][65] <= constraint_vals[54];
            constraints[count_num][66] <= constraint_vals[53];
            constraints[count_num][67] <= constraint_vals[52];
            constraints[count_num][68] <= constraint_vals[51];
            constraints[count_num][69] <= constraint_vals[50];
            constraints[count_num][70] <= constraint_vals[49];
            constraints[count_num][71] <= constraint_vals[48];
            constraints[count_num][72] <= constraint_vals[47];
            constraints[count_num][73] <= constraint_vals[46];
            constraints[count_num][74] <= constraint_vals[45];
            constraints[count_num][75] <= constraint_vals[44];
            constraints[count_num][76] <= constraint_vals[43];
            constraints[count_num][77] <= constraint_vals[42];
            constraints[count_num][78] <= constraint_vals[41];
            constraints[count_num][79] <= constraint_vals[40];
            constraints[count_num][80] <= constraint_vals[39];
            constraints[count_num][81] <= constraint_vals[38];
            constraints[count_num][82] <= constraint_vals[37];
            constraints[count_num][83] <= constraint_vals[36];
            constraints[count_num][84] <= constraint_vals[35];
            constraints[count_num][85] <= constraint_vals[34];
            constraints[count_num][86] <= constraint_vals[33];
            constraints[count_num][87] <= constraint_vals[32];
            constraints[count_num][88] <= constraint_vals[31];
            constraints[count_num][89] <= constraint_vals[30];
            constraints[count_num][90] <= constraint_vals[29];
            constraints[count_num][91] <= constraint_vals[28];
            constraints[count_num][92] <= constraint_vals[27];
            constraints[count_num][93] <= constraint_vals[26];
            constraints[count_num][94] <= constraint_vals[25];
            constraints[count_num][95] <= constraint_vals[24];
            constraints[count_num][96] <= constraint_vals[23];
            constraints[count_num][97] <= constraint_vals[22];
            constraints[count_num][98] <= constraint_vals[21];
            constraints[count_num][99] <= constraint_vals[20];
            constraints[count_num][100] <= constraint_vals[19];
            constraints[count_num][101] <= constraint_vals[18];
            constraints[count_num][102] <= constraint_vals[17];
            constraints[count_num][103] <= constraint_vals[16];
            constraints[count_num][104] <= constraint_vals[15];
            constraints[count_num][105] <= constraint_vals[14];
            constraints[count_num][106] <= constraint_vals[13];
            constraints[count_num][107] <= constraint_vals[12];
            constraints[count_num][108] <= constraint_vals[11];
            constraints[count_num][109] <= constraint_vals[10];
            constraints[count_num][110] <= constraint_vals[9];
            constraints[count_num][111] <= constraint_vals[8];
            constraints[count_num][112] <= constraint_vals[7];
            constraints[count_num][113] <= constraint_vals[6];
            constraints[count_num][114] <= constraint_vals[5];
            constraints[count_num][115] <= constraint_vals[4];
            constraints[count_num][116] <= constraint_vals[3];
            constraints[count_num][117] <= constraint_vals[2];
            constraints[count_num][118] <= constraint_vals[1];
            constraints[count_num][119] <= constraint_vals[0];
            count_num <= count_num + 5'b1;    
            
            if (count_num >= 69) begin
                receiving <= 1'b0;
    
            end
    end else begin
            if (select) begin
                vals[cursor_y][cursor_x] <= ~vals[cursor_y][cursor_x];

            end
            //logic to control position of cursor
            if (moved && (cursor_y==29)) cursor_y <=cursor_y;
            else if (moved) cursor_y <= cursor_y + 6'd1;
            else if (movel && (cursor_x ==0)) cursor_x <= cursor_x;
            else if (movel) cursor_x <= cursor_x - 6'd1;
            else if (moveu && (cursor_y ==0))cursor_y<= cursor_y;
            else if (moveu) cursor_y <= cursor_y - 6'd1;
            else if (mover && (cursor_x==39)) cursor_x<=cursor_x;
            else if (mover) cursor_x <= cursor_x + 6'd1;
            else begin
                cursor_y <= cursor_y;
                cursor_x <= cursor_x;
                
            end


            
        end
        center_old <= center;
        up_old <= up;
        down_old <= down;
        left_old <= left;
        right_old <= right;
    
    end
endmodule
`default_nettype wire