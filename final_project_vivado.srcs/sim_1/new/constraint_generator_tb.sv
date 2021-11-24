`timescale 1ns / 1ps

module constraint_generator_tb;

       // Inputs
        logic clk;
        logic reset_in;
        logic start_in;
        logic [39:0] image_in [29:0] ;


        //output
        logic [119:0] constraints_out [69:0]

        logic done;

   
       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
        constraint_generator uut(   
                    .clk_in(clk),
                    .reset_in(reset_in),
                    .start_in(start_in), //when asserte, start accumulating
                    .image_in(image_in),
                    .constraints_out(constraints_out),
                    .done(done) //320 by 240
           
                    
    ); 

        always #5 clk = !clk;
   
        initial begin
        // Initialize Inputs

        clk = 0;
        reset_in = 0;
        start_in = 0;
        image_in[0] = 0;
        image_in[1] = 0;
        image_in[2] = 0;
        image_in[3] = 0;
        image_in[4] = 0;
        image_in[5] = 0;
        image_in[6] = 0;
        image_in[7] = 0;
        image_in[8] = 0;
        image_in[9] = 0;
        image_in[10] = 0;
        image_in[11] = 0;
        image_in[12] = 0;
        image_in[13] = 0;
        image_in[14] = 0;
        image_in[15] = 0;
        image_in[16] = 0;
        image_in[17] = 0;
        image_in[18] = 0;
        image_in[19] = 0;
        image_in[20] = 0;
        image_in[21] = 0;
        image_in[22] = 0;
        image_in[23] = 0;
        image_in[24] = 0;
        image_in[25] = 0;
        image_in[26] = 0;
        image_in[27] = 0;
        image_in[28] = 0;
        image_in[29] = 0;

        #100;

        //get t_arm
        reset_in = 1;
  
        #10;
        reset_in = 0;
        start_in = 1;

        image_in[0] = 0000000000000000000000000000000000000000;
        image_in[1] = 0000000000000000000000000000000000000000;
        image_in[2] = 0000000000000001000000000110000000000000;
        image_in[3] = 0000000000001000000000000000010000000000;
        image_in[4] = 0000000000000000000000000000000100000000;
        image_in[5] = 0000000010000000000000000000000000000000;
        image_in[6] = 0000000000000000000000000000000000000000;
        image_in[7] = 0000000000000011000000000011000000010000;
        image_in[8] = 0000000000000111100000000111100000000000;
        image_in[9] = 0000100000001111100000001111100000000000;
        image_in[10] = 0000000000001111100000001111100000000100;
        image_in[11] = 0001000000001111100000001111100000000000;
        image_in[12] = 0000000000000111100000000111100000000010;
        image_in[13] = 0010000000000011000000000111000000000010;
        image_in[14] = 0010000000000000000000000000000000000000;
        image_in[15] = 0010000000000000000000000000000000000000;
        image_in[16] = 0010000000000000000000000000000000000000;
        image_in[17] = 0010000000000000000000000000000000000010;
        image_in[18] = 0000000001000000000000000000000110000010;
        image_in[19] = 0000000001100000000000000000000100000000;
        image_in[20] = 0001000000010000000000000000001000000100;
        image_in[21] = 0000100000001100000000000000110000000000;
        image_in[22] = 0000000000000111000000000011000000001000;
        image_in[23] = 0000000000000000111000011100000000010000;
        image_in[24] = 0000000000000000000000000000000000100000;
        image_in[25] = 0000000010000000000000000000000000000000;
        image_in[26] = 0000000001000000000000000000000100000000;
        image_in[27] = 0000000000010000000000000000010000000000;
        image_in[28] = 0000000000000011000000000110000000000000;
        image_in[29] = 0000000000000000000000000000000000000000;


        


   end
      
endmodule