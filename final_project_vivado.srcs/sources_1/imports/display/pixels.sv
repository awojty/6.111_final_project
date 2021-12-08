module eights_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
         logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_eight_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule

module sixes_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
         logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_six_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule

module fives_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
         logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_five_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule

module fours_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
    
         logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_four_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule
module tens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
    
    logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_ten_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule



module nines_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
    
    logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_nine_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule

module ones_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
    
        logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_one_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule

module sevens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
     logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;

   logic red_mapped;

   small_seven_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule

module twelve_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
    
     logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_twelve_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule

module threes_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
    
    
    logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_three_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule

module twos_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);
    
        logic [15:0] image_addr;
    assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;


   logic red_mapped;

   small_two_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(red_mapped));

   always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (red_mapped == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end 
endmodule

