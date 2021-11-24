`default_nettype none

module filter(   
                    input wire clk_in,
                    input wire reset_in,
                    input wire start_in, //when asserte, start accumulating
                    input [320:0] wire [240:0] photo_in,
                    output logic done, //320 by 240
                    output logic [40:0] rescaled_out [30:0]//for the sake of testing // since thre are 10 fields and each field has two bits (3 states) > 10*2 = 20

    ); 


    logic [320:0] photo_stored [240:0];
    logic start_rescaling;

    parameter [6:0] new_h = 30;
    parameter [6:0] new_w = 40;
    parameter [6:0] number_shifts_h = 3;
    parameter [6:0] number_shifts_w = 3;

    logic solution_out;



    always_ff @(posedge clk_in) begin
        
        if(reset_in) begin
            start_rescaling <=0;
            start_i_for_loop <=0;
            end_i_for_loop <=0;
            solution_out <=0;
            
        end else begin

            if (start_in && ~start_rescaling) begin

                photo_stored <= photo_in;
                start_i_for_loop <=1;


            end else if (start_i_for_loop) begin

                if(i == new_h) begin
                    solution_out <=1;
                    start_i_for_loop <=0;
                    i<=0;
                end else begin
                    start_i_for_loop <=0;
                    start_j_for_loop <1=;

                end


            end else if (end_i_for_loop) begin

                i<= i +1;
                start_i_for_loop <=1;
                end_i_for_loop <=0;
            
                
            end else if (start_j_for_loop) begin
                if(j == new_w) begin
                    start_i_for_loop <=1;
                    start_j_for_loop<=1;
                    
                end else begin
                    start_j_for_loop <=0;
                    processing_part <=1;

                end

            end else if (end_j_for_loop) begin

                j<= j +1;
                start_j_for_loop <=1;
                end_j_for_loop <=0;
                
            end else if (processing_part) begin

                if(~multiplication_processing_done) begin
                    multiplication_processing_done <=1;
                    if_statement_part <=1;
                    x <= i << number_shifts_h;
                    y <= j << number_shifts_w;



                end else if (if_statement_part) begin
                    rescaled_out_internal[i][j] <=photo_stored[x][y];
                    if_statement_part<=0;
                    processing_part<=0;
                    multiplication_processing_done <=0;

                end


            end else if (solution_out) begin
                done <=1;
                rescaled_out <= rescaled_out_internal;

            end




            
        end
    end

endmodule