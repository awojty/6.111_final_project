module fix_col(
    input wire clk_in,
    input wire reset_in,
    input wire start_in,
    input wire [19:0] column_in,
    input wire current_permutation_count,
    input wire number_of_items_in_cols_n,
    input wire done_sending_columns, //asswerted when whole cols[n] is sent
    input wire mod_rows_in,
    input wire can_do_in,

    input wire [9:0] allowable_output_rows [19:0], //there are ten rows of length 20 --alowabale berges or permutaitons into one
    input wire n, // paramter to the function in the python file
    output logic new_permution_count,
    output logic column_out,
    output logic can_do_out,
    output logic mod_rows_out,
    output logic done_fix_col

);

    permutation_bram column_collector_bram(
            .addra(addr_column), 
            .clka(clk_in), 
            .dina(data_to_collector_bram), 
            .douta(data_from_collector_bram), 
            .ena(1), 
            .wea(write_collector_bram)); 

    permutation_bram can_do_collector_bram(
            .addra(addr_can_do), 
            .clka(clk_in), 
            .dina(data_to_can_do_bram), 
            .douta(data_from_can_do_bram), 
            .ena(1), 
            .wea(write_can_do_bram)); 

    permutation_bram results_bram(
            .addra(addr_column), 
            .clka(clk_in), 
            .dina(data_to_results_bram), 
            .douta(data_from_results_bram), 
            .ena(1), 
            .wea(write_results_bram)); 

    logic [9:0] can_do [19:0]; // arrya of 10 items fo elnght 20 (20bits)
    logic [9:0] mod_rows;

    always_ff @(posedge clk_in) begin


        if (reset_in) begin
            fix_col_counter<=0;
            addr_column<=0; // used to count max count of column permutations
            max_col_count<=0; // sued to just access the gvien column
            allowed_thing_counter<=0;
            
        end else begin


            if(start_in && ~start_creating_c_array) begin

            //frist transfer all the columns form column[n]
                permuation_counter<=current_permutation_count;
                mod_rows<=mod_rows_in;
                can_do <= can_do_in;

                if(done_sending_column) begin
                    start_creating_c_array <=1;
                     write_collector_bram<=0;
                     max_col_count<=addr_column;
                     
                     addr_column<=0;
                end else begin
                    write_collector_bram<=1;

                    addr_column<=addr_column+1;
                    data_to_collector_bram<=column_in,

                end

                if(done_sending_can_do) begin
                    write_can_do_bram<=0;
                    max_can_do_count<=addr_can_do;
                    addr_can_do_column<=0;

                end else begin
                    write_can_do_bram<=1;
                    addr_can_do<=addr_can_do+1;
                    data_to_can_do_bram<=can_do_in,

                    can_do[addr_can_do] <=data_to_can_do_bram;

                end

                if (done_sending_column && done_sending_can_do) begin
                    start_creating_c_array<1=;
                    

                end
                
            end else if(start_creating_c_array ) begin
                //start with creatign array c

                

                c[fix_col_counter] <= can_do[fix_col_counter][n];
                fix_col_counter <= fix_col_counter+1;
                                            //len_can_do = 9
                if(fix_col_counter == 9) begin

                    done_create_c_array <=1;
                    fix_col_counter <=0;
                                                                  
                end

            end else if (done_create_c_array && ~done_with_for_x_cols_n) begin


                if(number_of_items_in_cols_n>0) begin
                    
                    x<=data_from_collector_bram;
                    requested_first_entry<=1;
                    addr_col<=addr_col+1;
                    // column_permutation_counter <= column_permutation_counter+1
                    // addr_column_permutation<= n_column + addr_column; //this might not work - wrogn clock cycle
                    // write_permutation_count_column<=0;
                    // write_permutation_column<=0;

                    
                    if(requested_first_entry) begin

                        if((data_from_collector_bram~=10'b0)&& (data_from_collector_bram && c)) begin
                            data_to_results_bram <= data_from_collector_bram;
                            write_results_bram <=1;
                            allowed_things <= allowed_things || data_from_collector_bram;
                        end else begin
                            //fit retursn false so decrese teh avilaible numebr of permutations and zero the registr  (as deleted)
                            write_results_bram <=1;
                            data_to_results_bram <= 10'b0; //mark as all zeross if deldeted
                            permutation_count <= permutation_count-1;
                            allowed_things <= allowed_things || 10'b0;
                        end

                        if(addr_column == max_col_count-1) begin
                            //we finished the for loop to create resutl array                
                                start_enumerate_for_loop_row <=1;
                        end
                                                        
                                                    
                end else begin

                    //cols[n] is empty so move forward 
                    done_with_for_x_cols_n <=1;
                    done_with_for_x_cols_n <=1;
                    done_create_c_array <=1;
                    start_enumerate_for_loop_row<=1;

                end

            end else if (start_enumerate_for_loop_row) begin

            //this for loop always gors from 0 to 9 inclsuvei since to goes through the itsm in the allwoablae things which is a single arrya f length 10 

                allowed_thing_counter<=allowed_thing_counter+1;
                

                if(allowed_things[allowed_thing_counter]~=can_do[allowed_thing_counter][n]) begin
                    mod_rows_in[allowed_thing_counter] <= 1;
                    can_do[allowed_thing_counter][n] <= can_do[allowed_thing_counter][n] && allowed_things[allowed_thing_counter];
                end

                    if(allowed_thing_counter == 10-1) begin
                        end_fix_col <=1;
                        addr_col <=0;
                        start_enumerate_for_loop_row<=0;
                    end
                                            
                
            end else if (end_fix_col) begin

                //tarsnfer global variabls fuck 

                can_do_out <= can_do;
                mod_rows_out<=mod_rows;
                new_permution_count<= permutation_count;

                //can_do
                //mod_rwos_in
                //cols will be mapped by results
                //numebr of permutaiotns in cols[n decrease sice we remvoed sth by the fits(x,c) 

                if(addr_column == max_col_count-1) begin
                    done_fix_col<=1;
                    end_fix_col<=0;
                    addr_column<=0;

                end else begin
                    write_result_bram<=0;
                    addr_column<=addr_column+1;
                    column_out<=data_from_result_bram;

                end

            end
            
        end
        

    end

endmodule
