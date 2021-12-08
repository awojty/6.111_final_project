
module elevens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_eleven_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module twelves_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twelve_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module thirteens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic  image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirteen_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module forteens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_forteen_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


     always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module fifteens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic  image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_fifteen_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

 
      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module sixteens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic  image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_sixteen_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module seventeens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_seventeen_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module eighteens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_eighteen_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module nineteens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic  image_bits;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_nineteen_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twenties_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twenty_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twentyones_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twentyone_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twentytwos_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic  image_bits;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twentytwo_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twentythrees_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twentythree_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twentyfours_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twentyfour_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twentyfives_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twentyfive_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

   // use color map to create 4 bits R, 4 bits G, 4 bits B

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twentysixes_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twentysix_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twentysevens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twentyseven_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

  
      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twentyeights_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twentyeight_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));


      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module twentynines_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_twentynine_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module thirties_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirty_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule


module thirtyones_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirtyone_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module thirtytwos_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirtytwo_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module thirtythrees_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirtythree_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module thirtyfours_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirtyfour_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module thirtyfives_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirtyfive_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module thirtysixes_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirtysix_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module thirtysevens_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits;

   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirtyseven_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module thirtyeights_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic [7:0] image_bits, red_mapped, green_mapped, blue_mapped;

   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirtyeight_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule

module thirtynines_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits;

   // calculate rom address and read the location
   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_thirtynine_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

      always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end

endmodule

module forties_pixels
   #(parameter WIDTH = 16,     // default picture width
               HEIGHT = 16)    // default picture height
   (input wire pixel_clk_in,
    input wire [10:0] x_in,hcount_in,
    input wire [9:0] y_in,vcount_in,
    output logic [11:0] pixel_out);

   logic [15:0] image_addr;   // num of bits for 256*240 ROM
   logic image_bits;

   assign image_addr = (hcount_in-x_in) + (vcount_in-y_in) * WIDTH;
   small_forty_rom  rom1(.clka(pixel_clk_in), .addra(image_addr), .douta(image_bits));

     always_ff @ (posedge pixel_clk_in) begin
        if ((hcount_in >= x_in && hcount_in < (x_in+WIDTH)) && (vcount_in >= y_in && vcount_in < (y_in+HEIGHT))) begin
            
            if (image_bits == 1'b0) begin

                pixel_out <= 12'hfff; // white
            end else begin
                pixel_out <= 12'd0; // black
            end

       end else  begin
            pixel_out <= 0;
                
        end

   end
endmodule