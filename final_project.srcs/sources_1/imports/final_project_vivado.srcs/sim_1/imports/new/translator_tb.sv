`timescale 1ns / 1ps

module translator_tb;

       // Inputs
        logic clk;
        logic reset_in;
        logic start_in;
        logic [19:0] row1;
        logic [19:0] row2;
        logic [19:0] row3;
        logic [19:0] row4;
        logic [19:0] row5;
        logic [19:0] row6;
        logic [19:0] row7;
        logic [19:0] row8;
        logic [19:0] row9;
        logic [19:0] row10;

        //output
        logic [9:0] row1_out;
        logic [9:0] row2_out;
        logic [9:0] row3_out;
        logic [9:0] row4_out;
        logic [9:0] row5_out;
        logic [9:0] row6_out;
        logic [9:0] row7_out;
        logic [9:0] row8_out;
        logic [9:0] row9_out;
        logic [9:0] row10_out;
        logic solution_out;

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
        translator uut(   
                    .clk_in(clk),
                    .reset_in(reset_in),
                    .start_in(start_in),
                    .row1(row1),
                    .row2(row2),
                    .row3(row3),
                    .row4(row4),
                    .row5(row5),
                    .row6(row6),
                    .row7(row7),
                    .row8(row8),
                    .row9(row9),
                    .row10(row10),
                    .row1_out(row1_out),
                    .row2_out(row2_out),
                    .row3_out(row3_out),
                    .row4_out(row4_out),
                    .row5_out(row5_out),
                    .row6_out(row6_out),
                    .row7_out(row7_out),
                    .row8_out(row8_out),
                    .row9_out(row9_out),
                    .row10_out(row10_out),

        
                    .done(solution_out)
                    
    ); 

        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

        clk = 0;

       
        reset_in = 0;
        start_in = 0;
        row1 = 0;
        row2 = 0;
        row3 = 0;
        row4 = 0;
        row5 = 0;
        row6 = 0;
        row7 = 0;
        row8 = 0;
        row9 = 0;
        row10 = 0;
        #100;

        //get t_arm
        reset_in = 1;


  
        #10;
        reset_in = 0;
        start_in = 1;
        row1 = 20'b1010_1010_1010_1010_1010;
        row2 = 20'b1010_0101_0101_0101_1010;
        row3 = 20'b1010_0101_0101_0101_1010;
        row4 = 20'b1010_0101_0101_0101_1010;
        row5 = 20'b1010_0101_0101_0101_1010;
        row6 = 20'b1010_0101_0101_0101_1010;
        row7 = 20'b1010_0101_0101_0101_1010;
        row8 = 20'b1010_0101_0101_0101_1010;
        row9 = 20'b1010_0101_0101_0101_1010;
        row10 = 20'b1010_1010_1010_1010_101;

        #10;
        reset_in = 0;
        start_in = 0;

        #10000;
        //test if it outputs again the same thing

        start_in = 1;
        row1 = 20'b1010_0101_0101_0101_1010;
        row2 = 20'b1010_0101_0101_0101_1010;
        row3 = 20'b1010_0101_0101_0101_1010;
        row4 = 20'b1010_0101_0101_0101_1010;
        row5 = 20'b1010_0101_0101_0101_1010;
        row6 = 20'b1010_0101_0101_0101_1010;
        row7 = 20'b1010_0101_0101_0101_1010;
        row8 = 20'b1010_0101_0101_0101_1010;
        row9 = 20'b1010_0101_0101_0101_1010;
        row10 = 20'b1010_0101_0101_0101_1010;
        #10;
        reset_in = 0;
        start_in = 0;
        

//        row1 = 20'b1010_1010_1010_1010_1010;
//        row2 = 20'b1010_0101_0101_0101_1010;
//        row3 = 20'b1010_0101_0101_0101_1010;
//        row4 = 20'b1010_0101_0101_0101_1010;
//        row5 = 20'b1010_0101_0101_0101_1010;
//        row6 = 20'b1010_0101_0101_0101_1010;
//        row7 = 20'b1010_0101_0101_0101_1010;
//        row8 = 20'b1010_0101_0101_0101_1010;
//        row9 = 20'b1010_0101_0101_0101_1010;
//        row10 = 20'b1010_1010_1010_1010_101;


   end
      
endmodule