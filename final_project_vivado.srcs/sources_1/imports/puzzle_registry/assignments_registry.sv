`default_nettype none

module assignments_registry(   
                    input wire clk_in,
                    input wire start_in,
                    input wire rst_in,
                    input wire [7:0] row_number_in,
                    input wire [7:0] col_number_in,
                    input wire [31:0] address_in,
                    output logic [799:0] assignment_out,
                    output logic [31:0] counter_out,
                    output logic done,
                    output logic sending

    );  



    parameter ADDRESS_SIZE = 31;
    parameter SAMPLE_COUNT = 2082;//gets approximately (will generate audio at approx 48 kHz sample rate.

    logic [ADDRESS_SIZE:0] address;

    logic [15:0] dimensions;
    logic [799:0] assignment; //uuuuuh is this legal ? 

    logic [31:0] address_input;


    logic [31:0] counter;

    logic started;

    logic [8:0] limit; // limit 200+200 = 400 > 9 bits


    assignments_rom  my_assignment_rom(.clka(clk_in), .addra(address_input), .douta(assignment_out));

    always_ff @(posedge clk_in) begin

        if(rst_in) begin
            counter_out <=0;
            started<=0;
            sending<=0;
            done<=0;
            
        end else begin
            if(start_in && ~started) begin
                address_input <=address_in;
                started <=1;
                sending<=1;
               
                limit <= row_number_in + col_number_in;
            
            end else if (started) begin
                if(counter_out == limit) begin
                    done <=1;
                    started<=0;
                    sending<=0;
                end else begin
                    address_input <=address_input+1;
                    counter_out <= counter_out+1;

                end




                
            end


        end

        
    end





    
    
endmodule

`default_nettype wire