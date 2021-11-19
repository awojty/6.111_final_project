`default_nettype none
//TODO - rememebr the can do - each elemtn is two bits long

module translator(   
                    input wire clk_in,
                    input wire reset_in,
                    input wire start_in,
                    input wire [19:0] row1,
                    input wire [19:0] row2, 
                    input wire [19:0] row3, 
                    input wire [19:0] row4,
                    input wire [19:0] row5, 
                    input wire [19:0] row6,
                    input wire [19:0] row7, 
                    input wire [19:0] row8,
                    input wire [19:0] row9, 
                    input wire [19:0] row10,

                    output logic [9:0] row1_out,
                    output logic [9:0] row2_out, 
                    output logic [9:0] row3_out, 
                    output logic [9:0] row4_out,
                    output logic [9:0] row5_out, 
                    output logic [9:0] row6_out,
                    output logic [9:0] row7_out, 
                    output logic [9:0] row8_out,
                    output logic [9:0] row9_out, 
                    output logic [9:0] row10_out, 
        
                    output logic solution_out
                    
    ); 



    logic [19:0] row1_collect;
    logic [19:0] row2_collect;
    logic [19:0] row3_collect;
    logic [19:0] row4_collect;
    logic [19:0] row5_collect;
    logic [19:0] row6_collect;
    logic [19:0] row7_collect;
    logic [19:0] row8_collect;
    logic [19:0] row9_collect;
    logic [19:0] row10_collect;
 


    logic [9:0] row1_assign;
    logic [9:0] row2_assign;
    logic [9:0] row3_assign;
    logic [9:0] row4_assign;
    logic [9:0] row5_assign;
    logic [9:0] row6_assign;
    logic [9:0] row7_assign;
    logic [9:0] row8_assign;
    logic [9:0] row9_assign;
    logic [9:0] row10_assign;

    logic done_collecting;
    logic start_returning;
    


    always_ff @(posedge clk_in) begin


        if(reset_in) begin
            i<=0;

            done_collecting <=0;
            start_returning <=0;

            row1_assign<=0;
            row2_assign<=0;
            row3_assign<=0;
            row4_assign<=0;
            row5_assign<=0;
            row6_assign<=0;
            row7_assign<=0;
            row8_assign<=0;
            row9_assign<=0;
            row10_assign<=0;

            row1_collect <=0;
            row2_collect <=0;
            row3_collect <=0;
            row4_collect <=0;
            row5_collect <=0;
            row6_collect <=0;
            row7_collect <=0;
            row8_collect <=0;
            row9_collect <=0;
            row10_collect <=0;

            
        end else begin



            if(start_in && ~done_collecting) begin

                row1_collect<=row1;
                row2_collect<=row2;
                row3_collect<=row3;
                row4_collect<=row4;
                row5_collect<=row5;
                row6_collect<=row6;
                row7_collect<=row7;
                row8_collect<=row8;
                row9_collect<=row9;
                row10_collect<=row10;

                done_collecting <=1;
               

            end else if (done_collecting) begin

                if(i == 9) begin
                    
                    done_collecting <=0;
                    start_returning <=1;
                end

                i<=i+1;
                i_big <= i_big + 2;

                if(row1_collect[i_big+1:i_big] == 1)begin
                    row1_assign[i] <= 1'b1;
                    
                end else begin
                    row1_assign[i] <= 1'b0;

                end

                if(row2_collect[i_big+1:i_big] == 1)begin
                    row2_assign[i] <= 1'b1;
                    
                end else begin
                    row2_assign[i] <= 1'b0;

                end

                if(row3_collect[i_big+1:i_big] == 1)begin
                    row3_assign[i] <= 1'b1;
                    
                end else begin
                    row3_assign[i] <= 1'b0;

                end

                if(row4_collect[i_big+1:i_big] == 1)begin
                    row4_assign[i] <= 1'b1;
                    
                end else begin
                    row4_assign[i] <= 1'b0;

                end

                if(row5_collect[i_big+1:i_big] == 1)begin
                    row5_assign[i] <= 1'b1;
                    
                end else begin
                    row5_assign[i] <= 1'b0;

                end

                if(row6_collect[i_big+1:i_big] == 1)begin
                    row6_assign[i] <= 1'b1;
                    
                end else begin
                    row6_assign[i] <= 1'b0;

                end

                if(row7_collect[i_big+1:i_big] == 1)begin
                    row7_assign[i] <= 1'b1;
                    
                end else begin
                    row7_assign[i] <= 1'b0;

                end

                if(row8_collect[i_big+1:i_big] == 1)begin
                    row8_assign[i] <= 1'b1;
                    
                end else begin
                    row8_assign[i] <= 1'b0;

                end

                if(row9_collect[i_big+1:i_big] == 1)begin
                    row9_assign[i] <= 1'b1;
                    
                end else begin
                    row9_assign[i] <= 1'b0;

                end

                if(row10_collect[i_big+1:i_big] == 1)begin
                    row10_assign[i] <= 1'b1;
                    
                end else begin
                    row10_assign[i] <= 1'b0;

                end
                



            end else if (start_returning) begin

                done <=1;
                row1_out <=row1_assign;
                row2_out <=row2_assign;
                row3_out <=row3_assign;
                row4_out <=row4_assign;
                row5_out <=row5_assign;
                row6_out <=row6_assign;
                row7_out <=row7_assign;
                row8_out <=row8_assign;
                row9_out <=row9_assign;
                row10_out <=row10_assign;


            end






        end
        


    end


    
    
endmodule

`default_nettype wire