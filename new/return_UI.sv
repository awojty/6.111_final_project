`timescale 1ns / 1ps


module return_UI(
                   input wire clk_in,
                   input wire reset_in,
                   input wire [3:0] state,
                   input wire [12:0] hcount,
                   input wire [12:0] vcount,
                   input wire [15:0] switch,
                   output logic [11:0] pixel_out);

    parameter [10:0] WIDTH = 512;
    parameter [10:0] HEIGHT = 384;

    logic [1:0] solver_image_bits;
    logic [1:0] manual_image_bits;
    logic [1:0] generate_image_bits;

    logic [15:0] solver_image_addr;
    logic [15:0] manual_image_addr;
    logic [15:0] generate_image_addr;
    logic [20:0] image_addr;   // num of bits for 256*240 ROM
    logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;
    //functionality states
//    parameter IDLE = 4'b0000;
//    parameter SOLVER_STATE = 4'b0001;
//    parameter MANUAL_STATE = 4'b0010;
//    parameter GENERATE_STATE = 4'b0011;

    assign image_addr = (hcount) + (vcount) * WIDTH;

    solve_automatically_rom  rom1(.clka(clk_in), .addra(image_addr), .douta(solver_image_bits));
    solve_manually_rom  rom2(.clka(clk_in), .addra(image_addr), .douta(manual_image_bits));
    generate_rom  rom3(.clka(clk_in), .addra(image_addr), .douta(generate_image_bits));

    // red_solver_coe rcm1 (.clka(clk_in), .addra(solver_image_addr), .douta(solver_image_bits));
    // red_manual_coe rcm2(.clka(clk_in), .addra(manual_image_addr), .douta(manual_image_bits));
    // red_generate_coe rcm3 (.clka(clk_in), .addra(generate_image_addr), .douta(generate_image_bits));

    always_ff @(posedge clk_in) begin
        if ((hcount < (WIDTH)) && (vcount < (HEIGHT))) begin
            if(state ==4'd3) begin
                if (generate_image_bits == 2'b00) begin
                    pixel_out <= {4'b0000, 4'b0000,4'b0000}; // greyscale

                end else if (generate_image_bits == 2'b01) begin
                    pixel_out <= {4'b1111, 4'b0000,4'b0000}; // greyscale

                end else if (generate_image_bits == 2'b10) begin
                    pixel_out <= {4'b0000, 4'b0000,4'b1111}; // greyscale

                end else if (generate_image_bits == 2'b11) begin
                    pixel_out <= {4'b0000, 4'b1111,4'b0000}; // greyscale

                end else begin
                    pixel_out <= {4'b0000, 4'b0000,4'b0000}; // greyscale

                end
           
 
            end else if (state ==4'd2) begin
                if (solver_image_bits == 2'b00) begin
                    pixel_out <= {4'b0000, 4'b0000,4'b0000}; // greyscale

                    
                end else if (solver_image_bits == 2'b01) begin
                    pixel_out <= {4'b1111, 4'b0000,4'b0000}; // greyscale

                end else if (solver_image_bits == 2'b10) begin
                    pixel_out <= {4'b0000, 4'b0000,4'b1111}; // greyscale

                end else if (solver_image_bits == 2'b11) begin
                    pixel_out <= {4'b0000, 4'b1111,4'b0000}; // greyscale

                end else begin
                    pixel_out <= {4'b0000, 4'b0000,4'b0000}; // greyscale

                end

            end else if (state ==4'd1) begin
               if (manual_image_bits == 2'b00) begin
                    pixel_out <= {4'b0000, 4'b0000,4'b0000}; // greyscale

                end else if (manual_image_bits == 2'b01) begin
                    pixel_out <= {4'b1111, 4'b0000,4'b0000}; // greyscale

                end else if (manual_image_bits == 2'b10) begin
                    pixel_out <= {4'b0000, 4'b0000,4'b1111}; // greyscale

                end else if (manual_image_bits == 2'b11) begin
                    pixel_out <= {4'b0000, 4'b1111,4'b0000}; // greyscale

                end else begin
                    pixel_out <= {4'b0000, 4'b0000,4'b0000}; // greyscale

                end 
                
            end else begin
                 if (manual_image_bits == 2'b00) begin
                    pixel_out <= {4'b0000, 4'b0000,4'b0000}; // greyscale

                end else if (manual_image_bits == 2'b01) begin
                    pixel_out <= {4'b1111, 4'b0000,4'b0000}; // greyscale

                end else if (manual_image_bits == 2'b10) begin
                    pixel_out <= {4'b0000, 4'b0000,4'b1111}; // greyscale

                end else if (manual_image_bits == 2'b11) begin
                    pixel_out <= {4'b0000, 4'b1111,4'b0000}; // greyscale

                end else begin
                    pixel_out <= {4'b0000, 4'b0000,4'b0000}; // greyscale

                end
            end
            
        end else begin
            pixel_out <= 0;
        end
         
    
   end
endmodule
