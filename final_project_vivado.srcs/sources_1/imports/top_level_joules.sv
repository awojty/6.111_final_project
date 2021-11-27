`default_nettype none

//top level for the project

module top_level_joules(
   input wire clk_100mhz,
   input wire [15:0] sw,
   input wire btnc, btnu, btnl, btnr, btnd,
    input wire [7:0] ja, //pixel data from camera
    input wire [2:0] jb, //other data from camera (including clock return)
    input wire [2:0] jd,
    output  logic  jbclk,
   output logic[3:0] vga_r,
   output logic[3:0] vga_b,
   output logic[3:0] vga_g,
   output logic vga_hs,
   output logic vga_vs,
   output logic led16_b, led16_g, led16_r,
   output logic led17_b, led17_g, led17_r,
   output logic [15:0] led,
   output logic ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
   output logic[7:0] an,    // Display location 0-7
   output logic  jdclk
   );
   
   logic [10:0] hcount;    // pixel on current line
    logic [9:0] vcount;     // line number
    logic hsync, vsync, blank; //control signals for vga
    logic [11:0] pixel;
    logic [11:0] rgb; 
    logic [6:0] cat_out;

    logic [31:0] state_vals;


    	//display
	seven_seg_controller my_7_seg_controller(
		.clk_in(clk_65mhz),
        .rst_in(sw[0]),
        .val_in(state_vals),
        .cat_out(cat_out),
    	.an_out(an)
    );

	assign {cg,cf,ce,cd,cc,cb,ca} = cat_out; 


    //this is returning xvga "clock" - hcount and vcount 
    xvga_joules xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
          .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));



    //solution 

    logic [9:0] row1_solution;
    logic [9:0] row2_solution;
    logic [9:0] row3_solution;
    logic [9:0] row4_solution;
    logic [9:0] row5_solution;
    logic [9:0] row6_solution;
    logic [9:0] row7_solution;
    logic [9:0] row8_solution;
    logic [9:0] row9_solution;
    logic [9:0] row10_solution;
    logic solver_done;
    logic assignment_out_done;

    top_level_solver my_top_level_solver(
        .clk_in(clk_65mhz),
        .start_in(start_solver), // assered when in the correct stata
        .reset_in(reset_in),
        .get_output(get_output)
        .sw(sw),
        .row1_out(row1_solution),
        .row2_out(row2_solution),
        .row3_out(row3_solution),
        .row4_out(row4_solution),
        .row5_out(row5_solution),
        .row6_out(row6_solution),
        .row7_out(row7_solution),
        .row8_out(row8_solution),
        .row9_out(row9_solution),
        .row10_out(row10_solution),
        .top_level_solver_done(solver_done),
        .assignment_out_done(assignment_out_done)

   );









   logic [1:0] state; //state indicator, 00 is menu, 01 is manual solver, 10 is autosolver output
   logic clk_65mhz; //65 MHz clock!
   
   //solution parser inputs
   logic reset; //reset
   logic left;
   logic top;
   logic sol_vals;
   logic done;

   logic nonogram_generator_done;
   logic show_a_photo;
   logic [11:0] pixel_out_generator;
   
    // create 65mhz system clock, happens to match 1024 x 768 XVGA timing
    clk_wiz_lab3 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));
    
    
    // SolutionParser parser(.done(done), .sol_vals(sol_vals),
    //                        .clk_in(clk_100mhz), .reset(reset), .pixel_clock(clk_65mhz), .hcount(hcount),
    //                        .vcount(vcount), .left_vals(left), .top_vals(top), 
    //                        .pixel_out(pixel));


    logic down_clean;
    logic center_clean;
    logic up_clean;
    logic left_clean;
    debounce db2(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnu),.clean_out(up_clean));
    debounce db3(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnd),.clean_out(down_clean));

    debounce db4(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(center_clean));

    debounce db5(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnl),.clean_out(left_clean));
    // debounce db6(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnr),.clean_out(right_clean));


    top_level_nonogram_generator my_top_level_nonogram_generator (
        .clk_65mhz(clk_65mhz),
        .start_in(center_clean),
        .reset_in(down_clean),
        .vcount(vcount),
        .hcount(hcount),
        .take_a_snapshot(left_clean), // to assert taking a photot
        .create_a_nonogram(up_clean), // to assert that we are happy with a photo and can move to cosntrinsat generation
        .ja(ja), //pixel data from camera
        .jb(jb), //other data from camera (including clock return)
        .jd(jd),
        .nonogram_generator_done(nonogram_generator_done),
        .show_a_photo(show_a_photo),
        .pixel_out(pixel_out_generator), 
        .state_vals(state_vals)
    ); // use din hex display to show the state 






    // logic [11:0] pixel_test;
    // ones_pixels #(.WIDTH(16), .HEIGHT(16)) one(.pixel_clk_in(clk_65mhz), .x_in(0), .y_in(0), .hcount_in(hcount), .vcount_in(vcount), .pixel_out(pixel_test));
    logic b,hs,vs;
    always_ff @(posedge clk_65mhz) begin
         // default: pong
         hs <= hsync;
         vs <= vsync;
         b <= blank;
         rgb <= pixel_out_generator;
         reset <=0;


         if (sw[1:0]==2) begin
             //manual solver - just display empty

            if(~assignment_out_done) begin
                get_output <=1;
                 
            end else begin
                get_output <=0;

            end

             
         end else if (sw[1:0]==3) begin
             //automatic solver - just display empty
             if (center_clean) begin
                 //press center to start solving the nonogram
                 start_solver <=1;
                 
             end else if (start_solver) begin
                 
                 start_solver <=0;
             end



         end else if (sw[0] == 1) begin
             reset <=1;
             
         end
    







    end
    
    // the following lines are required for the Nexys4 VGA circuit - do not change
    assign vga_r = ~b ?  rgb[11:8]: 0;
    assign vga_g = ~b ? rgb[7:4] : 0;
    assign vga_b = ~b ? rgb[3:0] : 0;
    
    assign vga_hs = ~hs;
    assign vga_vs = ~vs;
    
endmodule
`default_nettype wire