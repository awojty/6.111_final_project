`default_nettype none

module iterative_solver(   
                    input wire clk_in,
                   
                    input wire reset_in,
                    input wire [7:0] index_in,
                    input wire [7:0] col_number_in,
                    input wire [7:0] row_number_in,
                    input wire [31:0] address_in,
                    input wire [9:0] assignment_in,
                    input wire [31:0] counter_in,
                    input wire start_sending_nonogram,
                    input wire testing, //only for the sake of testing wheterh we saved things correctly in the test bench
                    output logic solution_out,
                    output logic [799:0] assignment_out //for the sake of testing
    );  
    
    logic [799:0] assignment;
    logic [31:0] address_input;
    logic [31:0] counter;
    logic started;
    logic [8:0] limit; // limit 200+200 = 400 > 9 bits

    //save to bram temporary nongoram that you accessed from registry
    //we onlyu save one nongoram to this beram - the oen we are currentyl sovling so we idnesx the elemtne by starting at 0 


    logic [19:0] data_to_bram; // eacho column is ecnoded by 5*4 > at most 5 numbers, the biggeest is 10 (4bits)
    logic [19:0] data_from_bram;

    logic [31:0] addr;

    logic [7:0] col_number;
    logic [7:0] row_number;
    logic write;

    logic number_of_breaks;

    logic [9:0] mod_rows_in;

    logic [9:0] mod_cols_in;
    
//cosndier storing in 2 brams (one for cosl and one for rows? )
// 200 entries where each entry is oen row, in each entry there are 200 bits, intilized to lal 0's 

// currently impelentaed as arrya of arrays, maybee it will work better with bram ? 
    logic [9:0] solution [9:0];

    logic [31:0] addr_row; //to put all genrated rows into bram
    logic [31:0] addr_col; //to put all genrated rows into bram

    logic [3:0] counter_mod_col;

    //bram taht stroes all posilbe rows for each row assingemnet given 
    all_possible_rows current_assignment_bram(
            .addra(addr_row_permutation), 
            .clka(clk_in), 
            .dina(data_to_row_permutation_bram), 
            .douta(data_from_rom_permutation_bram), 
            .ena(1), 
            .wea(write_permutation_row));   

    //bram taht stroes all posilbe cols states for each col assingemnet given 
    all_possible_columns current_assignment_bram(
            .addra(addr_column_permutation), 
            .clka(clk_in), 
            .dina(data_to_column_permutation_bram), 
            .douta(data_from_column_permutation_bram), 
            .ena(1), 
            .wea(write_permutation_column));   


    //stores the count of permutations for the column at each index
    permutation_count_bram my_permutation_count_bram_column(
            .addra(addr_column), 
            .clka(clk_in), 
            .dina(data_to_permutation_count_column_bram), 
            .douta(data_from_permutation_count_column_bram), 
            .ena(1), 
            .wea(write_permutation_count_column)); 

    permutation_count_bram my_permutation_count_bram_row(
            .addra(addr_row), 
            .clka(clk_in), 
            .dina(data_to_permutation_count_row_bram), 
            .douta(data_from_permutation_count_row_bram), 
            .ena(1), 
            .wea(write_permutation_count_row)); 

    //stores constraints to eachcolumn (from left to right)
    constraints_bram col_constraints_bram(
            .addra(addr_constraint_column), 
            .clka(clk_in), 
            .dina(data_to_column_bram), 
            .douta(data_from_column_bram), 
            .ena(1), 
            .wea(write_constraint_column)); 

    //stores constraints to each row (from top to bottom)
    constraints_bram row_constraints_bram(
            .addra(addr_constraint_row), 
            .clka(clk_in), 
            .dina(data_to_row_bram), 
            .douta(data_from_row_bram), 
            .ena(1), 
            .wea(write_constraint_row)
            );   

    //stores number of "numbers" above each row (so n_of_breaks = n_of_numbers - 1)
    //new module to implemetn registry to store that numbers is necessary 
    count_of_constraints count_contraints_column_bram(
            .addra(addr), 
            .clka(clk_in), 
            .dina(data_to_bram), 
            .douta(data_from_bram), 
            .ena(1), 
            .wea(write));  

    count_of_constraints count_contraints_row_bram(
            .addra(addr), 
            .clka(clk_in), 
            .dina(data_to_bram), 
            .douta(data_from_bram), 
            .ena(1), 
            .wea(write)); 


    generate_rows my_generate_rows(   
                    .clk_in(clk_in),
                    .start_in(start_generating),
                    .assignment(selected_assignment),
                    .number_of_constraints(n_of_constraints),//at most 4 breaks
                    .done(done_generation),
                    .new_row(new_permutation)
                    output logic count //returns the tola nbumber of optison returend for a given setging

    );  

    logic [2:0] n_of_constraints; //number of "numebrs" in a given array of cosntraints

    logic done_generation; //outptu from generate rows - says if they finsihed returnng all teh eprmutation for a given row
    logic new_permutation;
    //selected_assignemnt is usead as an imput regsier to geenrate_rows


    allowable my_allowable(   
                    input wire clk_in,
                    input wire rst_in,
                    .current_row(allowable_input), // inpu a genrates state 
                    input wire [3:0] total_n_of_rows,
//only for the sake of testing wheterh we saved things correctly in the test bench
                    output logic done,
                    output logic [19:0] assignment_out //for the sake of testing // since thre are 10 fields and each field has two bits (3 states) > 10*2 = 20

    ); 

    logic [19:0] allowable_input; //20 bits since each cell impelemned as 2 bit number


    solution_bram solution_bram_column(
            .addra(addr_solution), 
            .clka(clk_in), 
            .dina(data_to_solution_column_bram), 
            .douta(data_from_solution_bram), 
            .ena(1), 
            .wea(write_solution_column)); 
    solution_bram solution_bram_row(
            .addra(addr_solution), 
            .clka(clk_in), 
            .dina(data_to_solution_row_bram), 
            .douta(data_from_solution_row_bram), 
            .ena(1), 
            .wea(write_solution_row)); 


    logic [100:0] start_addresses;  //straes teh start adddres of rows/ columns at the index  i 
    logic [200:0] allowable_start_addresses; //stores start adderss for each rows/col in the allwoable bram 

    logic [9:0] mod_cols_in;
    logic [9:0] mod_rows_in;
    logic [19:0] c;

    logic [9:0] allowable_output_rows [19:0]; // 10 roes each is 20 len

    logic [29:0] results [19:0]; // this can potenailly store all the permutations (which is about 30 for 10x10 case)
    logic results_counter;

    always_ff @(posedge clk_in) begin

        if(reset_in) begin
            // on init, nitilzie he bram to all zeros :)
            counter_out <=0;
            started<=0;
            column_number <=0;
            row_number <=0;
            write <=0;

            solution <= 0;

            row_done <=0;
            column_done <=0;
            addr_row_permutation <=0;
            addr_column_permutation<=0;
            mod_cols_in <=10'b0;
            mod_rows_in <=10'b0;
            c <=20'b0;
            
        end else begin
            if(start_sending_nonogram) begin
                //we have just started sending a nongoram - send constrina lien by csontrint, first rows then columns
                addr_row <= addr_row+1;
                column_number <= column_number_in;
                row_number <= row_number_in;
                saving <=1;
                data_to_bram <= assignment_in;
                write <=1;
                done_generation <=0; //marked as 0 if we finished generating al states for all comuns and rows
                limit <= row_number_in + column_number_in;


            
            end else if (saving) begin
                if(done) begin
                    saving<=0;
                    //addr <= 0;
                    write_constraint_column <=0;
                    write_constraint_row <=0;
                    addr_column <= 0;
                    addr_row <= 0;
                end else begin
                    if(counter_in>=row_number) begin
                        //we have finished sending all the rows, now we are sending all the columsn 
                        write_constraint_column <=1;
                        write_constraint_row <=0;
                        addr_column <= addr_column+1;
                        data_to_column_bram  <= assignment_in;
                        
                    end else begin
                        //we are still sending rows
                        write_constraint_column <=0;
                        write_constraint_row <=1;
                        addr_row <= addr_row+1;
                        data_to_row_bram  <= assignment_in;    

                    end

                end
                
            end else if(~saving) begin

                if(testing) begin
                    //for the sake of running the testbench
                    addr <= 0;
                    write <=0;
                    
                end

                //1) gerenate all rows for each row
                if(~done_generation) begin
                    


                    //program staretd returning all possible cases of rows for already assigned row

                    if( ~row_done) begin
                    //if im genreating rows
                        addr_row_permutation <= addr_row_permutation+1;
                        data_to_row_permutation_bram <= new_permutation;
                        n_of_constraints <=permutation_count;
                        write_permutation_column <=0;
                        write_permutation_row <=1;

                        
                        
                    end else if ( ~column_done) begin
                    //if im gerneating columns
                        addr_column_permutation <= addr_column_permutation+1;
                        data_to_column_permutation_bram <= new_assignment;
                        n_of_constraints <=permutation_count;
                        write_permutation_column <=1;
                        write_permutation_row <=0;
                        
                    end

                //below we are done with permutation geenration 
                    
                end else begin
                    //im done genraitng permtuations for a given row/column - move to anoterh oen 
                    
                    addr_constraint<=addr_constraint+1;
                    //i saved forst rows then oclumns i nthe bram asingemtn 
                    if(addr_constraint == row_number_in-1) begin
                        row_done <=1;
                        column_done <=0;
                        write_permutation_row <=0;
                        
                    end 

                    //start a new assingemnt genertaiont
                    if(~row_done) begin
                        //when im currently gerneting rows
                        data_to_permutation_count_row_bram <= n_of_constraints;
                        selected_assignment <= data_from_row_bram;
                        //start_addresses[addr_constraint+1] <=addr_row;
                        addr_row <= addr_row+1;
                        write_permutation_count_row <=1;
                        write_permutation_count_column <=0;
                    end else begin
                        //when im currently gerneting cols
                        data_to_permutation_count_column_bram <= n_of_constraints;
                        selected_assignment <= data_from_column_bram;
                        //start_addresses[addr_constraint+1] <=addr_col;
                        addr_column <= addr_column+1;
                        write_permutation_count_row <=0;
                        write_permutation_count_column <=1;
                    end

                
                //we finished genreating all the possible rows and cols > switch to another row

                    if(addr_constraint == row_number_in + col_number_in -1) begin

                        //possibel bug that teh alst one is not saved ? 

                        row_done <=1;
                        column_done <=1;
                        start_generating <=0;
                        write_permutation_column <=0;
                        write_permutation_row <=0;
                        addr_row <= 0;
                        addr_column <= 0;

                        allowable_counter <=allowable_counter+1; //counts if we submitted all the permutations
                    
                    //i have collected all nthe possibel assignements
                        //2) do consolidate allowed rows (allowable function)

                        if(addr_solution_row <row_count) begin
                            //we are sednign rows
                            addr_row_permutation <= addr_row_permutation+1;
                            allowable_input <= data_from_permutation_row_bram;
                            current_permutation_count <= data_from_permutation_count_row_bram;
                            write_solution_row<=0;
                            write_solution_column<=0;

                            if(addr_row_permutation == current_permutation_count-1)begin
                                //we have sent all the permtuations for teh given row - switch to a differnt row
                                data_to_solution_row_bram<=allowable_out;
                                allowable_output_rows[addr_solution_row]<=allowable_out;
                                addr_solution_row<=addr_solution_row+1;
                                write_solution_row<=1;

                            end
                            
                        end else  if (addr_solution_column <column_count) begin
                            //we are sending columns
                            addr_column_permutation <= addr_column_permutation+1;
                            allowable_input <= data_from_permutation_column_bram;
                            current_permutation_count <= data_from_permutation_count_column_bram;
                            write_solution_row<=0;
                            write_solution_column<=0;

                            if(addr_column_permutation == current_permutation_count-1)begin
                                //we have sent all the permtuations for teh given row - switch to a differnt row
                                data_to_solution_columun_bram<=allowable_out;
                                addr_solutionc_column<=addr_solution_column+1;
                                write_solution_column<=1;

                            end
                            
                        end else begin
                            //we computed all allowable fro both rows and columns - i think dont really need to do it for columns
                            //

                            allowable_done <=1;
                            
                        end

                        if(allowable_done) begin
                            // im done with    
                            //for r in rows:
                            //  can_do.append(allowable(r))

                            //3) while loop for mod_col

                            //solution bram has the cand = allwoable_row = soltuion_row
                            //fix_col_counter = i
                            //counter_nod_col = n


                        //while
                            if(mod_cols_in[0] +mod_cols_in[1] +mod_cols_in[2] +mod_cols_in[3] + mod_cols_in[4] +mod_cols_in[5] +mod_cols_in[9]>0) begin
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


        end

        
    end





    
    
endmodule

`default_nettype wire