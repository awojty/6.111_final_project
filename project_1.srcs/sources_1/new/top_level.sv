`default_nettype none
module top_level(
   input wire clk_100mhz,
   input wire [15:0] sw,
   input wire btnc, btnu, btnl, btnr, btnd,
   output logic[3:0] vga_r,
   output logic[3:0] vga_b,
   output logic[3:0] vga_g,
   output logic vga_hs,
   output logic vga_vs,
   output logic led16_b, led16_g, led16_r,
   output logic led17_b, led17_g, led17_r,
   output logic [15:0] led,
   output logic ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
   output logic[7:0] an    // Display location 0-7
   );
   
   logic [10:0] hcount;    // pixel on current line
    logic [9:0] vcount;     // line number
    logic hsync, vsync, blank; //control signals for vga
    logic [11:0] pixel;
    logic [11:0] rgb;  
    xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));

   logic [1:0] state; //state indicator, 00 is menu, 01 is manual solver, 10 is autosolver output
   logic clk_65mhz; //65 MHz clock!
   
   //solution parser inputs
   logic reset; //reset
   logic left;
   logic top;
   logic sol_vals;
   logic done;
   
    // create 65mhz system clock, happens to match 1024 x 768 XVGA timing
    clk_wiz_lab3 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));
    
    
    SolutionParser parser(.done(done), .sol_vals(sol_vals),
                           .clk_in(clk_100mhz), .reset(reset), .pixel_clock(clk_65mhz), .hcount(hcount),
                           .vcount(vcount), .left_vals(left), .top_vals(top), 
                           .pixel_out(pixel));
    logic [11:0] pixel_test;
    ones_pixels #(.WIDTH(16), .HEIGHT(16)) one(.pixel_clk_in(clk_65mhz), .x_in(0), .y_in(0), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_test));
    logic b,hs,vs;
    always_ff @(posedge clk_65mhz) begin
         // default: pong
         hs <= hsync;
         vs <= vsync;
         b <= blank;
         rgb <= pixel;
    end
    
    // the following lines are required for the Nexys4 VGA circuit - do not change
    assign vga_r = ~b ?  rgb[11:8]: 0;
    assign vga_g = ~b ? rgb[7:4] : 0;
    assign vga_b = ~b ? rgb[3:0] : 0;
    
    assign vga_hs = ~hs;
    assign vga_vs = ~vs;
    
endmodule
`default_nettype wire