`default_nettype none

module nonogram_registry(   
                    input wire clk_in,
                    input wire [5:0] index,
                    input wire btnc,
                    input wire rst_in,
                    output logic [799:0] assignment_out1,
                    output logic done,
                    output logic sending
    );  

    parameter ADDRESS_SIZE = 31;

    logic [ADDRESS_SIZE:0] address;

    logic [15:0] dimensions;
    logic [799:0] assignment; //uuuuuh is this legal ? 
    logic done_address;

    logic [31:0] counter_out;

    


    address_registry my_address_registry(
        .clk_in(clk_in), 
        .rst_in(rst_in), 
        .confirm_in(btnc), 
        .index_in(index), 
        .address_out(address),
        .done_out(done_address));

    dimensions_registry my_dimensions_registry(
        .clk_in(clk_in), 
        .rst_in(rst_in), 
        .start_in(btnc),
        .index_in(index), 
        .dimensions_out(dimensions));

    assignments_registry my_assignments_registry(
        .clk_in(clk_in), 
        .rst_in(rst_in), 
        .start_in(done_address),
        .row_number_in(dimensions[15:7]),
        .col_number_in(dimensions[6:0]),
        .address_in(address), 
        .assignment_out(assignment_out1),
        .sending(sending),
        .counter_out(counter_out),
        .done(done));

    always_ff @(posedge clk_in) begin

        if(rst_in) begin
            
            
           // assignment_out<=0;

        end 
        
    end




    
    
endmodule

`default_nettype wire