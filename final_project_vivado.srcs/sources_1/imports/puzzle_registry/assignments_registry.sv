`default_nettype none

module assignments_registry(   
                    input wire clk_in,
                    input wire start_in,
                    input wire reset_in,
                    input wire [15:0] address_in,
                    output logic [19:0] assignment_out,
                    output logic [5:0] counter_out,
                    output logic done,
                    output logic sending

    );  



    parameter ADDRESS_SIZE = 31;
    parameter SAMPLE_COUNT = 2082;//gets approximately (will generate audio at approx 48 kHz sample rate.

    logic [ADDRESS_SIZE:0] address;

    logic [15:0] dimensions;

    logic [31:0] address_input;


    logic [31:0] counter;

    logic started;

    logic [8:0] limit; // limit 200+200 = 400 > 9 bits

    //width of 20 height if at least 20 since at least for one nonogram

    logic [19:0] assignment_out1;
    logic [19:0] assignment_buffer;
    logic just_started;


    assignments_rom  my_assignment_rom(.clka(clk_in), .addra(address_input), .douta(assignment_out1));

    always_ff @(posedge clk_in) begin

        if(reset_in) begin
            counter_out <=0;
            started<=0;
            sending<=0;
            done<=0;
            address_input<=0;
            assignment_out<=0;
            limit <=0;
            just_started <=0;
            
        end else begin
            if(start_in && ~started) begin
                address_input <= address_in * 20 +1;
                started <=1;
                counter_out <= 0;
                
               
                limit <= 20;
                just_started <=1;
                //assignment_out <= assignment_out1;
                //assignment_buffer <= assignment_out1;
            
            end else if (started) begin

                if (just_started) begin
                    just_started <=0;
                    sending<=1;
                    address_input <=address_input+1;
                    counter_out <=  counter_out;
                    assignment_buffer <= assignment_out1;
                    assignment_out <= assignment_out1;
                    
                end else begin
                    if(counter_out == limit) begin
                        done <=1;
                        started<=0;
                        sending<=0;
                    end else begin
                        sending<=1;
                        address_input <=address_input+1;
                        counter_out <=  counter_out+1;
                        assignment_buffer <= assignment_out1;
                        assignment_out <= assignment_out1;

                    end



                end



                
            end


        end

        
    end





    
    
endmodule

`default_nettype wire