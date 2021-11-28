`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////

module assignment_registry_tb;

       // Inputs
       logic clk;
       logic confirm_in;
       logic rst_in;
       logic [7:0] row_number_in;
       logic [7:0] col_number_in;
       logic [31:0] address_in;


       //out
       logic [799:0] assignment_out;
       logic done;

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
        assignments_registry uut(   
                    .clk_in(clk),
                    .confirm_in(confirm_in),
                    .reset_in(rst_in),
                    .row_number_in(row_number_in),
                    .col_number_in(col_number_in),
                    .address_in(address_in),
                   .assignment_out(assignment_out),
                   .done(done)

    ); 

        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

        
        clk = 0;
               
       confirm_in=0;
       rst_in=0;
       row_number_in=0;
       col_number_in=0;
       address_in=0;
       
        #100;
        //get t_arm
        confirm_in=1;
        rst_in = 1;
        #10;
        
        
      // Add stimulus here

   end
      
endmodule