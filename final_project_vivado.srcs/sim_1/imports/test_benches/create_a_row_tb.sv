`timescale 1ns / 1ps

module get_permutations_tb;

       // Inputs
       logic clk;
       
       logic reset_in;
       logic new_data;

       logic [3:0] constrain1;
       logic [3:0] constrain2;
       logic [3:0] constrain3;
       logic [3:0] constrain4;
       logic [3:0] constrain5;
       logic [2:0] number_of_constraints;
       logic [2:0] break1;
       logic [2:0] break2;
       logic [2:0] break3;
       logic [2:0] break4;
       
       //out
       
       logic done;
       logic [11:0] assignment_out;
       logic [4:0] min_length;
   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
        create_a_row uut(
            .clk_in(clk_in),
            .reset_in(reset_in), 
            .new_data(new_data),
            .constrain1(constrain1),
            .constrain2(constrain2),
            .constrain3(constrain3),
            .constrain4(constrain4),
            .constrain5(constrain5),
            .number_of_constraints(number_of_constraints),
            .break1(break1),
            .break2(break2),
            .break3(break3),
            .break4(break4),
            .assignment_out(assignment_out), // 2- bit row output sic eeach cell encode by 2 bits
            .done(done),
            .min_length(min_length)
            );

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