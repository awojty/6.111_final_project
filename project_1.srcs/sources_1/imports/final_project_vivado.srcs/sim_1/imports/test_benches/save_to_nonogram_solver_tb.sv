//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//module save_to_nonogram_solver_tb;

//       // Inputs
//       logic clk;
//       logic confirm_in;
//       logic rst_in;
//       logic [7:0] row_number_in;
//       logic [7:0] col_number_in;
//       logic [31:0] address_in;

//       logic testing;


//       //out
//       logic [799:0] assignment_out;
//       logic done;
//       logic solution_out;

   
//       // Instantiate the Unit Under Test (UUT)
//       //one_hz_period changed to 4 cycles so simulations don't take forever.
//      solver_iterative uut(   
//                     input wire clk_in,
                   
//                    input wire reset_in,
//                    input wire [7:0] index_in,
//                    input wire [7:0] col_number_in,
//                    input wire [7:0] row_number_in,
//                    input wire [31:0] address_in,
//                    input wire [799:0] assignment_in,
//                    input wire [31:0] counter_in,
//                    input wire start_sending_nonogram,
//                    .testing(testing), //only for the sake of testing wheterh we saved things correctly in the test bench
//                    .solution_out(solution_out),
//                    .assignment_out(assignment_out)


//    ); 


//    nonogram_registry(   
//                    input wire clk_in,
//                    input wire [5:0] index,
//                    input wire btnc,
//                    input wire rst_in,
//                    output logic [799:0] assignment_out,
//                    output logic done
//    );  

//        always #5 clk = !clk;
   
//        initial begin
//        // Initialize Inputs

        
//        clk = 0;
               
//       confirm_in=0;
//       rst_in=0;
//       row_number_in=0;
//       col_number_in=0;
//       address_in=0;
       
//        #100;
//        //get t_arm
//        confirm_in=1;
//        rst_in = 1;
//        #10;
        
        
//      // Add stimulus here

//   end
      
//endmodule