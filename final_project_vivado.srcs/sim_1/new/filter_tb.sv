`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2021 01:46:06 PM
// Design Name: 
// Module Name: filter_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module filter_tb;

//input
logic clk;
logic reset_in;
logic start_in;
logic [319:0] photo_in;

logic done;
logic outputing;
logic [39:0] rescaled_out;

//output

    filter uut(   
        .clk_in(clk),
         .reset_in(reset_in),
         .start_in(start_in), //when asserte, start accumulating
          .photo_in(photo_in)  ,
          .done(done), //320 by 240
          .outputing(outputing),
          .rescaled_out(rescaled_out)  //for the sake of testing // since thre are 10 fields and each field has two bits (3 states) > 10*2 = 20
    
        ); 
    
    
        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

        
        clk = 0;
               
       reset_in=0;
       start_in=0;
       photo_in=0;

        #100;
        //get t_arm
        
        reset_in = 1;
        #10;
        reset_in = 0;
        start_in =1;
        photo_in <= 0;
         #10;
         start_in =0;
       photo_in <= 0;
        #10;

        photo_in <= 0;
         #10;
        photo_in <= 0;
         #10;
         photo_in <=0;
         #10;
         photo_in <=0;
        #10;
         photo_in <=0;
         #10;
         photo_in <=0;
         #10;
         photo_in <=0;
         #10;
         photo_in <=0;
         #10;
         photo_in <=0;
         #10;
         photo_in <=319'h11111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=319'h1111111;
         #10;
         photo_in <=311;
         #10;
         photo_in <=319'h1111111;
      // Add stimulus here
      end




endmodule
