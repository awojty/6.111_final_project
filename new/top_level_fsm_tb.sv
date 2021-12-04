`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2021 08:23:52 PM
// Design Name: 
// Module Name: top_level_fsm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_level_fsm_tb;

    logic clk;
        logic reset_in;
        
        
        logic [15:0] sw;
        logic btnc;
        logic btnr;
        logic btnl;
        logic btnd;
        logic btnu;
        logic [7:0] ja;
        logic [2:0] jb;


        //output
        logic [119:0] constraints_out;

        logic done;

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
       top_level_fresher_fsm_testing uut(
           .clk_100mhz(clk),
           .sw(sw),
           .btnc(btnc), .btnu(btnu), .btnl(btnl), .btnr(btnr), .btnd(btnd),
           .ja(ja), //pixel data from camera
           .jb(jb)); //other data from camera (including clock return)


        always #5 clk = !clk;
   
        initial begin
        
        
        clk = 0;
       
        
        
        sw = 0;
        btnc = 0;
        btnr = 0;
        btnl = 0;
        btnd  = 0;
        btnu = 0 ;
        #10;
        sw[0] = 1;
        #10;
        sw[0] = 0;
        #10;
        
        #10;
        btnd <=1;
        
        #10;
        btnd  <=1;
        #20;
        btnc  <=1;
        btnd  <=0;
        #10;
        btnc  <=0;
        btnl  <=1;
        #10;
        btnl  <=0;
        
        
        
        end




endmodule
