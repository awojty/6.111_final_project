`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 11/16/2021 01:12:52 AM

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
       logic get_output;
       logic [19:0] assignment_out;
       logic assignment_out_done;
       logic sending_assignment;

       
       top_level_solver uut(   
                    .clk_in(clk),
                    .start_in(start_in), // assered when in the correct stata
                    .sw(sw),
                    .reset_in(reset_in),
                    .get_output(get_output),
                    .assignment_out(assignment_out),
                    .assignment_out_done(assignment_out_done),
                    .sending_assignment(sending_assignment),
                    
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
       
       solved_disp dips (.clock(clk),
                         .reset(reset_in),
                         .solver_done(top_level_solver_done),
                         .memory_read_start(sending_assignment),
                         .constraint_vals(assignment_out),
                         .grid_vals1(row1_out),
                         .grid_vals2(row2_out),
                         .grid_vals3(row3_out),
                         .grid_vals4(row4_out),
                         .grid_vals5(row5_out),
                         .grid_vals6(row6_out),
                         .grid_vals7(row7_out),
                         .grid_vals8(row8_out),
                         .grid_vals9(row9_out),
                         .grid_vals10(row10_out),
                         .hcount(hcount),
                         .vcount(vcount),
                         .switch(switch),
                         .pixel_out(pixel_out)
                         );
//           input wire clk_in,
//    input wire start_in, // assered when in the correct stata
//    input wire reset_in,
//    input wire get_output,
//    input wire [15:0] sw,
//    output logic [19:0] assignment_out,
//    output logic [9:0] row1_out,
//    output logic [9:0] row2_out, 
//    output logic [9:0] row3_out, 
//    output logic [9:0] row4_out,
//    output logic [9:0] row5_out, 
//    output logic [9:0] row6_out,
//    output logic [9:0] row7_out, 
//    output logic [9:0] row8_out,
//    output logic [9:0] row9_out, 
//    output logic [9:0] row10_out, 
//    output logic top_level_solver_done,
//    output logic assignment_out_done
       
       //one_hz_period changed to 4 cycles so simulations don't take forever.


        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

       clk=0;
       
       sw = 0;
       start_in = 0;
       reset_in=0;
       get_output = 0;
       
       #100;
       reset_in = 1;

       #10;
       reset_in = 0;
       //start_in  = 1;
       //get_output = 0;

        sw = 0; // get nonogram at idnex 0
        
        #20;
        start_in  = 0;
        
        #20;
        get_output = 1;
        
        #210;
        get_output = 0;
        
        #600;
        
        start_in  = 1;
        
         #200;
         start_in  = 0;
        
        //assignment_out_done

       
       
       end         



endmodule