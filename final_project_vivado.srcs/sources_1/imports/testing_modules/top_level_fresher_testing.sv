`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
//12/07 - tets fsm on gernation of constrins since it get stuck 
module top_level_fresher_testing(
   input clk_100mhz,
   input[15:0] sw,
   input btnc, btnu, btnl, btnr, btnd,
   input [7:0] ja, //pixel data from camera
   input [2:0] jb, //other data from camera (including clock return)
   output   jbclk, //clock FPGA drives the camera with
   input [2:0] jd,
   output   jdclk,
   output[3:0] vga_r,
   output[3:0] vga_b,
   output[3:0] vga_g,
   output vga_hs,
   output vga_vs,
   output led16_b, led16_g, led16_r,
   output led17_b, led17_g, led17_r,
   output[15:0] led,
   output uart_rxd_out,
   output ca, cb, cc, cd, ce, cf, cg, dp,  // segments a-g, dp
   output[7:0] an    // Display location 0-7
   );
   
    logic something;
    logic on;
    logic [319:0] digi_photo [219:0];
    logic [39:0] rescaled_out;
    
    logic clk_65mhz;

    assign clk_65mhz = clk_100mhz;

    // create 65mhz system clock, happens to match 1024 x 768 XVGA timing
    //clk_wiz_lab3 clkdivider(.clk_in1(clk_100mhz), .clk_out1(clk_65mhz));

    wire [31:0] data;      //  instantiate 7-segment display; display (8) 4-bit hex
    wire [6:0] segments;
    assign {cg, cf, ce, cd, cc, cb, ca} = segments[6:0];
    //display_8hex display(.clk_in(clk_65mhz),.data_in(data), .seg_out(segments), .strobe_out(an));
    //assign seg[6:0] = segments;
    assign  dp = 1'b1;  // turn off the period

    assign led = {state_FSM,state_pixel};                        // turn leds on to check pixel state
    assign data = {state,state_FSM, state_pixel, state_UI, state_button};   // display 0123456 + sw[3:0]
    assign led16_r = btnl;                  // left button -> red led
    assign led16_g = btnc;                  // center button -> green led
    assign led16_b = btnr;                  // right button -> blue led
    assign led17_r = btnl;
    assign led17_g = btnc;
    

    wire [10:0] hcount;    // pixel on current line
    wire [9:0] vcount;     // line number
    wire hsync, vsync, blank;
    wire [11:0] pixel;
    reg [11:0] rgb;    
    // xvga xvga1(.vclock_in(clk_65mhz),.hcount_out(hcount),.vcount_out(vcount),
    //       .hsync_out(hsync),.vsync_out(vsync),.blank_out(blank));


    // btnc button is user reset
    wire reset;
    //debounce db1(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(reset));
   
   
    logic xclk;
    logic[1:0] xclk_count;
    
    logic pclk_buff, pclk_in;
    logic vsync_buff, vsync_in;
    logic href_buff, href_in;
    logic[7:0] pixel_buff, pixel_in;
    
    logic [11:0] cam;
    logic [11:0] frame_buff_out;
    logic [15:0] output_pixels;
    logic [15:0] old_output_pixels;
    logic [12:0] processed_pixels;
    logic [3:0] red_diff;
    logic [3:0] green_diff;
    logic [3:0] blue_diff;
    logic valid_pixel;
    logic frame_done_out;
    
    logic [319:0] digi_photo_row;
    logic [39:0] rescaled_photo_stored [29:0];
    
    logic [16:0] pixel_addr_in;
    logic [16:0] pixel_addr_out;
    
    assign xclk = (xclk_count >2'b01);
    assign jbclk = xclk;
    assign jdclk = xclk;
    
    assign reset = sw[0];
    
//    assign red_diff = (output_pixels[15:12]>old_output_pixels[15:12])?output_pixels[15:12]-old_output_pixels[15:12]:old_output_pixels[15:12]-output_pixels[15:12];
//    assign green_diff = (output_pixels[10:7]>old_output_pixels[10:7])?output_pixels[10:7]-old_output_pixels[10:7]:old_output_pixels[10:7]-output_pixels[10:7];
//    assign blue_diff = (output_pixels[4:1]>old_output_pixels[4:1])?output_pixels[4:1]-old_output_pixels[4:1]:old_output_pixels[4:1]-output_pixels[4:1];

    
    
//    blk_mem_gen_0 jojos_bram(.addra(pixel_addr_in), 
//                             .clka(pclk_in),
//                             .dina(processed_pixels),
//                             .wea(valid_pixel),
//                             .addrb(pixel_addr_out),
//                             .clkb(clk_65mhz),
//                             .doutb(frame_buff_out));
    
    always_ff @(posedge pclk_in)begin
        if (frame_done_out)begin
            pixel_addr_in <= 17'b0;  
        end else if (valid_pixel)begin
            pixel_addr_in <= pixel_addr_in +1;  
        end
    end
    
    always_ff @(posedge clk_65mhz) begin
        pclk_buff <= jb[0];//WAS JB
        vsync_buff <= jb[1]; //WAS JB
        href_buff <= jb[2]; //WAS JB
        pixel_buff <= ja;
        pclk_in <= pclk_buff;
        vsync_in <= vsync_buff;
        href_in <= href_buff;
        pixel_in <= pixel_buff;
        old_output_pixels <= output_pixels;
        xclk_count <= xclk_count + 2'b01;

        
        if(((output_pixels[15:12] >>2) + (output_pixels[10:7]>>1) + (output_pixels[4:1]>>2))>5) begin
                 processed_pixels <= {4'b1111,4'b1111,4'b1111}; //white

       end else begin
                 processed_pixels <= {4'b0000,4'b0000,4'b0000};
                 
            
             end
             
             if((hcount<320) &&  (vcount<240) && (frame_buff_out  == {4'b0000,4'b0000,4'b0000}) && (sw[10] ==1)) begin
                digi_photo[vcount][hcount] <=1'b1;
                rescaled_photo_stored[(vcount>>3)][(hcount>>3)] <=1'b1;
             end else if ((hcount<320) &&  (vcount<240) && (frame_buff_out  =={4'b1111,4'b1111,4'b1111}) && (sw[10] ==1)) begin
                digi_photo[vcount][hcount] <=1'b0;
                rescaled_photo_stored[(vcount>>3)][(hcount>>3)] <=1'b0;
             end

            
    end
//    assign pixel_addr_out = sw[2]?((hcount>>1)+(vcount>>1)*32'd320):hcount+vcount*32'd320;
    logic               clean;
    logic               old_clean;
    
    
    always_ff @(posedge clk_100mhz)begin
        old_clean <= clean;  //for rising edge detection
    end
    
    logic [119:0] contraint_sent_manual;
    logic [11:0] pixel_3040_manual;
    logic [11:0] pixel_10_10_manual;
    logic center_old;
    logic sending_30_40;
    
    manual_disp_10x10 my_manual_disp_10x10(
                   .clock(clk_65mhz),
                   .reset(reset),
                   .left(left),
                   .right(right),
                   .up(up),
                   .down(down),
                   .center(center),
                   .memory_read_start(sending_assignment),
                   .constraint_vals(assignment_out),
                   .hcount(hcount),
                   .vcount(vcount),
                   .switch(sw),
                   .pixel_out(pixel_10_10_manual));
    
    manual_disp_30_40 my_manual_disp_30_40(
                   .clock(clk_65mhz),
                  .reset(reset),
                   .left(left),
                   .right(right),
                   .up(up),
                   .down(down),
                   .center(center),
                   .start_sending_constraint(sending_30_40),
                  .constraint_vals(contraint_sent_manual),
                   .hcount(hcount),
                   .vcount(vcount),
                   .switch(sw),
                   .pixel_out(pixel_3040_manual));
    
    return_UI my_return_UI(
                   .clk_in(clk_65mhz),
                   .reset_in(reset),
                   .state({2'b00, sw[2:1]}),
                   .hcount(hcount),
                   .vcount(vcount),
                   .switch(sw),
                   .pixel_out(pixel_UI));
    

    assign pixel_addr_out = hcount+vcount*32'd320;
    
    logic [11:0] pixel_UI;
    
    //solution parser inputs
    logic reset; //reset
    logic left;
    logic top;
    logic sol_vals;
    logic done;
    logic [11:0] pixel_solution_disp;

    //solver
    logic start_solver;
    logic get_constraints;
    logic [19:0] constraint_out;
    logic [9:0] row1_out;
    logic [9:0] row2_out;
    logic [9:0] row3_out;
    logic [9:0] row4_out;
    logic [9:0] row5_out;
    logic [9:0] row6_out;
    logic [9:0] row7_out;
    logic [9:0] row8_out;
    logic [9:0] row9_out;
    logic [9:0] row10_out;
    
    logic output_assignment_done;
    logic [19:0] assignment_out;
    logic sending_assignment;
    

    logic constraints_first;
    
    always_comb begin
    
       
        if ((state_pixel == GET_CAMERA_OUTPUT) &&((hcount<320) &&  (vcount<240))) begin
            cam = frame_buff_out;
            
        end else if (state_pixel ==DISPLAY_MANUAL_30_40) begin
            cam = pixel_3040_manual;
            
        end else if (state_pixel == DISPLAY_MANUAL_10_10) begin
            cam = pixel_10_10_manual; // probably sth else sith ther eis a manual modue ?
        

        
        end else if ((state_pixel == DISPLAY_OPTIONS_10_10)) begin
            cam = pixel_solution_disp;
            
        end else if ((state_FSM == IDLE) &&((hcount<512) &&  (vcount<384))) begin
            cam = pixel_UI;
            
        end else if ((state_pixel== DISPLAY_DIGI_PHOTO) &&((hcount<320) &&  (vcount<240))) begin
            if (digi_photo[vcount][hcount] == 1'b1) begin
                cam = {4'b0000,4'b0000,4'b0000};
            end else begin
                cam = {4'b1111,4'b1111,4'b1111};
            end
            
        end else if ((state_pixel == DISPLAY_RESCALED_PHOTO)&&((hcount<40) &&  (vcount<30))) begin
            if (rescaled_photo_stored[vcount][hcount] == 1'b1) begin
                cam = {4'b0000,4'b0000,4'b0000}; // black
            end else if (rescaled_photo_stored[vcount][hcount] == 1'b0) begin
                cam = {4'b1111,4'b1111,4'b1111}; //white
            end else begin
                cam = {4'b1111,4'b0000,4'b1111};
            end
//       end else if ((state_FSM == SOLVER_STATE)) begin
//            cam = frame_buff_out;

       end else if ((state_FSM == DISPLAY_EMPTY_NONOGRAM)) begin
            cam = {4'b0000,4'b0000,4'b1111};
       end else begin
            cam = {4'b0000,4'b0000,4'b1111};
       end
    end
    

    
    //1024x768
    
    
//         solved_disp mysolved_disp(
//                .clock(clk_65mhz),
//                .reset(reset),
//                .solver_done(solver_done), //solver done
//                .memory_read_start(sending_assignment),
//                .constraint_vals(assignment_out),
                
//                .grid_vals1(row1_out),
//                .grid_vals2(row2_out),
//                .grid_vals3(row3_out),
//                .grid_vals4(row4_out),
//                .grid_vals5(row5_out),
//                .grid_vals6(row6_out),
//                .grid_vals7(row7_out),
//                .grid_vals8(row8_out),
//                .grid_vals9(row9_out),
//                .grid_vals10(row10_out),
//                .hcount(hcount),
//                .vcount(vcount), 
//                .switch(sw), 
//                .pixel_out(pixel_solution_disp));
    
    
    
    
   assign pixel_addr_out = hcount+vcount*32'd320;
   
   
//     top_level_solver my_top_level_solver(
//                     .clk_in(clk_65mhz),
//                     .start_in(start_solver), // assered when in the correct stata
//                     .reset_in(reset),
//                     .get_output(get_constraints),
//                     .sw(sw),
//                     .assignment_out(assignment_out),
//                     .row1_out(row1_out),
//                     .row2_out(row2_out),
//                     .row3_out(row3_out),
//                     .row4_out(row4_out),
//                     .row5_out(row5_out),
//                     .row6_out(row6_out),
//                     .row7_out(row7_out),
//                     .row8_out(row8_out),
//                     .row9_out(row9_out),
//                     .row10_out(row10_out),
//                     .top_level_solver_done(solver_done),
//                     .assignment_out_done(output_assignment_done),
//                     .sending_assignment(sending_assignment)

//    );
    
    
   
//    camera_read_fresh  my_camera(.p_clock_in(pclk_in),
//                           .vsync_in(vsync_in),
//                           .href_in(href_in),
//                           .p_data_in(pixel_in),
//                           .button_press(up),
//                           .pixel_data_out(output_pixels),
//                           .pixel_valid_out(valid_pixel),
//                           .frame_done_out(frame_done_out));
   
    // UP and DOWN buttons for pong paddle
    wire up,down,right,center;
//    debounce db2(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnu),.clean_out(up));
//    debounce db3(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnd),.clean_out(down));
//    debounce db4(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnl),.clean_out(left));
//    debounce db5(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnr),.clean_out(right));
//    debounce db6(.reset_in(reset),.clock_in(clk_65mhz),.noisy_in(btnc),.clean_out(center));

    wire phsync,pvsync,pblank;
    logic [11:0] fake_pixel;
    logic [119:0] constraint_generator_storage [69:0];

    wire border = (hcount==0 | hcount==1023 | vcount==0 | vcount==767 |
                   hcount == 512 | vcount == 384);
                   
    logic filter_outputing;
    logic filter_done;
    logic start_filter;
    logic generator_done, start_generator;
    logic [39:0] constrain_input;
    

//    ); 
       
//    logic [39:0] column_constraint_storage [39:0];
//    logic [39:0] row_constraint_storage [29:0];

    logic [119:0] constraint_storage [69:0];


    parameter [5:0] height = 30;
    parameter [5:0] width = 40;

    logic [5:0] run_length;
    logic [5:0] constraint_count; //counts the number of cosntraints in the given row
    logic [5:0] constraint_count_index;

    logic [119:0] temporary_constraint;

    logic [8:0]  constraint_counter;
    
    logic process_columns;

//    logic [5:0] i;
//    logic [5:0] j;
    
    logic process_rows;
    
    logic run_started;
    logic output_constraints;
    logic move_to_output;
    logic save_constraint;
    logic move_to_columns;
    logic in_progress;
    logic [7:0] counter;
    logic [7:0] counter_out;
    logic start_collecting;
    logic last_fill;
    logic buffer; 

    

    reg b,hs,vs;
    logic [3:0] state;
    
    parameter CALL_GENERATOR = 4'b0101;
    parameter DISPLAY_EMPTY_NONOGRAM = 4'b1001;
    parameter GET_CAMERA_OUTPUT = 4'b1010;

    //functionality states
    parameter IDLE = 4'b0000;
    parameter MANUAL_STATE = 4'b0001;
    parameter SOLVER_STATE = 4'b0010;
    parameter GENERATE_STATE = 4'b0011;

    
    //states that govern pixel outptu
    parameter DISPLAY_DIGI_PHOTO  = 4'b0111;
    parameter DISPLAY_RESCALED_PHOTO = 4'b1011;
    parameter DISPLAY_MANUAL_30_40 = 4'b1101;
    parameter DISPLAY_MANUAL_10_10 = 4'b1110;
    parameter DISPLAY_OPTIONS_10_10 = 4'b1111;

    
    
    
    

    logic [8:0] index;
    logic [8:0] index_rescale;
    logic started_filter;
    logic [7:0] index_c;
    logic generator_outputing;
    logic generator_started;
    logic [9:0] i;
    logic [9:0] j;
    
    logic [1:0] counter_button;
    
    logic [3:0] state_UI;
    logic [3:0] state_FSM;
    logic [3:0] state_pixel;
    logic center_started;
    logic start_solver;
    logic get_constraints;
    logic user_selected_nonogram;
    
    logic [3:0] state_button;
    logic start_constraint_old;
    
    logic start;
    logic start_old;
    
    assign start = sw[11];
    assign start_constraint = sw[6];
    logic go_to_solving;
    logic user_selected_nonogram_sw;
    logic user_selected_nonogram_sw_old;
    
    logic solver_done;
    assign user_selected_nonogram_sw = sw[7];
    

    assign led17_b  = solver_done;
    
    
    assign left = btnl;
    assign center = btnc;

    logic [7:0] counter_30_40;
    
    always_ff @(posedge clk_65mhz) begin
    
        if(reset) begin
            
            start_old <=0;
            start_constraint_old <=0;
            start_solver<=0;
            get_constraints <=0;
            go_to_solving <=0;
            constraints_first <= 0;
            state_FSM <=IDLE;
            user_selected_nonogram_sw_old<=0;
            state <=0;
            state_UI <=0;
            state_button <=0;
            state_pixel <=0;
            
            index <=0;
            index_rescale <=0;
            started_filter <= 0;
            index_c <=0;
            generator_started <=0;
            i<=0;
            j <=0;
            constraint_counter<=0;
            counter_button<=0;
            
            process_columns <=0;
            run_started <= 0;
            j<=0;
            i <=0;
            temporary_constraint<=120'b0;
            output_constraints <=0;
            move_to_output<=0;
            save_constraint <=0;
            move_to_columns<=0;
            
            process_rows <=0;
            in_progress <=0;
            constraint_count <=0;
            constraint_count_index <= 0;
            run_length <=0;
            counter <=0;
            counter_out <= 0;
            start_collecting <=0;
            user_selected_nonogram_sw_old <=0;
            
            last_fill <=0;
            buffer <=0;
            center_started <=0;
            user_selected_nonogram <=0;
            counter_button<=0;

            counter_30_40 <=0;
            sending_30_40 <=0;
            
            
           rescaled_photo_stored[0] <=   40'b1111111111111111111111111111111111111111;
           rescaled_photo_stored[1] <=   40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[2] <=  40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[3] <=  40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[4] <=  40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[5] <=  40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[6] <=  40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[7] <=  40'b1111111111111111111111111111111111111111;
          rescaled_photo_stored[8] <=    40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[9] <=  40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[10] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[11] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[12] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[13] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[14] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[15] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[16] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[17] <= 40'b1111111111111111111111111111111111111111;
           rescaled_photo_stored[18] <=  40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[19] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[20] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[21] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[22] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[23] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[24] <= 40'b1111111111111111111111111111111111111111;
          rescaled_photo_stored[25] <=   40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[26] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[27] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[28] <= 40'b1111111111111111111111111111111111111111;
            rescaled_photo_stored[29] <= 40'b1111111111111111111111111111111111111111;




        end
        
        rgb <= cam;
        hs <= hsync;
        vs <= vsync;
        b <= blank;
        
           if(down) begin
               counter_button <=counter_button +1;
           end
           

           
        if (state_FSM ==DISPLAY_MANUAL_30_40) begin
            state_pixel <=DISPLAY_MANUAL_30_40;
        //todo - start sending constraints
            if (counter_30_40  == 69) begin
                sending_30_40 <=0;
            end else begin
                sending_30_40 <=1;
                counter_30_40 <=counter_30_40 +1;
                contraint_sent_manual <= constraint_storage[counter_30_40];

            end

        
         
       end else if (state_FSM == IDLE &&((sw[12] ==0) && (sw[3] ==0))) begin
       
            
            if(center) begin
                state_FSM <= {2'b00, sw[2:1]};
            end
            
       end else if (state_FSM == SOLVER_STATE &&((sw[12] ==0) && (sw[3] ==0))) begin
            state_pixel <= DISPLAY_OPTIONS_10_10;
            
            //cofmir the choice of teh nonogram that you are seing rn to be solved
            if(center ) begin
                user_selected_nonogram <=1;
            end
            
            if(user_selected_nonogram) begin
            
                if (!center & center_old !=center) begin //set this to trigger on descending edge of center otherwise it overlaps?
                    get_constraints <=1;
                end else begin
                     get_constraints <=0;
                end
                
                if(down) begin
                    user_selected_nonogram <=0;
                end

                if (!start & start_old != start) begin
                   start_solver <=1;
                   if(solver_done)begin
                       user_selected_nonogram <=0;
                       go_to_solving<=0;
                    end
                end else begin
                   start_solver <=0;
                end
                    
                
            end
            
            
            //get cosntraints for a new nonogram to sww


            //---------------TODO - fill in with teh fsm version for solver ----------
       end else if (state_FSM == MANUAL_STATE &&((sw[12] ==0) && (sw[3] ==0))) begin
       
            state_pixel <= DISPLAY_MANUAL_10_10;
            
           
           //cofmir the choice of teh nonogram that you are seing rn to be solved
            if(center) begin
                user_selected_nonogram <=1;
            end
            
            if(user_selected_nonogram) begin
            
                if (center&  !constraints_first) begin //used to be just center
                    get_constraints <=1;
                    constraints_first <=1;
                end else begin
                     get_constraints <=0;
                end
                
                if(sw[4]) begin
                    user_selected_nonogram <=0;
                end
      
                
            end
            
         
        end else if (state_FSM == GENERATE_STATE &&((sw[12] ==0) && (sw[3] ==0))) begin
            // start generator
            hs <= hsync;
            vs <= vsync;
            b <= blank;
            rgb <= cam;
            //state_display <=SHOW_CAMERA;
           // state_FSM <= GET_CAMERA_OUTPUT;
            state_pixel <= GET_CAMERA_OUTPUT;
            center_started <=1;
            
            if (left) begin
                state <= CALL_GENERATOR;
                
                //reset gerntor stuff on new input
                
                constraint_counter<=0;
                process_columns <=0;
                run_started <= 0;
                j<=0;
                i <=0;
                temporary_constraint<=120'b0;
                output_constraints <=0;
                move_to_output<=0;
                save_constraint <=0;
                move_to_columns<=0;
                buffer <=0;
                
                constraint_count <=0;
                constraint_count_index <= 0;
                run_length <=0;
                process_rows <=1;

            end
            

            if (state == CALL_GENERATOR) begin
            
            
                if (process_rows && ~save_constraint  && ~buffer) begin


                    if( i == height) begin
                        //dong zero run legnth here since its gonna be used in the save step 
                        process_rows <=0;
                        move_to_columns <=1;
                        run_started <=0;
                        j<=0;
                        i <=0;
                        save_constraint <=1;
                        constraint_count_index<=0;

                    end else begin

                        if((rescaled_photo_stored[i][j] == 1) && run_started) begin
                            run_length <=run_length +1;
                            j <= j + 1;

                        end else if((rescaled_photo_stored[i][j] == 1) && ~run_started) begin
                            run_length <=6'b1;
                            j <= j + 1;
                            run_started <=1;

                    
                        end else if((rescaled_photo_stored[i][j] == 0) && run_started) begin
                            run_started <=0;
                        
                            constraint_count_index <= 6 +constraint_count_index; // add 6 since there are 6 bots per number
                            j <= j + 1;
                        //run_length <=0;

                            temporary_constraint[constraint_count_index] <=run_length[0];
                            temporary_constraint[constraint_count_index+1] <=run_length[1];
                            temporary_constraint[constraint_count_index+2] <=run_length[2];
                            temporary_constraint[constraint_count_index+3] <=run_length[3];
                            temporary_constraint[constraint_count_index+4] <=run_length[4];
                            temporary_constraint[constraint_count_index+5] <=run_length[5];


                        end else if(rescaled_photo_stored[i][j] == 0 && ~run_started) begin
                            j <= j + 1;
                            run_started <=0;

                        end else begin
                            j <= j + 1;
                        end

                        if( j == width-1) begin
                        
                            j<=0;
                            i <= i + 1;
                        
                        
                            buffer <=1;

                            if (run_started) begin

                                temporary_constraint[constraint_count_index] <=run_length[0];
                                temporary_constraint[constraint_count_index+1] <=run_length[1];
                                temporary_constraint[constraint_count_index+2] <=run_length[2];
                                temporary_constraint[constraint_count_index+3] <=run_length[3];
                                temporary_constraint[constraint_count_index+4] <=run_length[4];
                                temporary_constraint[constraint_count_index+5] <=run_length[5];

                            end
                        

                        end




                    end
                
                end else if (buffer) begin
                    run_started <=0;
                    buffer <=0;
                    run_length <=0;
                    save_constraint <=1;
                    if (run_started) begin

                        temporary_constraint[constraint_count_index] <=run_length[0];
                        temporary_constraint[constraint_count_index+1] <=run_length[1];
                        temporary_constraint[constraint_count_index+2] <=run_length[2];
                        temporary_constraint[constraint_count_index+3] <=run_length[3];
                        temporary_constraint[constraint_count_index+4] <=run_length[4];
                        temporary_constraint[constraint_count_index+5] <=run_length[5];

                    end

                end else if (save_constraint) begin
                    run_length <=0;
                    run_started <=0;
                    save_constraint <=0;
                    temporary_constraint <=0;
                    constraint_storage[constraint_counter] <=temporary_constraint;
                    //constraint_counter <= constraint_counter + 1; // coutns row/colummn
                    constraint_count_index <= 0;



                    if(move_to_columns) begin
                        process_columns <=1;
                        move_to_columns<=0;
                        i<=0;
                        j<=0;
                        constraint_counter <= constraint_counter ;
                    end else begin
                        constraint_counter <= constraint_counter + 1;


                    end

                    if(move_to_output)begin
                        
                        output_constraints <=1;
                        move_to_output<=0;
                        i<=0;
                        j<=0;
                        state_pixel <= DISPLAY_MANUAL_30_40;
                        state_FSM <= DISPLAY_MANUAL_30_40;
                        center_started <=0;
                    end

                end else if ( process_columns && ~save_constraint) begin


                    if(width == j) begin

                        process_rows <=0;
                        process_columns <=0;
                        run_started <=0;
                        j<=0;
                        i <=0;
                        move_to_output <=1;
                        
                        save_constraint <=1;

                    
                    end else begin

                        if(rescaled_photo_stored[i][j] == 1 && run_started) begin
                            run_length <=run_length +1;
                            i <= i + 1;

                        end else if(rescaled_photo_stored[i][j] == 1 && ~run_started) begin
                            run_length <=1;
                            i <= i + 1;
                            run_started <=1;

                        
                        end else if(rescaled_photo_stored[i][j] == 0 && run_started) begin
                            run_started <=0;
                            constraint_count <=1 +constraint_count;
                            constraint_count_index <= 6 +constraint_count_index; // add 6 since there are 6 bots per number
                            i <= i + 1;
                            //run_length <=0;
                            temporary_constraint[constraint_count_index] <=run_length[0];
                            temporary_constraint[constraint_count_index+1] <=run_length[1];
                            temporary_constraint[constraint_count_index+2] <=run_length[2];
                            temporary_constraint[constraint_count_index+3] <=run_length[3];
                            temporary_constraint[constraint_count_index+4] <=run_length[4];
                            temporary_constraint[constraint_count_index+5] <=run_length[5];

                        end else if(rescaled_photo_stored[i][j] == 0 && ~run_started) begin
                            i <= i + 1;

                        end else begin
                            i <= i + 1;
                        end

                        if( i == (height-1)) begin
                        
                            //save_constraint <=1;
                            buffer <=1;
                            j<=j+1;
                            i <= 0;
                            
                            //run_started <=0;
                            

                            if (run_started) begin

                                temporary_constraint[constraint_count_index] <=run_length[0];
                                temporary_constraint[constraint_count_index+1] <=run_length[1];
                                temporary_constraint[constraint_count_index+2] <=run_length[2];
                                temporary_constraint[constraint_count_index+3] <=run_length[3];
                                temporary_constraint[constraint_count_index+4] <=run_length[4];
                                temporary_constraint[constraint_count_index+5] <=run_length[5];

                            end

                        end
                    end
                end
            end


            
        end else if (sw[3] == 1)begin
            rgb <= cam;
            state_pixel <= DISPLAY_DIGI_PHOTO;
            state <= {constraint_storage[1][31:0]};
            
            if(down) begin
                i <= i+1;
            end
            
            if(right) begin
                j <= j+1;
            end
       end else if (sw[12] == 1)begin
            rgb <= cam;
            state_pixel <=DISPLAY_RESCALED_PHOTO;
            state <= {rescaled_photo_stored[1][30:0]};
            
            if(down) begin
                i <= i+1;
            end
            
            if(right) begin
                j <= j+1;
            end
                

        end else begin

              something <=1;
              hs <= hsync;
              vs <= vsync;
              b <= blank;
              
             
        end
        center_old<=center;
        start_old <= start;
        start_constraint_old <= start_constraint;
        user_selected_nonogram_sw_old <= user_selected_nonogram_sw;
     end

      
    // the following lines are required for the Nexys4 VGA circuit - do not change
    assign vga_r = ~b ? rgb[11:8]: 0;
    assign vga_g = ~b ? rgb[7:4] : 0;
    assign vga_b = ~b ? rgb[3:0] : 0;

    assign vga_hs = ~hs;
    assign vga_vs = ~vs;

endmodule

////////////////////////////////////////////////////////////////////////////////