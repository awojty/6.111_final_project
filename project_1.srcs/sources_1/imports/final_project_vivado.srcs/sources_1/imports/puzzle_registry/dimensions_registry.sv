`default_nettype none

module dimensions_registry(   
                    input wire clk_in,
                    input wire [5:0] index_in,
                    input wire start_in,
                    input wire rst_in,
                    output logic [15:0] dimensions_out
                    
                    
    ); 

    logic [15:0] dimensions;

    dimensions_rom  my_dimensions_rom(.clka(clk_in), .addra(index_in), .douta(dimensions));


    always_ff @(posedge clk_in) begin

        if(rst_in) begin
            dimensions_out<=0;
            dimensions <=0;
            
            
        end else begin

            if(start_in) begin
                dimensions_out <=dimensions; //have a one cycle delay to ensure that we get a seclected address after the click on btnc
                
            end

        end

        
    end


endmodule

`default_nettype wire