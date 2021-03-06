`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////

module assignment_registr_tb;

       // Inputs
       logic clk;
       logic confirm_in;
       logic rst_in;
       logic [7:0] row_number_in;
       logic [7:0] col_number_in;
       logic [15:0] address_in;


       //out
       logic [19:0] assignment_out;
       logic done;
       logic sending;

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
        assignments_registry uut(   
                    .clk_in(clk),
                    .start_in(confirm_in),
                    .reset_in(rst_in),
                    
                    
                    .address_in(address_in),
                   .assignment_out(assignment_out),
                   .done(done),
                   .sending(sending)

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
        address_in=16'b0000_000_000_000_000;
        
        rst_in = 1;
        #10;
        rst_in=0;
        confirm_in=1;
        
        
        
      // Add stimulus here

   end
      
endmodule