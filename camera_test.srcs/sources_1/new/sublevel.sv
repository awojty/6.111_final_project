//module sublevel(


//    input wire pclk_in,
//    input wire clk_in,
//    input wire vsync_in,
//    input wire href_in, 
//    input wire button_center_clean,
//    input wire [7:0] pixel_in,
//    input wire hcount,
//    input wire vcount,
     
//    output logic valid_pixel,
    
//    output logic [11:0] cam


//);

//logic frame_done_out;

//logic [15:0] output_pixels;
//logic [16:0] pixel_addr_in;
//    logic [16:0] pixel_addr_out;
//    logic [12:0] processed_pixels;
////    logic valid_pixel;
    


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



//    camera_read  my_camera(.p_clock_in(pclk_in),
//                          .vsync_in(vsync_in),
//                          .href_in(href_in),
//                          .button_press(button_center_clean),
//                          .p_data_in(pixel_in),
//                          .pixel_data_out(output_pixels),
//                          .pixel_valid_out(valid_pixel),
//                          .frame_done_out(frame_done_out));


//    always_ff @(posedge clk_65mhz) begin

//            if(((output_pixels[15:12] >>2) + (output_pixels[10:7]>>1) + (output_pixels[4:1]>>2))>5) begin
//                processed_pixels <= {4'b1111,4'b1111,4'b1111};
                
//            end else begin
//                processed_pixels <= {4'b0000,4'b0000,4'b0000};
            
//            end
       
            
//    end
    
//    assign pixel_addr_out = hcount+vcount*32'd320;
//    assign cam = ((hcount<320) &&  (vcount<240))?frame_buff_out:12'h111;
    




//endmodule