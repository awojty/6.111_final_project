`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//dispalys the correct thing and also saves in digi photo
// Updated 8/10/2019 Lab 3
// Updated 8/12/2018 V2.lab5c
// Create Date: 10/1/2015 V1.0
// Design Name:
// Module Name: labkit
//
//////////////////////////////////////////////////////////////////////////////////

module top_level_fresher(
   input clk_100mhz,
   input[15:0] sw,
   input btnc, btnu, btnl, btnr, btnd,
   input [7:0] ja, //pixel data from camera
   input [2:0] jb, //other data from camera (including clock return)
   output   jbclk, //clock FPGA drives the camera with
   input [2:0] jd,
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
   output[7:0] an    // Display location 0-7
   );
   
    logic something;
    logic on;
    logic [319:0] digi_photo [219:0];
    logic [39:0] rescaled_out;
    
    logic clk_65mhz;
    // create 65mhz system clock, happens to match 1024 x 768 XVGA timing
    clk_wiz_lab3 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));

    wire [31:0] data;      //  instantiate 7-segment display; display (8) 4-bit hex
    wire [6:0] segments;
    assign {cg, cf, ce, cd, cc, cb, ca} = segments[6:0];
    display_8hex display(.clk_in(clk_65mhz),.data_in(data), .seg_out(segments), .strobe_out(an));
    //assign seg[6:0] = segments;
    assign  dp = 1'b1;  // turn off the period

    assign led = sw;                        // turn leds on
    assign data = {state};   // display 0123456 + sw[3:0]
    assign led16_r = btnl;                  // left button -> red led
    assign led16_g = btnc;                  // center button -> green led
    assign led16_b = btnr;                  // right button -> blue led
    assign led17_r = btnl;
    assign led17_g = btnc;
    assign led17_b = on;

    wire [10:0] hcount;    // pixel on current line
    wire [9:0] vcount;     // line number
    wire hsync, vsync, blank;
    wire [11:0] pixel;
    reg [11:0] rgb;    
    xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));


    // btnc button is user reset
    wire reset;
    debounce db1(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(reset));
   
   
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
    logic [3:0] red_diff;
    logic [3:0] green_diff;
    logic [3:0] blue_diff;
    logic valid_pixel;
    logic frame_done_out;
    
    logic [16:0] pixel_addr_in;
    logic [16:0] pixel_addr_out;
    
    assign xclk = (xclk_count >2'b01);
    assign jbclk = xclk;
    assign jdclk = xclk;
    
    assign red_diff = (output_pixels[15:12]>old_output_pixels[15:12])?output_pixels[15:12]-old_output_pixels[15:12]:old_output_pixels[15:12]-output_pixels[15:12];
    assign green_diff = (output_pixels[10:7]>old_output_pixels[10:7])?output_pixels[10:7]-old_output_pixels[10:7]:old_output_pixels[10:7]-output_pixels[10:7];
    assign blue_diff = (output_pixels[4:1]>old_output_pixels[4:1])?output_pixels[4:1]-old_output_pixels[4:1]:old_output_pixels[4:1]-output_pixels[4:1];

    
    
    blk_mem_gen_0 jojos_bram(.addra(pixel_addr_in), 
                             .clka(pclk_in),
                             .dina(processed_pixels),
                             .wea(valid_pixel),
                             .addrb(pixel_addr_out),
                             .clkb(clk_65mhz),
                             .doutb(frame_buff_out));
    
    always_ff @(posedge pclk_in)begin
        if (frame_done_out)begin
            pixel_addr_in <= 17'b0;  
        end else if (valid_pixel)begin
            pixel_addr_in <= pixel_addr_in +1;  
        end
    end
    
    always_ff @(posedge clk_65mhz) begin
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
        if (sw[3])begin
            //processed_pixels <= {red_diff<<2, green_diff<<2, blue_diff<<2};
            processed_pixels <= output_pixels - old_output_pixels;
        end else if (sw[4]) begin
            if ((output_pixels[15:12]>4'b1000)&&(output_pixels[10:7]<4'b1000)&&(output_pixels[4:1]<4'b1000))begin
                processed_pixels <= 12'hF00;
            end else begin
                processed_pixels <= 12'h000;
            end
        end else if (sw[5]) begin
            if ((output_pixels[15:12]<4'b1000)&&(output_pixels[10:7]>4'b1000)&&(output_pixels[4:1]<4'b1000))begin
                processed_pixels <= 12'h0F0;
            end else begin
                processed_pixels <= 12'h000;
            end
        end else if (sw[6]) begin
            if ((output_pixels[15:12]<4'b1000)&&(output_pixels[10:7]<4'b1000)&&(output_pixels[4:1]>4'b1000))begin
                processed_pixels <= 12'h00F;
            end else begin
                processed_pixels <= 12'h000;
            end
        end else begin
        
             if(((output_pixels[15:12] >>2) + (output_pixels[10:7]>>1) + (output_pixels[4:1]>>2))>5) begin
                 processed_pixels <= {4'b1111,4'b1111,4'b1111}; //white
                 if((hcount<320) &&  (vcount<240)) begin
                    digi_photo[vcount][hcount] <=0;
                 end
                 
                
             end else begin
                 processed_pixels <= {4'b0000,4'b0000,4'b0000};
                 if((hcount<320) &&  (vcount<240)) begin
                    digi_photo[vcount][hcount] <=1; //black
                 end
            
             end
        
        
        
        
            //processed_pixels = {output_pixels[15:12],output_pixels[10:7],output_pixels[4:1]};
        end
            
    end
    assign pixel_addr_out = sw[2]?((hcount>>1)+(vcount>>1)*32'd320):hcount+vcount*32'd320;
    assign cam = sw[2]&&((hcount<640) &&  (vcount<480))?frame_buff_out:~sw[2]&&((hcount<320) &&  (vcount<240))?frame_buff_out:12'h000;
    

                                        
   camera_read_fresh  my_camera(.p_clock_in(pclk_in),
                          .vsync_in(vsync_in),
                          .href_in(href_in),
                          .p_data_in(pixel_in),
                          .button_press(up),
                          .pixel_data_out(output_pixels),
                          .pixel_valid_out(valid_pixel),
                          .frame_done_out(frame_done_out));
   
    // UP and DOWN buttons for pong paddle
    wire up,down,left,right;
    debounce db2(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnu),.clean_out(up));
    debounce db3(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnd),.clean_out(down));
    debounce db4(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnl),.clean_out(left));
    debounce db5(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnr),.clean_out(right));

    wire phsync,pvsync,pblank;
    logic [11:0] fake_pixel;
    logic [119:0] constraint_generator_storage [69:0];

    wire border = (hcount==0 | hcount==1023 | vcount==0 | vcount==767 |
                   hcount == 512 | vcount == 384);
                   
    logic filter_outputing;
    logic filter_done;
    logic start_filter;
    logic generator_done, start_generator;
    logic [39:0] constrain_input;
                   
                   
                   
//   fake_module(.clk_in(clk_65mhz), .reset_in(reset), .sth(something), .on(on), .pixel_out(fake_pixel), .done(generator_done));
    
   constraint_generator my_constraint_generator(   
                    .clk_in(clk_65mhz),
                    .reset_in(reset),
                    .start_in(start_generator), //when asserte, start accumulating
                    .image_in(constrain_input),
                    .constraints_out(constraint_generator_returned),
                      .outputing(generator_outputing),
                    .done(generator_done) //320 by 240

    ); 


    
    
    filter my_filter(   
                    .clk_in(clk_65mhz),
                    .reset_in(reset),
                    .start_in(start_filter), //when asserte, start accumulating
                    .photo_in(digi_photo_row) ,
                    .done(filter_done), //320 by 240
                    .outputing(filter_outputing),
                    .rescaled_out(rescaled_out) //for the sake of testing // since thre are 10 fields and each field has two bits (3 states) > 10*2 = 20

    ); 

    logic [319:0] digi_photo_row;
    logic [39:0] rescaled_photo_stored [29:0];

    reg b,hs,vs;
    logic [31:0] state;
    
    parameter CALL_GENERATOR = 4'b0001;
    parameter DISPLAY_EMPTY_NONOGRAM = 4'b0010;
    parameter START_FILTER = 4'b0100;
    
    

    logic [8:0] index;
 logic [8:0] index_rescale;
 logic started_filter;
 logic [7:0] index_c;
 logic generator_outputing;
 logic generator_started;
 logic [9:0] i;
    
    always_ff @(posedge clk_65mhz) begin
    
        if(reset) begin
            state <=0;
            index <=0;
            index_rescale <=0;
            started_filter <= 0;
            index_c <=0;
            generator_started <=0;
            i<=0;
        end
        
        rgb <= fake_pixel;
        hs <= hsync;
        vs <= vsync;
        b <= blank;


    
        if(sw[1] == 1) begin
        
        //return an ampty nonogram to solve manually
            something <=1;
            hs <= hsync;
            vs <= vsync;
            b <= blank;
         //rgb <= pixel;
         
        end else if (sw[2] == 1) begin
            // start generator
            hs <= hsync;
            vs <= vsync;
            b <= blank;
            
            if (left) begin
                state <= START_FILTER;
            end
            
            if (state == START_FILTER) begin
                rgb <= fake_pixel;
                start_filter <=1;
                

                if(index < 240) begin
                    started_filter <=1;
                    digi_photo_row <= digi_photo[index];
                    index <=index +1;
                    rgb <= 12'b000011110000;
                end 

                if (index >= 240) begin
                    start_filter <=0;
                end
                
                if(filter_outputing) begin

                    rescaled_photo_stored[index_rescale] <= rescaled_out;
                    index_rescale <=index_rescale +1;
                    
                    rgb <= 12'b000000001111;
                    start_filter <=0;
                
                end
                
                if(filter_done && started_filter) begin
                    index <= 0;
                    started_filter <= 0;
                    
                    state<= CALL_GENERATOR;
                    start_filter <=0;
                    index_rescale <=0;
                    rgb <= 12'b111010101010;
                end
                
            end else if (state == CALL_GENERATOR) begin
                start_generator <=1;
                
                rgb <= 12'b111100001111;
                
                 if(index < 30) begin
                    generator_started <=1;
                    constrain_input <= rescaled_photo_stored[index];
                    index <=index +1;
                    rgb <= 12'b000011110000;
                end 

                if (index >= 30) begin
                    start_generator <=0;
                end
                
                if(generator_outputing) begin
                    constraint_generator_storage[index_c] <=constraint_generator_returned;
                    index_c <=index_c +1;
                       rgb <= 12'b111011110000;
                    
                end
                
                
                if(generator_done && generator_started) begin
                    index <=0;
                    generator_started <=0;
                    index_c <=0;
                    state <= DISPLAY_EMPTY_NONOGRAM;
                end
                
                
            end else if (state == DISPLAY_EMPTY_NONOGRAM) begin
            
                rgb <= 12'b111100000000;
                
            end else begin
                rgb <= cam;

            end
            
        end else if (sw[3] == 1)begin
            rgb <= cam;
            state <= constraint_generator_storage[i];
                
            if(down) begin
                i <= i+1;
            end
                

        end else begin

              something <=1;
              hs <= hsync;
              vs <= vsync;
              b <= blank;
              
             
        end
     end

      

      
   

//    assign rgb = sw[0] ? {12{border}} : pixel ; //{{4{hcount[7]}}, {4{hcount[6]}}, {4{hcount[5]}}};

    // the following lines are required for the Nexys4 VGA circuit - do not change
    assign vga_r = ~b ? rgb[11:8]: 0;
    assign vga_g = ~b ? rgb[7:4] : 0;
    assign vga_b = ~b ? rgb[3:0] : 0;

    assign vga_hs = ~hs;
    assign vga_vs = ~vs;

endmodule

////////////////////////////////////////////////////////////////////////////////
//
// pong_game: the game itself!
//
////////////////////////////////////////////////////////////////////////////////



