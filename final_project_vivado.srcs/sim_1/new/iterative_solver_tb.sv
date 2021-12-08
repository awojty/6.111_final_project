`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
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

       
       iterative_solver_wth_reset uut(   
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
       
       index_in<=0;
       
       start_sending_nonogram =1;
       column_number_in=10;
       row_number_in=10;
       
       


   
       //assignment_in =20'b00000000000000000011;//
       assignment_in =20'b0000000000000000_0000;
       index_in<=0;
       #10;
       
       
        //assignment_in =20'b00000000000000010010;//
        assignment_in =20'b000000000000_0010_0100;//
        index_in<=1;
       #10;
       
    assignment_in =20'b000000000000_0001_0100;//
        index_in<=2;
       #10;
       
    assignment_in =20'b000000000000_0001_0101;//
        index_in<=3;
       #10;
       
    assignment_in =20'b0000000000000000_1010;//
        index_in<=4;
       #10;
       
    assignment_in =20'b0000000000000000_1000;//
        index_in<=5;
       #10;
       
    assignment_in =20'b0000000000000000_1000;//
        index_in<=6;
       #10;
       
    assignment_in =20'b0000_0000_0000_0000_1000;//
        index_in<=7;
       #10;
       
    assignment_in =20'b0000000000000000_1000;//
        index_in<=8;
       #10;
       
    assignment_in =20'b000000000000_0101_0100;//
        index_in<=9;
       #10;
       
    assignment_in =20'b000000000000_0001_0010;//
        index_in<=10;
       #10;
       
    assignment_in =20'b000000000000_0001_0100;//
    
        index_in<=11;
       #10;
       
    assignment_in =20'b00000000000000001001;//
        index_in<=12;
       #10;
       
    assignment_in =20'b00000000000000001001;//
        index_in<=13;
       #10;
       
    assignment_in =20'b00000000000000001000;//
        index_in<=14;
       #10;
       
    assignment_in =20'b00000000000000000110;//
        index_in<=15;
       #10;
       
    assignment_in =20'b00000000000000000110;
        index_in<=16;
       #10;
       
    assignment_in =20'b0000_0000_0000_0000_0110;
        index_in<=17;
       #10;
       
    assignment_in =20'b00000000000001100001;
        index_in<=18;
       #10;
       
    assignment_in =20'b0000_0000_0000_0000_1001;
        index_in<=19;
        
        
        
        
        
        
        
        
        
        
        //////////////////////////////////////////////
       #40;
       start_sending_nonogram =0;
       
       

       #10000;
       
       //NEW_INPUT
       
      
       reset_in = 0;
       
       
       start_sending_nonogram =1;
       column_number_in=10;
       row_number_in=10;
       //assignment_in =20'b00000000000000000011;//
       assignment_in =20'b00000000000000000000;
       index_in<=0;
       #10;
       
        //assignment_in =20'b00000000000000010010;//
        assignment_in =20'b000000000000000001000;//
        index_in<=1;
       #10;
       
    assignment_in =20'b0000000000000000001000;//
        index_in<=2;
       #10;
       
    assignment_in =20'b0000000000000001000;//
        index_in<=3;
       #10;
       
    assignment_in =20'b00000000000000001000;//
        index_in<=4;
       #10;
       
    assignment_in =20'b0000000000000001000;//
        index_in<=5;
       #10;
       
    assignment_in =20'b00000000000000001000;//
        index_in<=6;
       #10;
       
    assignment_in =20'b0000000000000001000;//
        index_in<=7;
       #10;
       
    assignment_in =20'b00000000000000001000;//
        index_in<=8;
       #10;
       
    assignment_in =20'b00000000000000000000;//
        index_in<=9;
       #10;
       
    assignment_in =20'b00000000000000000000;//
        index_in<=10;
       #10;
       
    assignment_in =20'b0000000000000001000;//
        index_in<=11;
       #10;
       
    assignment_in =20'b000000000000001000;//
        index_in<=12;
       #10;
       
    assignment_in =20'b0000000000000001000;//
        index_in<=13;
       #10;
       
    assignment_in =20'b0000000000000001000;//
        index_in<=14;
       #10;
       
    assignment_in =20'b0000000000000001000;//
        index_in<=15;
       #10;
       
    assignment_in =20'b00000000000000001000;
        index_in<=16;
       #10;
       
    assignment_in =20'b0000000000000001000;
        index_in<=17;
       #10;
       
    assignment_in =20'b00000000000000001000;
        index_in<=18;
       #10;
       
    assignment_in =20'b00000000000000000000;
        index_in<=19;
       #40;
       start_sending_nonogram =0;
       
       
       
       end         



endmodule