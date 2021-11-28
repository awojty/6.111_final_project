////trying to inclde camer in the top level 

//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
////
//// Updated 8/10/2019 Lab 3
//// Updated 8/12/2018 V2.lab5c
//// Create Date: 10/1/2015 V1.0
//// Design Name:
//// Module Name: labkit
////
////////////////////////////////////////////////////////////////////////////////////

//module top_level_camera(
//   input clk_100mhz,
//   input[15:0] sw,
//   input btnc, btnu, btnl, btnr, btnd,
//   input [7:0] ja, //pixel data from camera
//   input [2:0] jb, //other data from camera (including clock return)
//   output   jbclk, //clock FPGA drives the camera with
//   input [2:0] jd,
//   output   jdclk,
//   output[3:0] vga_r,
//   output[3:0] vga_b,
//   output[3:0] vga_g,
//   output vga_hs,
//   output vga_vs,
//   output led16_b, led16_g, led16_r,
//   output led17_b, led17_g, led17_r,
//   output[15:0] led,
//   output ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
//   output[7:0] an    // Display location 0-7
//   );

   
//    logic clk_65mhz;
//    // create 65mhz system clock, happens to match 1024 x 768 XVGA timing
//    clk_wiz_lab3 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));

//    wire [31:0] data;      //  instantiate 7-segment display; display (8) 4-bit hex
//    wire [6:0] segments;
//    assign {cg, cf, ce, cd, cc, cb, ca} = segments[6:0];
//    display_8hex display(.clk_in(clk_65mhz),.data_in(data), .seg_out(segments), .strobe_out(an));
//    //assign seg[6:0] = segments;
//    assign  dp = 1'b1;  // turn off the period

//    assign led = sw;                        // turn leds on
//    assign data = {28'h0123456, sw[3:0]};   // display 0123456 + sw[3:0]
////    assign led16_r = btnl;                  // left button -> red led
//    assign led16_g = btnc;                  // center button -> green led
//    assign led16_b = btnr;                  // right button -> blue led
//    assign led17_r = btnl;
//    assign led17_g = btnc;
//    assign led17_b = btnr;

//    wire [10:0] hcount;    // pixel on current line
//    wire [9:0] vcount;     // line number
//    wire hsync, vsync, blank;
//    wire [11:0] pixel;
//    reg [11:0] rgb;    
//    xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
//          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));


//    // btnc button is user reset
//    wire reset;
//    debounce db1(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(reset));
   
   
//    logic xclk;
//    logic[1:0] xclk_count;
    
//    logic pclk_buff, pclk_in;
//    logic vsync_buff, vsync_in;
//    logic href_buff, href_in;
//    logic[7:0] pixel_buff, pixel_in;
    
//    logic [11:0] cam;
//    logic [11:0] frame_buff_out;
//    logic [15:0] output_pixels;
//    logic [15:0] old_output_pixels;
//    logic [12:0] processed_pixels;
//    logic [3:0] red_diff;
//    logic [3:0] green_diff;
//    logic [3:0] blue_diff;
//    logic valid_pixel;
//    logic frame_done_out;
    
//    logic [16:0] pixel_addr_in;
//    logic [16:0] pixel_addr_out;
    
//    assign xclk = (xclk_count >2'b01);
//    assign jbclk = xclk;
//    assign jdclk = xclk;
    
//    assign red_diff = (output_pixels[15:12]>old_output_pixels[15:12])?output_pixels[15:12]-old_output_pixels[15:12]:old_output_pixels[15:12]-output_pixels[15:12];
//    assign green_diff = (output_pixels[10:7]>old_output_pixels[10:7])?output_pixels[10:7]-old_output_pixels[10:7]:old_output_pixels[10:7]-output_pixels[10:7];
//    assign blue_diff = (output_pixels[4:1]>old_output_pixels[4:1])?output_pixels[4:1]-old_output_pixels[4:1]:old_output_pixels[4:1]-output_pixels[4:1];

    
    
//    blk_mem_gen_0 jojos_bram(.addra(pixel_addr_in), 
//                             .clka(pclk_in),
//                             .dina(processed_pixels),
//                             .wea(valid_pixel),
//                             .addrb(pixel_addr_out),
//                             .clkb(clk_65mhz),
//                             .doutb(frame_buff_out));
    
//    always_ff @(posedge pclk_in)begin
//        if (frame_done_out)begin
//            pixel_addr_in <= 17'b0;  
//        end else if (valid_pixel)begin
//            pixel_addr_in <= pixel_addr_in +1;  
//        end
//    end


//    logic [319:0] digi_photo [239:0];
    
//    always_ff @(posedge clk_65mhz) begin
//        pclk_buff <= jb[0];//WAS JB
//        vsync_buff <= jb[1]; //WAS JB
//        href_buff <= jb[2]; //WAS JB
//        pixel_buff <= ja;
//        pclk_in <= pclk_buff;
//        vsync_in <= vsync_buff;
//        href_in <= href_buff;
//        pixel_in <= pixel_buff;
//        old_output_pixels <= output_pixels;
//        xclk_count <= xclk_count + 2'b01;
//        if(((output_pixels[15:12] >>2) + (output_pixels[10:7]>>1) + (output_pixels[4:1]>>2))>5) begin
//                processed_pixels <= {4'b1111,4'b1111,4'b1111};
//                if((hcount<320) &&  (vcount<240)) begin
//                    digi_photo[vcount][hcount] <=0;
//                end
                
                
//        end else begin
//                processed_pixels <= {4'b0000,4'b0000,4'b0000};
//                if((hcount<320) &&  (vcount<240)) begin
//                    digi_photo[vcount][hcount] <=1;
//                end
            
//        end

            
//    end




//    assign pixel_addr_out = sw[2]?((hcount>>1)+(vcount>>1)*32'd320):hcount+vcount*32'd320;
//    assign cam = sw[2]&&((hcount<640) &&  (vcount<480))?frame_buff_out:~sw[2]&&((hcount<320) &&  (vcount<240))?frame_buff_out:12'h000;
    

                                        
//   camera_read  my_camera(.p_clock_in(pclk_in),
//                          .vsync_in(vsync_in),
//                          .href_in(href_in),
//                          .p_data_in(pixel_in),
//                          .pixel_data_out(output_pixels),
//                          .pixel_valid_out(valid_pixel),
//                          .frame_done_out(frame_done_out));
   
//    // UP and DOWN buttons for pong paddle
//    wire up,down;
//    debounce db2(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnu),.clean_out(up));
//    debounce db3(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnd),.clean_out(down));

//    wire phsync,pvsync,pblank;
//    pong_game pg(.vclock_in(clk_65mhz),.reset_in(reset),
//                .up_in(up),.down_in(down),.pspeed_in(sw[15:12]),
//                .hcount_in(hcount),.vcount_in(vcount),
//                .hsync_in(hsync),.vsync_in(vsync),.blank_in(blank),
//                .phsync_out(phsync),.pvsync_out(pvsync),.pblank_out(pblank),.pixel_out(pixel));

//    wire border = (hcount==0 | hcount==1023 | vcount==0 | vcount==767 |
//                   hcount == 512 | vcount == 384);

//    reg b,hs,vs;


//    logic press_button;


//    logic start_something;

//    fake_module m(

//            .clk_in(clk_65mhz),
//            .reset_in(reset),
//            .sth(btnr),
//            .on(led16_r));
            
//            // click btnr 4 times - red led should light up
//            //if left button is pressed - it shoudl change the image frmo white to black and vice versa




//    always_ff @(posedge clk_65mhz) begin

//        //ff block for selcting pixel

//        if(reset) begin
//            start_something<=0;
//            press_button <=0;
//        end

//        if(btnl) begin
//            press_button <= ~press_button;
//        end

//        if(btnd) begin
//            start_something <= ~start_something;
//        end


//      if (sw[1:0] == 2'b01) begin
//         // 1 pixel outline of visible area (white)
//         hs <= hsync;
//         vs <= vsync;
//         b <= blank;
//         rgb <= {12{border}};
//      end else if (sw[1:0] == 2'b10) begin
//         // color bars
//         hs <= hsync;
//         vs <= vsync;
//         b <= blank;
//         rgb <= {{4{hcount[8]}}, {4{hcount[7]}}, {4{hcount[6]}}} ;
//      end else begin
//         // default: pong

//         start_something <=1;

         
//            hs <= phsync;
//            vs <= pvsync;
//            b <= pblank;
//            //rgb <= pixel;
//            rgb <= cam;
//        end

//      end
    

////    assign rgb = sw[0] ? {12{border}} : pixel ; //{{4{hcount[7]}}, {4{hcount[6]}}, {4{hcount[5]}}};

//    // the following lines are required for the Nexys4 VGA circuit - do not change
//    assign vga_r = ~b ? rgb[11:8]: 0;
//    assign vga_g = ~b ? rgb[7:4] : 0;
//    assign vga_b = ~b ? rgb[3:0] : 0;

//    assign vga_hs = ~hs;
//    assign vga_vs = ~vs;

//endmodule

//////////////////////////////////////////////////////////////////////////////////
////
//// pong_game: the game itself!
////
//////////////////////////////////////////////////////////////////////////////////


