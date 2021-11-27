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

