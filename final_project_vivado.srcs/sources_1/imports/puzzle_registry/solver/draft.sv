    //__________________________TODO_______________________________________________

                            //TODO: negate the wjile_loop_staretd when you are done with the second for loop


                                //we have just finished the while loop - checking if we need to reenter or output the solution :')
                                if(mod_cols_in[0] +mod_cols_in[1] +mod_cols_in[2] +mod_cols_in[3] + mod_cols_in[4] +mod_cols_in[5]+mod_cols_in[6]+mod_cols_in[7] + +mod_cols_in[8] + mod_cols_in[9]>0) begin
                                    while_loop_started <=1;
                                    //cursed but okey 
                                end else begin
                                    while_loop_started <=0;
                                end

                            end else begin

                            //we are already in teh while  loop so keep going
                                
                            // mod_cols_in_progress<=1;
                                if(start_i_range_w_part) begin

                                //if(counter_mod_col<column_count) begin //we are in the for looop in range(w)

                                    if(mod_cols_in[counter_mod_col] ==1) begin

                                    //--------------enter fix_col section - hell ---------------------

                                        if(end_fix_col) begin
                                            end_fix_col <=0;
                                            counter_mod_col <=counter_mod_col +1;
                                            addr_column <=0;
                                            
                                        end else if (start_enumerate_for_loop_row) begin
                                            
                                            allowed_thing_counter<=allowed_thing_counter+1;
                                            if(allowed_thing_enumrate_fix_col[allowed_thing_counter]~=allowable_output_rows[allowed_thing_counter][counter_mod_col]) begin
                                                mod_rows_in[allowed_thing_counter] <= 1;
                                                allowable_output_rows[allowed_thing_counter][counter_mod_col] <= allowable_output_rows[fix_col_counter][counter_mod_col] && allowed_thing_enumrate_fix_col[allowed_thing_counter];
                                            end

                                            if(allowed_thing_counter == permutation_count_array_column[addr_column]-1) begin
                                                end_fix_col <=1;
                                                addr_col <=0;
                                                start_enumerate_for_loop_row<=0;
                                            end
                                            
                                        end else if( done_create_c_array) begin

                                            //step 2) - after creating array c, create array results

                                            if(permutation_count_array_column[addr_column]>0) begin
                                                    //entered for x in col[n]:

                                                if(for_loop_with_fits_started) begin

                                                    
                                                    column_permutation_counter <= column_permutation_counter+1
                                                    addr_column_permutation<= n_column + addr_column; //this might not work - wrogn clock cycle
                                                    write_permutation_count_column<=0;
                                                    write_permutation_column<=0;

                                                    requested_first_entry<=1;

                                                    if(requested_first_entry) begin

                                                        //i think here we are trying to write and rad in the same click cycle whihcis wrong - maybe do a clockcycle delay or sth ? 
                                                        //ask about this
                                                        if((data_from_permutation_column_bram~=10'b0)&& (data_from_permutation_column_bram && c)) begin

            
                                                            results[column_permutation_counter] <= data_from_permutation_column_bram;
                                                        end else begin
                                                            //fit retursn false so decrese teh avilaible numebr of permutations and zero the registr  (as deleted)
                                                            write_permutation_count_column<=1;
                                                            write_permutation_column<=1;
                                                            results[column_permutation_counter] <= 10'b0;
                                                            data_to_permutation_column_bram <= 10'b0; //mark as all zeross if deldeted
                                                        //data_to_permutation_count_column_bram <= data_from_permutation_count_column_bram -1; // this will not work 
                                                            permutation_count_array_column[addr_column] <= permutation_count_array_column[addr_column]-1;

                                                        end

                                                        if(column_permutation_counter == data_from_permutation_count_column_bram-1) begin

                                                           
                                                            start_enumerate_for_loop_row <=1;
                                                            done_create_c_array<=0
                                                            allowed_thing_enumrate_fix_col <=result[0] || result[2] || ... || result[29];
                                                        end
                                                        
                                                    end
                                                    
                                                end else  begin
                                                    for_loop_with_fits_started<=1;
                                                    n_column <= column_permutation_starts[counter_mod_col]; // get teh starting address of permutations for a given column 
                                                    
                                                end

                                                
                                            end


                                        end else
                                            //step 1 - create c 

                                            //fix_col _counter is nitilized to zero at reset
                                            //allowable_output_rows is array fo arryas quriavelnt to cna do 


                                            c[fix_col_counter] <= allowable_output_rows[fix_col_counter][counter_mod_col];
                                            fix_col_counter <= fix_col_counter+1;
                                            //len_can_do = 9
                                            if(fix_col_counter == 9) begin

                                                done_create_c_array <=1;
                                                fix_col_counter <=0;
                                                
                                            
                                            end
                                        end


                                end else begin

                                    mod_cols_in <=10'b0;
                                    counter_mod_row<=counter_mod_row+1;
                                    start_j_range_h_part<=1;

                                end 

                                //----------------------------end of first part of while loop ---------------------------------

                                if (start_j_range_h_part) begin
                                //mod_cols_not _inprogresms - we are in the for loop in range h

                                    if(mod_rows_in[counter_mod_row] ==1) begin

                                    if( done_fix_row_for_loop) begin

                                        allowed_thing  <= allowable_output_columns[counter_mod_col];
                                        enumerate_counter_row <= enumerate_counter_row+1;


                                        if (allowable_output_columns[counter_mod_col][enumerate_counter]~=allowable_output_rows[fix_col_counter][counter_mod_col])begin
                                            mod_rows_in[enumerate_counter] <=1;
                                            allowable_output_rows[fix_col_counter][counter_mod_col] <= allowable_output_rows[fix_col_counter][counter_mod_col] && allowable_output_columns[counter_mod_col][enumerate_counter];
                                        end
                                        

                                        if (enumerate_counter_row == 9) begin
                                            finish_fix_row <=1;
                                        end


                                    end else
                                        c_fix_row <= allowable_output_rows[counter_mod_row];
                                        fix_row_counter <= fix_col_counter+1;
                                        //len_can_do = 9
                                        if(fix_col_counter == 9) begin

                                            done_fix_col_for_loop <=1;
                                            counter_mod_col<=counter_mod_col+1;
                                        
                                        end
                                    end


                                end else begin
                                    counter_mod_col<=counter_mod_col+1;
                                end

                                if(counter_mod_col ==9) begin
                                    //start the folr loop for modl_row
                                    mod_cols_in <=10'b0;
                                    counter_mod_row<=counter_mod_row+1;
                                    mod_cols_in_progress<=0;

                                end 





                            end



                                





                        
                    end




                end

                





                //im crying









            end