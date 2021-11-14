`timescale 1ns / 1ps

module generate_rows_tb;

       // Inputs
       logic clk;
       logic start_in;
       logic reset_in;
       logic [19:0] assignment;
       
       
       //out
       logic [31:0] address_out;
       logic done;
       logic [19:0] new_row;
       logic [6:0] count; //totoal number of rows returned

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
        get_rows uut(   
                    .clk_in(clk),
                    .start_in(start_in),
                    .reset_in(reset_in),
                    .assignment(assignment),
                    .done(done),
                    .new_row(new_row),
                    .count(count) //returns the tola nbumber of optison returend for a given setging
                   ); 

        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

        clk = 0;
        confirm_in = 0;
        rst_in = 0;
        index_in = 0;


        #100;
        //get t_arm
        confirm_in=1;
        rst_in = 1;
        #10;
        rst_in = 0;
        index_in = 0;
        #20
        confirm_in=0; // free the button 
        
        
      // Add stimulus here

   end
      
endmodule