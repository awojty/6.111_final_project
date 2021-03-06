`timescale 1ns / 1ps

module get_permutations_tb;

       // Inputs
       logic clk;
       logic confirm_in;
       logic rst_in;
       
       logic [2:0] number_of_breaks;
       logic [2:0] space_to_fill_left;
       
       //out
       
       logic done;
       logic [11:0] permutation_out;
       logic [5:0] total_counter;
   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
        get_permutations uut(   
                    .clk_in(clk),
                    .start_in(confirm_in),
                    .reset_in(rst_in),
                    .number_of_breaks_in(number_of_breaks),
                    .space_to_fill_in(space_to_fill_left),
                    .permutation_out(permutation_out),
                    .total_counter(total_counter),
                   .done(done)); 

        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

        clk = 0;
        confirm_in = 0;
        rst_in = 0;
        
        number_of_breaks = 0;
        space_to_fill_left =0;

        #100;
        //get t_arm
        rst_in = 1;

        #10;
        rst_in = 0;
        confirm_in=1; // free the button 
        
        number_of_breaks = 3'd2;
        space_to_fill_left = 3'd5;
        
        #10;
        confirm_in=0; 
        #200;


        
        
      // Add stimulus here

   end
      
endmodule