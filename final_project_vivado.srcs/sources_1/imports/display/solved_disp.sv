`default_nettype none
module solved_disp(
                   input wire clock,
                   input wire reset,
                   input wire solver_done,
                   input wire memory_read_start,
                   input wire [19:0] constraint_vals,
                   input wire [9:0] grid_vals1,
                   input wire [9:0] grid_vals2,
                   input wire [9:0] grid_vals3,
                   input wire [9:0] grid_vals4,
                   input wire [9:0] grid_vals5,
                   input wire [9:0] grid_vals6,
                   input wire [9:0] grid_vals7,
                   input wire [9:0] grid_vals8,
                   input wire [9:0] grid_vals9,
                   input wire [9:0] grid_vals10,
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
    logic [11:0] ten_pixels;
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
    tens_pixels #(.WIDTH(16), .HEIGHT(16)) ten(.pixel_clk_in(clock), .x_in(x_in), .y_in(y_in), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(ten_pixels));
    assign blank_pixels = 12'hfff;
    
   //unpacking grid values
   logic grid1 [9:0];
   assign grid1=  '{grid_vals1[9],grid_vals1[8],grid_vals1[7],grid_vals1[6],grid_vals1[5],
                   grid_vals1[4],grid_vals1[3],grid_vals1[2],grid_vals1[1],grid_vals1[0]};
   logic grid2 [9:0];
   assign grid2 = '{grid_vals2[9],grid_vals2[8],grid_vals2[7],grid_vals2[6],grid_vals2[5],
                   grid_vals2[4],grid_vals2[3],grid_vals2[2],grid_vals2[1],grid_vals2[0]};
   logic grid3 [9:0];
   assign grid3 = '{grid_vals3[9],grid_vals3[8],grid_vals3[7],grid_vals3[6],grid_vals3[5],
                    grid_vals3[4],grid_vals3[3],grid_vals3[2],grid_vals3[1],grid_vals3[0]};
   logic grid4 [9:0];
   assign grid4= '{grid_vals4[9],grid_vals4[8],grid_vals4[7],grid_vals4[6],grid_vals4[5],
                   grid_vals4[4],grid_vals4[3],grid_vals4[2],grid_vals4[1],grid_vals4[0]};
   logic grid5 [9:0];
   assign grid5 = '{grid_vals5[9],grid_vals5[8],grid_vals5[7],grid_vals5[6],grid_vals5[5],
                   grid_vals5[4],grid_vals5[3],grid_vals5[2],grid_vals5[1],grid_vals5[0]};
   logic grid6 [9:0];
   assign grid6= '{grid_vals6[9],grid_vals6[8],grid_vals6[7],grid_vals6[6],grid_vals6[5],
                   grid_vals6[4],grid_vals6[3],grid_vals6[2],grid_vals6[1],grid_vals6[0]};
   logic grid7 [9:0];
   assign grid7= '{grid_vals7[9],grid_vals7[8],grid_vals7[7],grid_vals7[6],grid_vals7[5],
                   grid_vals7[4],grid_vals7[3],grid_vals7[2],grid_vals7[1],grid_vals7[0]};
   logic grid8 [9:0];
   assign grid8= '{grid_vals8[9],grid_vals8[8],grid_vals8[7],grid_vals8[6],grid_vals8[5],
                   grid_vals8[4],grid_vals8[3],grid_vals8[2],grid_vals8[1],grid_vals8[0]};
   logic grid9 [9:0];
   assign grid9 = '{grid_vals9[9],grid_vals9[8],grid_vals9[7],grid_vals9[6],grid_vals9[5],
                   grid_vals9[4],grid_vals9[3],grid_vals9[2],grid_vals9[1],grid_vals9[0]};
   logic grid10 [9:0];
   assign grid10= '{grid_vals10[9],grid_vals10[1],grid_vals10[8],grid_vals10[7],grid_vals10[6],
                   grid_vals10[4],grid_vals10[3],grid_vals10[2],grid_vals10[1],grid_vals10[0]};
     //10x10 array to store 1 and 0s of our grid for display
    logic  vals [0:9][0:9];// = {'{0,0,0,0,0,0,1,1,1,1},
                           //  '{0,0,0,1,1,1,0,0,0,1},
                           //  '{0,0,0,1,0,0,0,1,1,1},
                           //  '{0,0,0,1,1,1,1,0,0,1},
                           //  '{0,0,0,1,1,1,1,1,0,1},
                           //  '{0,0,0,1,0,0,0,1,1,1},
                           //  '{0,1,1,1,0,0,1,1,1,1},
                           //  '{1,1,1,1,0,0,1,1,1,1},
                           //  '{1,1,1,1,0,0,0,1,1,0},
                           //  '{0,1,1,0,0,0,0,0,0,0}};         

    
    logic  constraints [0:19][0:19];// =  '{'{0,0,0,1, 0,0,1,0, 0,0,1,1, 0,1,0,0, 0,1,0,1},
//                                        '{0,1,1,0, 0,1,1,1, 1,0,0,0, 1,0,0,1, 0,0,0,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 0,0,1,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 0,1,0,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1, 0,1,0,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 1,0,0,0},
                                        
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1, 0,0,0,1},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,1},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0, 0,0,0,1},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,1},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,1,1},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,1, 0,1,0,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0, 0,1,0,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,1,0,0, 0,0,1,0},
//                                        '{0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,1,0}};   

    //create addressing system
    assign address_x = (hcount) >> 4;
    assign address_y = (vcount) >> 4;
    assign address_x_shift = (hcount -80) >>4;
    assign address_y_shift = (vcount - 80) >>4;
    assign lower_x = address_x<<2;
    assign lower_y = address_y<<2;
    
    assign x_in = address_x << 4;
    assign y_in = address_y << 4;
    
    
    assign top_val = {constraints[19-address_x_shift][lower_y +0],constraints[19-address_x_shift][lower_y +1],
                      constraints[19-address_x_shift][lower_y +2],constraints[19-address_x_shift][lower_y +3]};
    
    assign left_val = {constraints[address_y_shift][lower_x+0],constraints[address_y_shift][lower_x+1],
                       constraints[address_y_shift][lower_x+2],constraints[address_y_shift][lower_x+3]};
    
    assign top_pixels = (hcount > 80 & hcount < 240 & vcount <80) ? top_val==4'b0001 ? one_pixels : top_val==4'b0010 ?
                         two_pixels : top_val==4'b0011 ? three_pixels : top_val==4'b0100 ? four_pixels : 
                         top_val==4'b0101 ? five_pixels : top_val==4'b0110 ? six_pixels : top_val==4'b0111 ?
                         seven_pixels : top_val==4'b1000 ? eight_pixels : top_val==4'b1001 ? nine_pixels : 
                         top_val==4'b1010 ? ten_pixels : 12'hfff : 12'hfff;
   
    assign left_pixels = (vcount > 80 & vcount < 240 & hcount <80) ? left_val==4'b0001 ? one_pixels : left_val==4'b0010 ?
                         two_pixels : left_val==4'b0011 ? three_pixels : left_val==4'b0100 ? four_pixels : 
                         left_val==4'b0101 ? five_pixels : left_val==4'b0110 ? six_pixels : left_val==4'b0111 ?
                         seven_pixels : left_val==4'b1000 ? eight_pixels : left_val==4'b1001 ? nine_pixels :
                         left_val==4'b1010 ? ten_pixels : 12'hfff : 12'hfff;
    
    assign grid_pixels = (hcount > 80 | vcount > 80) ? ((hcount % 16 ==0) | (vcount % 16 ==0)) ? 12'h000 : 12'hfff : 12'h000;
    assign tile_pixels = (hcount > 80 & vcount > 80 & hcount < 240 & vcount < 240) ? vals[address_y_shift][address_x_shift] ? 12'h000 : 12'hfff : 12'hfff;
    assign pixel_out = (hcount < 241 & vcount < 241) ? ~(~top_pixels + ~left_pixels + ~grid_pixels + ~tile_pixels) : 12'hfff  ;
    
    //logic to generate number grid values
    logic [4:0] count2;
    logic old_solved;

    always_ff @(posedge clock) begin
    

        if (reset) begin
            constraints <= '{default:20'b000000000000000000000};
            vals <= '{default:1'b0};
            count_grid <= 4'b0;
            count_num <= 5'b0;
            done_old<=1'b0;
            receiving <= 1'b0;
            old_solved <=0;
        end else if (memory_read_start & count_num < 10) begin
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
        end else if (memory_read_start & count_num > 9) begin
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
            
            if (count_num > 19) begin
                receiving <= 1'b0;
                count_num <= 5'b0;
    
            end
            
        end else if ((!old_solved) && (old_solved != solver_done)) begin
            vals[0][0:9] <= grid1;
            vals[1][0:9] <= grid2;
            vals[2][0:9] <= grid3;
            vals[3][0:9] <= grid4;
            vals[4][0:9] <= grid5;
            vals[5][0:9] <= grid6;
            vals[6][0:9] <= grid7;
            vals[7][0:9] <= grid8;
            vals[8][0:9] <= grid9;
            vals[9][0:9] <= grid10;
        end
        
       old_solved <=solver_done;


    end
endmodule
`default_nettype wire