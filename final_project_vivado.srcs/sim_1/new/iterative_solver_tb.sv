`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2021 01:12:52 AM

// Module Name: iterative_solver_tb

// 
//////////////////////////////////////////////////////////////////////////////////


module iterative_solver_tb;

       // Inputs
       logic clk;
       
       logic reset_in;
       logic [19:0] assignment_in;
       logic [5:0] index_in;
       logic [3:0] column_number_in;
       logic [3:0] row_number_in;
       logic start_sending_nonogram;
       
       
       //out
       logic solution_out;

       
       iterative_solver uut(   
                    .clk_in(clk),
                   
                    .reset_in(reset_in),
                    .index_in(index_in), //idnex of row/col beign send - max is 20 so 6 bits
                    .column_number_in(column_number_in), //grid size - max 10
                    .row_number_in(row_number_in), //grid size - max 10
                    
                    .assignment_in(assignment_in), // array of cosntraitnrs in - max of 20 btis since 4 btis * 5 slots
                    
                    .start_sending_nonogram(start_sending_nonogram), //if asserted to 1, im in the rpcoess of sendifg the puzzle
                     //only for the sake of testing wheterh we saved things correctly in the test bench
                    .solution_out(solution_out)
       );
       
       //one_hz_period changed to 4 cycles so simulations don't take forever.


        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

       clk=0;
       
       reset_in=0;
       assignment_in=0;
       index_in=0;
       column_number_in=0;
       row_number_in=0;
       start_sending_nonogram=0;
       #100;
       reset_in = 1;

       #10;
       reset_in = 0;
       assignment_in =20'b00000000000000000011; //24
       index_in<=0;
       start_sending_nonogram =1;
       column_number_in=10;
       row_number_in=10;
      //get t_arm

       #10;

       assignment_in =20'b00000000000000100001; //14
       index_in<=1;
       #10;

       assignment_in =20'b000000000000_0011_0010; //24
       index_in<=2;
       #10;

       index_in<=3;
       assignment_in =20'b00000000000000100010;
       #10;

       index_in<=4;
       assignment_in = 20'b00000000000000000110;
       #10;

       index_in<=5;
       assignment_in = 20'b00000000000000010101;

       #10;


       index_in<=6;
       assignment_in =20'b00000000000000000110;



       #10;
       assignment_in =20'b00000000000000000001;
       

       
       index_in<=7;
       #10;
       assignment_in =20'b00000000000000000010; //24

       index_in<=8;
       #10;
       
       index_in<=9;
       //last row
       assignment_in =20'b0000000000000000000;


       #10;
//       assignment_in =20'b0000_0000_0000_0000_0000; //24
       index_in<=10;
       assignment_in =20'b00000000000000010010;
       
       #10;
       //assignment_in =20'b1000_0000_0000_0000_0000; //24
       assignment_in =20'b00000000000000110001;
       index_in<=11;
       #10;

       index_in<=12;
       assignment_in =20'b00000000000000010101;
       #10;

       index_in<=13;
        assignment_in =20'b00000000000001110001;
        #10;

       index_in<=14;
       assignment_in =20'b00000000000000000101;
       #10;

       index_in<=15;
       assignment_in =20'b00000000000000000011;
       #10;

       index_in<=16;
       assignment_in =20'b00000000000000000100;
       #10;

       index_in<=17;
       assignment_in =20'b00000000000000000011;
       #10;

       index_in<=18;
       assignment_in =20'b00000000000000000000;
       #10;

       index_in<=19;
       assignment_in =20'b00000000000000000000;
       #1000;
       
       
       end         



endmodule
