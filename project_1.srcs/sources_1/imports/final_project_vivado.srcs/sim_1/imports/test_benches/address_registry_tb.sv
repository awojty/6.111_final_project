`timescale 1ns / 1ps

module address_registry_tb;

       // Inputs
       logic clk;
       logic confirm_in;
       logic rst_in;
       logic [5:0] index_in;
       
       //out
       logic [31:0] address_out;
       logic done;

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
        address_registry uut(   
                    .clk_in(clk),
                    .confirm_in(confirm_in),
                    .reset_in(rst_in),
                    .index_in(index_in),
                    .address_out(address_out),
                   .done_out(done)); 

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