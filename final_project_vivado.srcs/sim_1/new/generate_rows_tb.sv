`timescale 1ns / 1ps

module generate_rows_tb;

       // Inputs
       logic clk;
       logic start_in;
       logic reset_in;
       logic [19:0] assignment;
       
       
       //out
       logic outputing;
       logic done;
       logic [19:0] new_row;
       logic [6:0] count; //totoal number of rows returned
       logic [6:0] total_count;

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
        generate_rows uut(   
                    .clk_in(clk),
                    .start_in(start_in),
                    .reset_in(reset_in),
                    .assignment(assignment),
                   .done(done),
                    .outputing(outputing), //asserted when the new_row is ready on the output (fully)
                    .new_row(new_row),
                    .count(count), //current index of the row in the set of that we are oging to return 
                    .total_count(total_count) //returns the tola nbumber of optison returend for a given setging
                   ); 

        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

         clk =0;
         start_in =0;
         reset_in = 0;
         assignment =0 ;


        #100;
         reset_in = 1;

         #10;
         reset_in = 0;
         assignment =20'b0000_0000_0000_0000_1000; //8
         start_in =1;
         //get t_arm
         
         #10;
         start_in =0;

        
      // Add stimulus here

   end
      
endmodule