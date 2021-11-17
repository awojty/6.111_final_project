`default_nettype none

module seven_segment_controller(input wire         clk_in,
                            input wire         rst_in,
                            input wire [31:0] val_in,
                            
                            output logic[6:0]   cat_out,
                            output logic[7:0]   an_out
    );
  
    logic[7:0]      segment_state;
    logic[31:0]     segment_counter;
    logic [3:0]     routed_vals;
    logic [6:0]     led_out;
    
    
    binary_to_seven_seg my_converter ( .bin_in(routed_vals), .hex_out(led_out));
    assign cat_out = ~led_out;
    assign an_out = ~segment_state;
    logic event_;

    
    always_comb begin
        case(segment_state)
            8'b0000_0001:   routed_vals = val_in[3:0];
            8'b0000_0010:   routed_vals = val_in[7:4];
            8'b0000_0100:   routed_vals = val_in[11:8];
            8'b0000_1000:   routed_vals = val_in[15:12];
            8'b0001_0000:   routed_vals = val_in[19:16];
            8'b0010_0000:   routed_vals = val_in[23:20];
            8'b0100_0000:   routed_vals = val_in[27:24];
            8'b1000_0000:   routed_vals = val_in[31:28];
            default:        routed_vals = val_in[3:0];       
        endcase
    end
    
    always_ff @(posedge clk_in)begin
        if (rst_in)begin
            segment_state <= 8'b0000_0001;
            segment_counter <= 32'b0;
        end else begin
            if (segment_counter == 32'd10000)begin
                segment_counter <= 32'd0;
                event_ <=1;
                segment_state <= {segment_state[6:0],segment_state[7]};
            end else begin
                event_ <=0;
                segment_counter <= segment_counter +1;
            end
        end
    end
        
endmodule //seven_seg_controller


`default_nettype wire


module binary_to_seven_seg(

        input wire [3:0]       bin_in,  //declaring input explicitely
        output logic [6:0]      hex_out);  //declaring output explicitely

    //your logic here
    //many ways to do this (syntatically)
    // assign statements with ternary operators or logical statements/equality checks
    // always_comb block with some if/else if/else logic inside
    // switch statement
    // etc.... this is up to you!
     always @(bin_in) begin  
       
        case(bin_in)  
          4'b0000    :  hex_out = 7'b0111111;       
          4'b0001    :  hex_out = 7'b0000110;      
          4'b0010    :  hex_out = 7'b1011011;
          4'b0011    :  hex_out = 7'b1001111;       
          4'b0100    :  hex_out = 7'b1100110;      
          4'b0101    :  hex_out = 7'b1101101;   
          4'b0110    :  hex_out = 7'b1111101;       
          4'b0111    :  hex_out = 7'b0000111;      
          4'b1000    :  hex_out = 7'b1111111;
          4'b1001    :  hex_out = 7'b1101111; 
          
          4'b1010    :  hex_out = 7'b1110111; 
          4'b1011    :  hex_out = 7'b1111100; 
          4'b1100    :  hex_out = 7'b0111001; 
          4'b1101    :  hex_out = 7'b1011110; 
          4'b1110    :  hex_out = 7'b1111001; 
          4'b1111    :  hex_out = 7'b1110001; 
          
                   
          default  :  hex_out = 0;       // If sel is something, out is commonly zero  
        endcase  
      end  


endmodule //binary_to_hex
`default_nettype wire //important to put at end (makes it work nicer with IP modules)

