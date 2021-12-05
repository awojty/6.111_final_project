module top_level_manual(
   input clk_100mhz,
   input[15:0] sw,
   input btnc, btnu, btnl, btnr, btnd,
   output[3:0] vga_r,
   output[3:0] vga_b,
   output[3:0] vga_g,
   output vga_hs,
   output vga_vs
   );
   reg hs;
   reg vs;
   reg b;
   reg [11:0] rgb;
   wire [10:0] hcount;
   wire [9:0] vcount;
   wire hsync;
   wire vsync;
   wire blank;
   logic left,right,up,down,center;
   
   debounce db1(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnu),.clean_out(up));
   debounce db2(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnl),.clean_out(left));
   debounce db3(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnd),.clean_out(down));
   debounce db4(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnr),.clean_out(right));
   debounce db5(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(center));
   
   xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));
          
   clk_wiz_lab3 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));
   
    manual_disp(.clock(clk_65_mhz), .reset(reset),.left(left),
                .right(right), .up(up), .down(down), .center(center),
                   .memory_read_start(read_start),
                   .constraint_vals(constraints),
                   .hcount(hcount),
                   .vcount(vcount),
                   .pixel_out(pixel_solution_disp));      
    always_ff @(posedge clk_65_mhz) begin
        hs <= hsync;
        vs <= vsync;
        b <= blank;
        rgb <= pixel_solution_disp;
    end
    assign vga_r = ~b ? rgb[11:8]: 0;
    assign vga_g = ~b ? rgb[7:4] : 0;
    assign vga_b = ~b ? rgb[3:0] : 0;

    assign vga_hs = ~hs;
    assign vga_vs = ~vs;
endmodule
