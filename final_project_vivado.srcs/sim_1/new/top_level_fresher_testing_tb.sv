`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module top_level_fresher_testing_tb;

           // Inputs
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
        logic [12:0] hcount;
        logic [12:0] vcount;

        //output
        logic [119:0] constraints_out;

        logic done;


       // Instantiate the Unit Under Test (UUT)
       //one_hz_period changed to 4 cycles so simulations don't take forever.
       top_level_fresher_testing uut(
                .clk_100mhz(clk),
                .sw(sw),
                .btnc(btnc), .btnu(btnu), .btnl(btnl), .btnr(btnr), .btnd(btnd),
                .hcount(hcount), .vcount(vcount),
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
        sw[2:1] = 2'b11;

        #10;
        btnc <=1;
        #10;
        btnc <=0;

        #10;
        btnl <=1;

        #10;
        btnl <=0;
        
        #50;
        vcount = 240;
        hcount=320;
        #10;
        hcount=336;
        #10;
        hcount=352;
        #10;
        hcount=368;
        #10;
        hcount=384;
        #10;
        hcount=400;
        #10;
        hcount=416;
        #10;
        hcount=432;
        #10;
        hcount=448;
        #10;
        hcount=464;
        #10;
        hcount=480;
        #10;
        hcount=496;
        #10;
        hcount=512;
        #10;
        hcount=528;
        #10;
        hcount=544;
        #10;
        hcount=560;
        #10;
        hcount=576;
        #10;
        hcount=592;
        #10;
        hcount=608;
        #10;
        hcount=624;
        #10;
        hcount=640;
        #10
        hcount=656;
        #10
        hcount=672;
        #10;
        hcount=688;
        #10;
        hcount=704;
        #10;
        hcount=720;
        #10;
        hcount=736;
        #10;
        hcount=752;
        #10;
        hcount=768;
        #10;
        hcount=784;
        #10;
        hcount=800;
        #10;
        hcount=816;
        #10;
        hcount=832;
        #10;
        hcount=848;
        #10;
        hcount=864;
        #10;
        hcount=880;
        #20;
        hcount=319;
        vcount=241;
        #10;
        vcount=257;
        #10;
        vcount=273;
        #10;
        vcount=289;
        #10;
        vcount=305;
        #10;
        vcount=321;
        #10;
        vcount=337;
        #10;
        vcount=353;
        #10;
        vcount=369;
        #10;
        vcount=385;
        
        #10;
        vcount=401;
        #10;
        vcount=417;
        #10;
        vcount=433;
        #10;
        vcount=449;
        #10;
        vcount=465;
        #10;
        vcount=481;
        #10;
        vcount=497;
        #10;
        vcount=513;
        #10;
        vcount=529;
        #10;
        vcount=545;
        
        #10;
        vcount=561;
        #10;
        vcount=577;
        #10;
        vcount=593;
        #10;
        vcount=609;
        #10;
        vcount=625;
        #10;
        vcount=641;
        #10;
        vcount=657;
        #10;
        vcount=673;
        #10;
        vcount=689;
        #10;
        vcount=705;
        end


endmodule