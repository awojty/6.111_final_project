`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////

module get_permutations_tb;

       // Inputs
       logic clk;
       logic [5:0] index; //actual numebr of the nonogram selected by teh user
        logic btnc; //user confirms the slection of the nonogram 

       
       logic rst_in;



       //out
       logic [799:0] assignment_out2;
       logic done;
       logic sending;

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
    get_permutations uut(   
                    .clk_in(clk),
                    .index(index),
                    .btnc(btnc),
                    .rst_in(rst_in),
                    .assignment_out1(assignment_out2),
                    .done(done),
                    .sending(sending)

    ); 

        always #5 clk = !clk;
   
        initial begin
            // Initialize Inputs
            clk = 0;
            index = 0;
            btnc = 0;
            rst_in=0;

       
            #100;
            rst_in=1;
            #10;

            rst_in=0;
            btnc = 1; //confirm
            index = 0; //nonogram at index 0

            #500;// 25 clocl cycles just inc ase - technically 23 shoudl be no

            btnc = 1; //confirm
            index = 0; //nonogram at index 0
            #10;
            btnc = 0; //free the button (as the user would)
            #500;//




        
      // Add stimulus here

   end
      
endmodule