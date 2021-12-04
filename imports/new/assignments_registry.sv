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
    
   
    
    
    


    

    logic started;

    logic [8:0] limit; // limit 200+200 = 400 > 9 bits

    //width of 20 height if at least 20 since at least for one nonogram

    logic [19:0] assignment_out1;
    logic [19:0] assignment_buffer;
    logic [19:0] assignment_buffer1;
    logic just_started;
    logic hello;
    logic [1:0] lol;
    logic acquired_address;


    assignments_rom  my_assignment_rom(.clka(clk_in), .addra(address_input), .douta(assignment_out1));

    always_ff @(posedge clk_in) begin

        if(reset_in) begin
            hello <=0;
            counter_out <=0;
            started<=0;
            sending<=0;
            done<=0;
            address_input<=0;
            assignment_out<=0;
            limit <=0;
            just_started <=0;
           // assignment_out1 <=0;
           acquired_address <=0;
           assignment_buffer1 <=0;
            
        end else begin
            if(start_in && ~acquired_address  && ~started) begin
                //address_input <= 21;
                lol <=address_in[15:14];
                address_input <= address_in[15:14] * 5'd20; //switch 15 adn 14 serve as adressing to select nonogram - so 4 in total to select from
                acquired_address <=1;

                limit <= 20;
                just_started <=1;
                //assignment_out <= assignment_out1;
                //assignment_buffer <= assignment_out1;
            end else if (acquired_address) begin
                address_input <=address_input+1;
                started <=1;
                counter_out <= 0;
                //assignment_buffer <= assignment_out1;
                //assignment_out <= assignment_out1;
                acquired_address <=0;
            
//            end
            
            end else if (started) begin

                if (just_started) begin
                    just_started <=0;
                    
                    address_input <=address_input+1;
                    counter_out <=  counter_out;
                    assignment_buffer <= assignment_out1;
                    assignment_buffer1 <= assignment_buffer;
                    assignment_out <= assignment_buffer1;
                    hello <=1;
                    
                end else begin
                    if(counter_out == limit-1) begin
                        done <=1;
                        started<=0;
                        sending<=0;
                    end else begin
                        sending<=1;
                        address_input <=address_input+1;
                        if(hello) begin
                        hello <=0;
                        counter_out <=  0;
                        end else begin
                        counter_out <=  counter_out+1;
                        end
                        
                       assignment_buffer <= assignment_out1;
                    assignment_buffer1 <= assignment_buffer;
                    assignment_out <= assignment_out1;

                    end



                end



                
            end


        end

        
    end





    
    
endmodule

`default_nettype wire
