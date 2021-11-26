`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/16/2021 01:12:52 AM

// Module Name: iterative_solver_tb

// 
//////////////////////////////////////////////////////////////////////////////////


module top_level_nonogram_solver_tb;

       // Inputs
       logic clk;
       logic [15:0] sw;
       logic start_in;
       logic reset_in;

       //out
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
       
       logic top_level_solver_done;

       
       top_level_solver uut(   
                    .clk_in(clk),
                    .start_in(start_in), // assered when in the correct stata
                    .sw(sw),
                    .reset_in(reset_in),
                    
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
                    .top_level_solver_done(top_level_solver_done)
       );
       
       //one_hz_period changed to 4 cycles so simulations don't take forever.


        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

       clk=0;
       
       sw = 0;
       start_in = 0;
       reset_in=0;
       
       #100;
       reset_in = 1;

       #10;
       reset_in = 0;
       start_in  = 1;

        sw = 0; // get nonogram at idnex 0
        #10;

       
       
       end         



endmodule
