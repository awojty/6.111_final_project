module create_a_row(
    input clk_in,
    input reset_in, 
    output logic [4:0] min_length
)

logic [4:0] i; //acts as afor loop counter
parameter limit = 19;

parameter original = 20'b10101010101010101010;
logic done_counting;

always_ff @(posedge clk_in) begin

    if (new_data) begin
        //2 bit encoding 
        constrain1_len <= constrain1 + constrain1;
        constrain2_len <= constrain2 + constrain2;
        constrain3_len <= constrain3 + constrain3;
        constrain4_len <= constrain4 + constrain4;
        constrain5_len <= constrain5 + constrain5;
        running_sum_1 <= constrain1_len + break1;
        running_sum_2 <= constrain1_len + break1 + constrain2_len;
        running_sum_3 <= constrain1_len + break1 + constrain2_len + break2;
        running_sum_4 <= constrain1_len + break1 + constrain2_len + break2 + constrain3_len;
        running_sum_5 <= constrain1_len + break1 + constrain2_len + break2 + constrain3_len + break3;
        running_sum_6 <= constrain1_len + break1 + constrain2_len + break2 + constrain3_len + break3 + constrain4_len;
        running_sum_7 <= constrain1_len + break1 + constrain2_len + break2 + constrain3_len + break3 + constrain4_len + break4;
        running_sum_8 <= constrain1_len + break1 + constrain2_len + break2 + constrain3_len + break3 + constrain4_len + break4 + constrain5_len ;



        new_row <=original;
        done_counting <=0;

        
    end else begin

        if(i == limit -2 || done_counting) begin
            done <=1;
            assignment_out <= new_row;


        end else begin

            min_length <=running_sum_8;

            if(i <constrain1_len) begin
                //mark colored with 1
                new_row[i] <= 1;
                new_row[i+1] <= 0;
            end else if(i >=constrain1_len && i <running_sum_1) begin
                new_row[i] <= 0;
                new_row[i+1] <= 1;



            end else if(i >=running_sum_1 && i <running_sum_2) begin
                new_row[i] <= 1;
                new_row[i+1] <= 0;
            end else if(i>=running_sum_3 && i <running_sum_4) begin
                new_row[i] <= 0;
                new_row[i+1] <= 1;



            end else if(i>=running_sum_4 && i <running_sum_5) begin
                new_row[i] <= 1;
                new_row[i+1] <= 0;
            end else if(i>=running_sum_5 && i <running_sum_6) begin
                new_row[i] <= 0;
                new_row[i+1] <= 1;


            end else if(i>=running_sum_6 && i <running_sum_7) begin
                new_row[i] <= 1;
                new_row[i+1] <= 0;
            end else if(i>=running_sum_7 && i <running_sum_8) begin
                new_row[i] <= 0;
                new_row[i+1] <= 1;


            end else if(i >=running_sum_8) begin
                //marked the rest as unmarked ( but will be remvoed anyways ? )
                done_counting<=1;
            end



        end
    end

    
end

endmodule