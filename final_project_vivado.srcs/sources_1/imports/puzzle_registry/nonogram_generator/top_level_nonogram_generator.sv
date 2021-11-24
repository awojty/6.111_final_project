`timescale 1ns / 1ps

module top_level_nonogram_generator(
   input logic clk_65mhz,
   input logic start_in,
   input logic reset_in,
   input[15:0] sw,
   input btnc, btnu, btnl, btnr, btnd,
   input [7:0] ja, //pixel data from camera
   input [2:0] jb, //other data from camera (including clock return)
   input [2:0] jd,

   output   jbclk, //clock FPGA drives the camera with
   output   jdclk,
   output[3:0] vga_r,
   output[3:0] vga_b,
   output[3:0] vga_g,
   output vga_hs,
   output vga_vs,
   output led16_b, led16_g, led16_r,
   output led17_b, led17_g, led17_r,
   output[15:0] led,
   output ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp

   output hs,
   output vs,
   output b, 
   output rgb,
   output nonogram_generator_done

   );


    //assign seg[6:0] = segments;
    assign  dp = 1'b1;  // turn off the period

    assign led = sw;                        // turn leds on
    assign data = {28'h0123456, sw[3:0]};   // display 0123456 + sw[3:0]
    assign led16_r = btnl;                  // left button -> red led
    assign led16_g = btnc;                  // center button -> green led
    assign led16_b = btnr;                  // right button -> blue led
    assign led17_r = btnl;
    assign led17_g = btnc;
    assign led17_b = btnr;

    wire [10:0] hcount;    // pixel on current line
    wire [9:0] vcount;     // line number
    wire hsync, vsync, blank;
    wire [11:0] pixel;
    reg [11:0] rgb;    
    xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));


    // btnc button is user reset

   
    logic xclk;
    logic[1:0] xclk_count;
    
    logic pclk_buff, pclk_in;
    logic vsync_buff, vsync_in;
    logic href_buff, href_in;
    logic[7:0] pixel_buff, pixel_in;
    
    logic [11:0] cam;
    logic [11:0] frame_buff_out;
    logic [15:0] output_pixels;
    logic [15:0] old_output_pixels;
    logic [12:0] processed_pixels;

    logic valid_pixel;
    logic frame_done_out;
    
    logic [16:0] pixel_addr_in;
    logic [16:0] pixel_addr_out;

    logic move_to_downsampling;
    
    assign xclk = (xclk_count >2'b01);
    assign jbclk = xclk;
    assign jdclk = xclk;
    
    logic button_center_clean;

    logic move_to_digi;

    logic [319:0] digitized_photo [239:0]; // stores 1's an 0's in the correct psotion of pixels
    
    blk_mem_gen_0 jojos_bram(.addra(pixel_addr_in), 
                             .clka(pclk_in),
                             .dina(processed_pixels),
                             .wea(valid_pixel),
                             .addrb(pixel_addr_out),
                             .clkb(clk_65mhz),
                             .doutb(frame_buff_out));
    
    always_ff @(posedge pclk_in)begin
        if (frame_done_out)begin
            move_to_downsampling<=1;
            pixel_addr_in <= 17'b0;  
        end else if (valid_pixel)begin
            pixel_addr_in <= pixel_addr_in +1;  
        end
    end

    filter my_filter(   
                    .clk_in(clk_65mhz),
                    .reset_in(reset_in),
                    .start_in(filter_start_in), //when asserte, start accumulating
                    .photo_in(digitized_photo),
                    .done(filter_done), //320 by 240
                    .rescaled_out(rescaled_photo_out)//for the sake of testing // since thre are 10 fields and each field has two bits (3 states) > 10*2 = 20
    ); 


    constraint_generator my_constraint_generator(   
                    .clk_in(clk_65mhz),
                    .reset_in(reset_in),
                    .start_in(start_constraint_generator), //when asserte, start accumulating
                    .image_in(rescaled_photo_out),
                    .constraints_out(constraint_generator_returned),
                    .done(constraint_generator_done) //320 by 240

    ); 


    logic in_progress;

    logic [39:0] rescaled_photo_out [29:0];
    logic filter_done;
    logic constraint_generator_done;

    logic [119:0] constraint_generator_returned [69:0]
    logic start_constraint_generator;


    
    always_ff @(posedge clk_65mhz) begin

        if(reset_in) begin
            in_progress <= 0;

            //fsm
            constraint_generator_done <=0;
            filter_done <=0;
            start_constraint_generator <=0;
            
        end else begin


            hs <= phsync;
            vs <= pvsync;
            b <= pblank;
            
            rgb <= cam;

            if(start_in) begin
                in_progress <=1;
            end

            if(~move_to_downsampling) begin

                pclk_buff <= jb[0];//WAS JB
                vsync_buff <= jb[1]; //WAS JB
                href_buff <= jb[2]; //WAS JB
                pixel_buff <= ja;
                pclk_in <= pclk_buff;
                vsync_in <= vsync_buff;
                href_in <= href_buff;
                pixel_in <= pixel_buff;
                old_output_pixels <= output_pixels;
                xclk_count <= xclk_count + 2'b01;

                if(((output_pixels[15:12] >>2) + (output_pixels[10:7]>>1) + (output_pixels[4:1]>>2))>5) begin
                    
                    processed_pixels <= {4'b1111,4'b1111,4'b1111};
                    if((hcount<320) &&  (vcount<240)) begin
                        digitized_photo[vount][hcount] <=0;
                    end
                    
                        
                end else begin
                    processed_pixels <= {4'b0000,4'b0000,4'b0000};
                    if((hcount<320) &&  (vcount<240)) begin
                        digitized_photo[vount][hcount] <=1;
                    end
                    
                end
            
            end else if (frame_done_out && in_progress) begin
                //frame_done_out can be asserted like anytime we ress center BUT we want to move forwrd in fsm only after have in start_in
                
                filter_start_in<=1;
                photo_filter_input <=digitized_photo;


            end else if (move_to_constraint_generator) begin
                start_constraint_generator<=1;
                image_in_generator <=rescaled_photo_out;

                move_to_constraint_generator <=0;
                wait_for_generator<=1;



            end else if(wait_for_generator) begin

                if(generator_done) begin

                    nonogram_generator_done <=1;
                    constraints_out <= constraint_generator_returned;

                end
                
            end





        end
    

        
    
    end

    assign pixel_addr_out = hcount+vcount*32'd320;
    assign cam = ((hcount<320) &&  (vcount<240))?frame_buff_out:12'h000;
    
                                        
    camera_read  my_camera(.p_clock_in(pclk_in),
                          .vsync_in(vsync_in),
                          .href_in(href_in),
                          .button_press(button_center_clean),
                          .p_data_in(pixel_in),
                          .pixel_data_out(output_pixels),
                          .pixel_valid_out(valid_pixel),
                          .frame_done_out(frame_done_out));
   


    wire phsync,pvsync,pblank;

    pong_game pg(.vclock_in(clk_65mhz),.reset_in(reset_in),
                .up_in(up),.down_in(down),.pspeed_in(sw[15:12]),
                .hcount_in(hcount),.vcount_in(vcount),
                .hsync_in(hsync),.vsync_in(vsync),.blank_in(blank),
                .phsync_out(phsync),.pvsync_out(pvsync),.pblank_out(pblank),.pixel_out(pixel));



    reg b,hs,vs;


//    assign rgb = sw[0] ? {12{border}} : pixel ; //{{4{hcount[7]}}, {4{hcount[6]}}, {4{hcount[5]}}};


    //process rgb here to do black-scaling 

    // the following lines are required for the Nexys4 VGA circuit - do not change
    
    //commented out since this is assigned in the top level 
    
    // assign vga_r = ~b ? rgb[11:8]: 0;
    // assign vga_g = ~b ? rgb[7:4] : 0;
    // assign vga_b = ~b ? rgb[3:0] : 0;

    // assign vga_hs = ~hs;
    // assign vga_vs = ~vs;

endmodule




////////////////////////////////////////////////////////////////////////////////
//
// pong_game: the game itself!
//
////////////////////////////////////////////////////////////////////////////////

module pong_game (
   input vclock_in,        // 65MHz clock
   input reset_in,         // 1 to initialize module
   input up_in,            // 1 when paddle should move up
   input down_in,          // 1 when paddle should move down
   input [3:0] pspeed_in,  // puck speed in pixels/tick 
   input [10:0] hcount_in, // horizontal index of current pixel (0..1023)
   input [9:0]  vcount_in, // vertical index of current pixel (0..767)
   input hsync_in,         // XVGA horizontal sync signal (active low)
   input vsync_in,         // XVGA vertical sync signal (active low)
   input blank_in,         // XVGA blanking (1 means output black pixel)
        
   output phsync_out,       // pong game's horizontal sync
   output pvsync_out,       // pong game's vertical sync
   output pblank_out,       // pong game's blanking
   output [11:0] pixel_out  // pong game's pixel  // r=23:16, g=15:8, b=7:0 
   );

   //wire [2:0] checkerboard;
        
   // REPLACE ME! The code below just generates a color checkerboard
   // using 64 pixel by 64 pixel squares.
   
   assign phsync_out = hsync_in;
   assign pvsync_out = vsync_in;
   assign pblank_out = blank_in;
   //assign checkerboard = hcount_in[8:6] + vcount_in[8:6];

   // here we use three bits from hcount and vcount to generate the
   // checkerboard

   //assign pixel_out = {{4{checkerboard[2]}}, {4{checkerboard[1]}}, {4{checkerboard[0]}}} ;
     
endmodule



module synchronize #(parameter NSYNC = 3)  // number of sync flops.  must be >= 2
                   (input clk,in,
                    output reg out);

  reg [NSYNC-2:0] sync;

  always_ff @ (posedge clk)
  begin
    {out,sync} <= {sync[NSYNC-2:0],in};
  end
endmodule




//////////////////////////////////////////////////////////////////////////////////
// Update: 8/8/2019 GH 
// Create Date: 10/02/2015 02:05:19 AM
// Module Name: xvga
//
// xvga: Generate VGA display signals (1024 x 768 @ 60Hz)
//
//                              ---- HORIZONTAL -----     ------VERTICAL -----
//                              Active                    Active
//                    Freq      Video   FP  Sync   BP      Video   FP  Sync  BP
//   640x480, 60Hz    25.175    640     16    96   48       480    11   2    31
//   800x600, 60Hz    40.000    800     40   128   88       600     1   4    23
//   1024x768, 60Hz   65.000    1024    24   136  160       768     3   6    29
//   1280x1024, 60Hz  108.00    1280    48   112  248       768     1   3    38
//   1280x720p 60Hz   75.25     1280    72    80  216       720     3   5    30
//   1920x1080 60Hz   148.5     1920    88    44  148      1080     4   5    36
//
// change the clock frequency, front porches, sync's, and back porches to create 
// other screen resolutions
////////////////////////////////////////////////////////////////////////////////

module xvga(input vclock_in,
            output reg [10:0] hcount_out,    // pixel number on current line
            output reg [9:0] vcount_out,     // line number
            output reg vsync_out, hsync_out,
            output reg blank_out);

   parameter DISPLAY_WIDTH  = 1024;      // display width
   parameter DISPLAY_HEIGHT = 768;       // number of lines

   parameter  H_FP = 24;                 // horizontal front porch
   parameter  H_SYNC_PULSE = 136;        // horizontal sync
   parameter  H_BP = 160;                // horizontal back porch

   parameter  V_FP = 3;                  // vertical front porch
   parameter  V_SYNC_PULSE = 6;          // vertical sync 
   parameter  V_BP = 29;                 // vertical back porch

   // horizontal: 1344 pixels total
   // display 1024 pixels per line
   reg hblank,vblank;
   wire hsyncon,hsyncoff,hreset,hblankon;
   assign hblankon = (hcount_out == (DISPLAY_WIDTH -1));    
   assign hsyncon = (hcount_out == (DISPLAY_WIDTH + H_FP - 1));  //1047
   assign hsyncoff = (hcount_out == (DISPLAY_WIDTH + H_FP + H_SYNC_PULSE - 1));  // 1183
   assign hreset = (hcount_out == (DISPLAY_WIDTH + H_FP + H_SYNC_PULSE + H_BP - 1));  //1343

   // vertical: 806 lines total
   // display 768 lines
   wire vsyncon,vsyncoff,vreset,vblankon;
   assign vblankon = hreset & (vcount_out == (DISPLAY_HEIGHT - 1));   // 767 
   assign vsyncon = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP - 1));  // 771
   assign vsyncoff = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP + V_SYNC_PULSE - 1));  // 777
   assign vreset = hreset & (vcount_out == (DISPLAY_HEIGHT + V_FP + V_SYNC_PULSE + V_BP - 1)); // 805

   // sync and blanking
   wire next_hblank,next_vblank;
   assign next_hblank = hreset ? 0 : hblankon ? 1 : hblank;
   assign next_vblank = vreset ? 0 : vblankon ? 1 : vblank;
   always_ff @(posedge vclock_in) begin
      hcount_out <= hreset ? 0 : hcount_out + 1;
      hblank <= next_hblank;
      hsync_out <= hsyncon ? 0 : hsyncoff ? 1 : hsync_out;  // active low

      vcount_out <= hreset ? (vreset ? 0 : vcount_out + 1) : vcount_out;
      vblank <= next_vblank;
      vsync_out <= vsyncon ? 0 : vsyncoff ? 1 : vsync_out;  // active low

      blank_out <= next_vblank | (next_hblank & ~hreset);
   end
   
endmodule


