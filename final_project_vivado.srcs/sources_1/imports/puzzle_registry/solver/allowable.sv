`default_nettype none

module allowable(   
                    input wire clk_in,
                    input wire rst_in,
                    input wire [19:0] current_row,
                    input wire [3:0] total_n_of_rows,
//only for the sake of testing wheterh we saved things correctly in the test bench
                    output logic done,
                    output logic [19:0] assignment_out //for the sake of testing // since thre are 10 fields and each field has two bits (3 states) > 10*2 = 20

    ); 

    logic counter;


    always_ff @(posedge clk_in) begin

    if(rst_in) begin
        counter <=0;
        assignment_out <= 20'b0;
        done<=0;
    end else begin
        if (counter == total_n_of_rows) begin
            done<=1;
        end else begin
            assignment_out <= assignment_out || current_row;
            counter<= counter+1;
        end
        
    end

        
    end






endmodule


`default_nettype wire