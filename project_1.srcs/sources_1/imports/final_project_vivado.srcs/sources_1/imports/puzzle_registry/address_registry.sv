`default_nettype none

module address_registry(   
                    input wire clk_in,
                    input wire [5:0] index_in,
                    input wire confirm_in,
                    input wire rst_in,
                    output logic [31:0] address_out,
                    output logic done_out
                    
    );  


    address_rom  my_address_rom(.clka(clk_in), .addra(index_in), .douta(address_out));
    always_ff @(posedge clk_in) begin

        if(rst_in) begin
            done_out <=0;
            
        end else begin
            if(confirm_in) begin
                done_out<=1;
                
            end else begin
                done_out <=0;
            end 

        end
        
    end



  



    
    
endmodule

`default_nettype wire