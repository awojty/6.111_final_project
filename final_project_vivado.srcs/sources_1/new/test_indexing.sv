module fir31(
  input  clk_in,rst_in,
  input [4:0] index_in,
  input [10:0] array_in,
  
  output logic y_out
);
  // for now just pass data through
  
  logic [4:0] index;
  genvar i;
 
  logic [17:0] acc;
  
  logic [7:0] sample;  // 32 element array each 8 bits wide
  logic [4:0] offset;


  always_ff @(posedge clk_in) begin
  
    if (rst_in) begin
        sample <= 8'b01010101;
        
        index<=0;

    end  else begin
        index<=index_in;
        y_out <= sample[index_in];
        
        
        
            for(integer i=0; i < 10; i=i+1) begin
                y_out <= array_in[i];
            end
        

        
        

    
    end
    
    
    
  end
  
  
  
endmodule


