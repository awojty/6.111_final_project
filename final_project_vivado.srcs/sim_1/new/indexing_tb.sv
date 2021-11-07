`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////

module indexing_tb;

       // Inputs
       logic clk;
       logic [4:0] index; //actual numebr of the nonogram selected by teh user
        logic btnc; //user confirms the slection of the nonogram 

       
       logic rst_in;
       logic [10:0] array_in;



       //out
       
       logic done;
       logic  y_out;

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
    fir31 uut(
          .clk_in(clk), .rst_in(rst_in),
          .index_in(index),
          .y_out(y_out),
          .array_in(array_in)
    );

        always #5 clk = !clk;
   
        initial begin
            // Initialize Inputs
            clk = 0;
            index = 0;
            btnc = 0;
            rst_in=0;
            array_in = 11'b0;

       
            #100;
            rst_in=1;
            #10;
            array_in = 10'b1010101011;

            rst_in=0;
            btnc = 1; //confirm
            index = 0; //nonogram at index 0

            #500;// 25 clocl cycles just inc ase - technically 23 shoudl be no

            btnc = 1; //confirm
            index = 1; //nonogram at index 0
            #10;
            btnc = 0; //free the button (as the user would)
            #500;//




        
      // Add stimulus here

   end
      
endmodule