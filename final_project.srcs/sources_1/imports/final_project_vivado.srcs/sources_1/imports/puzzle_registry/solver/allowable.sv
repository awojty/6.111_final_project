`default_nettype none

module allowable(   
                    input wire clk_in,
                    input wire rst_in,
                    input wire start_in, //when asserte, start accumulating
                    input wire [19:0] current_row,
                    input wire [7:0] total_n_of_rows,
//only for the sake of testing wheterh we saved things correctly in the test bench
                    output logic done,
                    output logic [19:0] assignment_out //for the sake of testing // since thre are 10 fields and each field has two bits (3 states) > 10*2 = 20

    ); 

    logic [8:0] counter;
    logic [19:0] current_state;


    always_ff @(posedge clk_in) begin

    if(rst_in) begin
        counter <=0;
        assignment_out <= 20'b0;
        current_state <= 20'b0;
        done<=0;

    
    end else begin
        if (counter == total_n_of_rows) begin
            done<=1;
            assignment_out <= current_state;
        end else begin
            current_state <= current_state || current_row;
            counter<= counter+1;
        end
        
    end

        
    end






endmodule


`default_nettype wire