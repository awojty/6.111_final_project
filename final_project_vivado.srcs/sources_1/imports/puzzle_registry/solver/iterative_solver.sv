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


    all_possible_rows current_assignment_bram(
            .addra(addr_row), 
            .clka(clk_in), 
            .dina(data_to_row_bram), 
            .douta(data_from_rom_bram), 
            .ena(1), 
            .wea(write_row));   



    
    all_possible_columns current_assignment_bram(
            .addra(addr_col), 
            .clka(clk_in), 
            .dina(data_to_col_bram), 
            .douta(data_from_col_bram), 
            .ena(1), 
            .wea(write_column));   

    nonogram_assignement_bram current_assignment_bram(
            .addra(addr_constraint), 
            .clka(clk_in), 
            .dina(data_to_bram), 
            .douta(data_from_bram), 
            .ena(1), 
            .wea(write_constraint));   

    //stores number of "numbers" above each row (so n_of_breaks = n_of_numbers - 1)
    //new module to implemetn registry to store that numbers is necessary 
    count_of_constraints current_assignment_bram(
            .addra(addr), 
            .clka(clk_in), 
            .dina(data_to_bram), 
            .douta(data_from_bram), 
            .ena(1), 
            .wea(write));  


    generate_rows my_generate_rows(   
                    input wire clk_in,
                    input wire start_in,
                    .assignment(data_from_bram),
                    input wire [2:0] number_of_constraints,//at most 4 breaks
                    .done(done_generation),
                    .new_row(new_assignment)
                    output logic count //returns the tola nbumber of optison returend for a given setging


    );  


    allowable my_allowable(   
                    input wire clk_in,
                    input wire rst_in,
                    input wire [19:0] current_row,
                    input wire [3:0] total_n_of_rows,
//only for the sake of testing wheterh we saved things correctly in the test bench
                    output logic done,
                    output logic [19:0] assignment_out //for the sake of testing // since thre are 10 fields and each field has two bits (3 states) > 10*2 = 20

    ); 


    solution_bram current_state_nonogram(
            .addra(addr_solution), 
            .clka(clk_in), 
            .dina(data_to_solution_bram), 
            .douta(data_from_solution_bram), 
            .ena(1), 
            .wea(write)); 


    logic [100:0] start_addresses;  //straes teh start adddres of rows/ columns at the index  i 
    logic [200:0] allowable_start_addresses; //stores start adderss for each rows/col in the allwoable bram 


    always_ff @(posedge clk_in) begin

        if(reset_in) begin
            // on init, nitilzie he bram to all zeros :)
            counter_out <=0;
            started<=0;
            col_number <=0;
            row_number <=0;
            write <=0;

            solution <= 0;
            
        end else begin
            if(start_sending_nonogram) begin
                addr <=counter_in;
                col_number <= col_number_in;
                row_number <= row_number_in;
                saving <=1;
                data_to_bram <= assignment_in;
                write <=1;
               
                limit <= row_number_in + col_number_in;
            
            end else if (saving) begin
                if(done) begin
                    
                    saving<=0;
                    //addr <= 0;
                    write <=0;
                end else begin
                    addr <=counter_in;
                    data_to_bram <= assignment_in;

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
                        addr_row <= addr_row+1;
                        write_row<=1;
                        write_column<=0;
                        data_to_row_bram <= new_assignment
                        
                    end else if ( ~col_done) begin
                    //if im gerneating columns
                        addr_col <= addr_col+1;
                        write_column<=1;
                        write_row<=0;
                        data_to_col_bram <= new_assignment;
                        
                    end
                    
                end else begin

                    //i saved forst rows then oclumns i nthe bram asingemtn 

                    if(addr_constraint == row_number_in-1) begin
                        row_done <=1;
                        col_done <=0;
                    end else if (addr_constraint == row_number_in + col_number_in-1) begin
                        row_done <=1;
                        col_done <=1;
                        
                    end

                    //start a n ew assingemnt genertaiont
                
                    row_done <=0;
                    col_done <=0;
                    write_constrait< =0; //dont write to bram that stores constraints

                    if(~row_done) begin
                        //when im currently gerneting rows
                        start_addresses[addr_constraint+1] <=addr_row;
                        
                    end else begin
                        //when im currently gerneting cols
                        start_addresses[addr_constraint+1] <=addr_col;
                    end

                    

                    addr_constraint <= addr_constraint +1; // increment to get a new assingemtn pased to generator 
                
                //we finished genreating all the possible rows and cols > switch to another row

                    if(addr_constraint == row_number_in + col_number_in -1) begin
                    //i have collected all nthe possibel assignements

                        row_done <=1;
                        col_done <=1;

                        //2) do consolidate allowed rows (allowable function)

                        allowable_input <= data_from_rom_bram;
                        allowable_row_count <=addr_row;
                        data_to_solution_bram <=allowable_output;
                        addr_solution<=addr_solution+1;

                        if(allowable_done) begin
                            // im done with    
                            //for r in rows:
                            //  can_do.append(allowable(r))

                            //3) while loop for mod_col

                            


                            if(mod_cols_in[0] +mod_cols_in[1] +...+mod_cols_in[9]>0) begin
                                
                                if(mod_cols_in[counter_mod_col] ==1) begin
                                    //fix_col
                                    c[fix_col_counter] <= allowable_output[fix_col_counter][counter_mod_col]

                                    fix_col_counter <= fix_col_counter+1;
                                    if(fix_col_counter == len_can_do) begin

                                        done_fix_col_for_loop <=1;
                                        counter_mod_col<=counter_mod_col+1;
                                        

                                    end
                                end else begin
                                    counter_mod_col<=counter_mod_col+1;

                                    done_fix_col_for_loop <=1;
                                end

                                if(counter_mod_col ==9) begin
                                    //start the folr loop for modl_row
                                    mod_cols_in <=10'b0;
                                    counter_mod_row<=counter_mod_row+1;
                                    


                                end else if(counter_mod_row ==9) begin
                                    mod_rows_in <=10'b0;
                                    
                                end



                                
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