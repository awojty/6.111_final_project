module create_a_row(
    input wire clk_in,
    input wire reset_in, 
    input wire new_data, // assertes if sth new appears on the input (new cosntrins)
    input wire [3:0] constrain1,
    input wire [3:0] constrain2,
    input wire [3:0] constrain3,
    input wire [3:0] constrain4,
    input wire [3:0] constrain5,
    input wire [3:0] number_of_constraints,
    input wire [3:0] break1,
    input wire [3:0] break2,
    input wire [3:0] break3,
    input wire [3:0] break4,
    output logic [19:0] assignment_out, // 2- bit row output sic eeach cell encode by 2 bits
    output logic done,
    output logic [4:0] min_length
);

//tested - on new input 

logic [4:0] i; //acts as afor loop counter

logic [5:0] running_sum_1; //5 bits sinnce max numebr is 20
logic [5:0] running_sum_2;
logic [5:0] running_sum_3;
logic [5:0] running_sum_4;
logic [5:0] running_sum_5;
logic [5:0] running_sum_6;
logic [5:0] running_sum_7;
logic [5:0] running_sum_8;

logic [19:0] new_row; //saves progrss
parameter limit = 20;

parameter original = 20'b10101010101010101010;
logic done_counting;
logic start_counting;

always_ff @(posedge clk_in) begin


    if(reset_in) begin

        i<=0;
        done_counting <=0;
        new_row <=0;
        start_counting <=0;
        assignment_out<=0;
        done<=0;
        min_length<=0;
        running_sum_1<=0; //5 bits sinnce max numebr is 20
        running_sum_2<=0;
        running_sum_3 <=0;
        running_sum_4<=0;
        running_sum_5<=0;
        running_sum_6<=0;
        running_sum_7<=0;
        running_sum_8<=0;
        

    end else if (new_data && ~start_counting) begin
        
        //2 bit encoding 

        //tODO how to map the fact that we have 2 btos per cell ? 

        //TODO : this is wrong since the _len will be udpated in the nextclcockcycle

        //we omit oen sicne create row is never called on one constrni set ups 01.01.01.01.101010100101

//        running_sum_1 <= constrain1 + constrain1 + break1+ break1 +2'd2; // always add tiwce sicne we migrate from 10 to 20
//            running_sum_2 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 +2'd2;
//            running_sum_3 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 +2'd2;
//            running_sum_4 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 +2'd2;
//            running_sum_5 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 +2'd2;
//            running_sum_6 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 +2'd2;
//            running_sum_7 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 +2'd2;
//            running_sum_8 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 + constrain5 +constrain5 + 2'd2;



        if(number_of_constraints == 2) begin
            

            running_sum_1 <= constrain1 + constrain1 + break1+ break1 +2; // always add tiwce sicne we migrate from 10 to 20
            running_sum_2 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 +2;
            running_sum_3 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 +2'd2;
            running_sum_4 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 +2'd2;
            running_sum_5 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 +2'd2;
            running_sum_6 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 +2'd2;
            running_sum_7 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 +2'd2;
            running_sum_8 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 + constrain5 +constrain5 + 2'd2;

        end else if(number_of_constraints == 3) begin

            running_sum_1 <= constrain1 + constrain1 + break1+ break1 +2; // always add tiwce sicne we migrate from 10 to 20
            running_sum_2 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 +2;
            running_sum_3 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 +4;
            running_sum_4 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 +4;
            running_sum_5 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 +4;
            running_sum_6 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 +4;
            running_sum_7 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 +4;
            running_sum_8 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 + constrain5 +constrain5 +4;

        end else if(number_of_constraints == 4) begin

            running_sum_1 <= constrain1 + constrain1 + break1+ break1 +2; // always add tiwce sicne we migrate from 10 to 20
            running_sum_2 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 +2 ;
            running_sum_3 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 +4;
            running_sum_4 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 +4;
            running_sum_5 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 +6;
            running_sum_6 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 +6;
            running_sum_7 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 +6;
            running_sum_8 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 + constrain5 +constrain5 +6;
            
        end  else if(number_of_constraints == 5) begin                
            
            running_sum_1 <= constrain1 + constrain1 + break1+ break1 +2; // always add tiwce sicne we migrate from 10 to 20
            running_sum_2 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 +2 ;
            running_sum_3 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 +4;
            running_sum_4 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 +4;
            running_sum_5 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 +6;
            running_sum_6 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 +6;
            running_sum_7 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 +8;
            running_sum_8 <= constrain1 + constrain1 + break1+ break1 + constrain2 + constrain2 + break2 + break2 + constrain3 + constrain3 + break3 + break3 + constrain4 + constrain4 + break4 + break4 + constrain5 +constrain5 +8;

        end



        //reset values on new input 
        new_row <=original;
        done_counting <=0;
        start_counting <=1;
        done <=0;
        i<=0;
        assignment_out<=0;
        
        min_length<=0;


        
    end else if (start_counting) begin

        if( done_counting) begin
            done <=1;
            assignment_out <= new_row;
            start_counting <=0;
            done_counting<=0;
            i<=0;


        end else begin

            min_length <=running_sum_8;
            i<=i+2;

            if(i < (constrain1 + constrain1)) begin
                //mark colored with 1
                new_row[i] <= 1;
                new_row[i+1] <= 0;
            end else if((i >=(constrain1 + constrain1)) && (i <running_sum_1)) begin
                new_row[i] <= 0;
                new_row[i+1] <= 1;
            end else if((i >=running_sum_1) && (i <running_sum_2)) begin
                new_row[i] <= 1;
                new_row[i+1] <= 0;
            end else if((i>=running_sum_2) && (i <running_sum_3)) begin
                new_row[i] <= 0;
                new_row[i+1] <= 1;
            end else if((i>=running_sum_3) && (i <running_sum_4)) begin
                new_row[i] <= 1;
                new_row[i+1] <= 0;
            end else if((i>=running_sum_4) && (i <running_sum_5)) begin
                new_row[i] <= 0;
                new_row[i+1] <= 1;
            end else if((i>=running_sum_5) && (i <running_sum_6)) begin
                new_row[i] <= 1;
                new_row[i+1] <= 0;
            end else if((i>=running_sum_6) && (i <running_sum_7)) begin
                new_row[i] <= 0;
                new_row[i+1] <= 1;
            end else if((i>=running_sum_7) && (i <running_sum_8)) begin
                new_row[i] <= 1;
                new_row[i+1] <= 0;


            end 
            
            if(i >=running_sum_8) begin
                //marked the rest as unmarked ( but will be remvoed anyways ? ) 10.01.01.01.10.10.10.10.01.01
                done_counting<=1;
                
            end



        end
    end

    
end

endmodule