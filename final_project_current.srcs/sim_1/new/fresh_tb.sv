`timescale 1ns / 1ps

module fresh_tb;
logic clk;
logic [15:0] switch;
logic up,down,left,right,center;
logic [7:0] ja;
logic [2:0] jb;
logic jbclk;
logic [2:0] jd;
logic jdclk;
logic [3:0] vga_r;
logic [3:0] vga_b;
logic [3:0] vga_g;
logic vga_hs;
logic vga_vs;
logic led16_b,led16_g,led16_r,led17_b,led17_r,led17_g;
logic [15:0] led;
logic ca,cb,cc,cd,ce,cf,cg,dp;
logic [7:0] an;
logic reset;
logic solver;
top_level_fresher fresh(.clk_100mhz(clk),.sw(sw),
   .btnc(center), .btnu(up), .btnl(left), .btnr(right), .btnd(down),
   .ja(ja),.jb(jb),.jbclk(jbclk),.jd(jd),.jdclk(jdclk),.vga_r(vga_r), .vga_b(vga_b), .vga_g(vga_g),
   .vga_hs(vga_hs), .vga_vs(vga_vs), .led16_b(led16_b), .led16_g(led16_g), .led16_r(led16_r),
   .led17_b(led17_b), .led17_g(led17_g), .led17_r(led17_r),
   .led(led),
   .ca(ca), .cb(cb), .cc(cc), .cd(cd), .ce(ce), .cf(cf), .cg(cg), .dp(dp),  // segments a-g, dp
   .an(an)    // Display location 0-7
   );
   logic [31:0] state;
    logic something;
    logic on;
    logic [319:0] digi_photo [219:0];
    logic [39:0] rescaled_out;
    logic solver_done;
    assign switch[3] = solver;
    assign switch[0] = reset;
    
    always #5 clk = !clk;
    
    initial begin
    reset=0;
    solver=0;
    clk=0;
    left=0;
    down=0;
    #20;
    reset=1;
    #10;
    reset=0;
    #50;
    solver=1;
    #20;
    down=1;
    #30;
    down=0;
    #30;
    left=1;
    #20;
    left=0;
    #500;
    end 
endmodule
