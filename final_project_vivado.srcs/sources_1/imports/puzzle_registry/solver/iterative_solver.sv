`default_nettype none
//TODO - rememebr the can do - each elemtn is two bits long


//TODO - doesnt stop calling genrate rows when we run our of columsn but keps runngin and returnign some shit
module iterative_solver(   
                    input wire clk_in,
                   
                    input wire reset_in,
                    input wire [5:0] index_in, //idnex of row/col beign send - max is 20 so 6 bits
                    input wire [3:0] column_number_in, //grid size - max 10
                    input wire [3:0] row_number_in, //grid size - max 10
                    
                    input wire [19:0] assignment_in, // array of cosntraitnrs in - max of 20 btis since 4 btis * 5 slots
                    
                    input wire start_sending_nonogram, //if asserted to 1, im in the rpcoess of sendifg the puzzle
                     //only for the sake of testing wheterh we saved things correctly in the test bench
                    output logic solution_out
                    
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

    logic [3:0] col_number;
    logic [3:0] row_number;
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
    
    logic [7:0] addr_row_permutation;
    logic [19:0] data_to_row_permutation_bram;
    logic [19:0] data_from_row_permutation_bram;
    logic write_permutation_row;

    //bram taht stroes all posilbe rows for each row assingemnet given 
    //row_bram - for all genrated states of cols/rows
    //height 10*40 = 400
    //width = 20
    
    row_bram all_possible_rows(
            .addra(addr_row_permutation), 
            .clka(clk_in), 
            .dina(data_to_row_permutation_bram), 
            .douta(data_from_row_permutation_bram), 
            .ena(1), 
            .wea(write_permutation_row));  
            
            
    logic  [7:0] addr_column_permutation;
    logic [19:0] data_to_column_permutation_bram;
    logic [19:0]data_from_column_permutation_bram;
    logic write_permutation_column;

    //bram taht stroes all posilbe cols states for each col assingemnet given
    //dows it creat diff sintances of bram ?  
    row_bram all_possible_columns(
            .addra(addr_column_permutation), 
            .clka(clk_in), 
            .dina(data_to_column_permutation_bram), 
            .douta(data_from_column_permutation_bram), 
            .ena(1), 
            .wea(write_permutation_column));  
            


    //stores the count of permutations for the column at each index
    
    logic [3:0] addr_column; //out of 10 in binaary so 4 btis
    
    logic write_permutation_count_column;
    logic [7:0] data_from_permutation_count_column_bram;
    logic [7:0] data_to_permutation_count_column_bram;
    
    //permutation_count_bram
    //height  -10
    //wodth max 50 > 6 bits width
    
    
    permutation_count_bram my_permutation_count_bram_column(
            .addra(addr_column), 
            .clka(clk_in), 
            .dina(data_to_permutation_count_column_bram), 
            .douta(data_from_permutation_count_column_bram), 
            .ena(1), 
            .wea(write_permutation_count_column)); 
            
            
    logic data_to_permutation_count_row_bram;
    logic data_from_permutation_count_row_bram;
    logic write_permutation_count_row;

    permutation_count_bram my_permutation_count_bram_row(
            .addra(addr_row), 
            .clka(clk_in), 
            .dina(data_to_permutation_count_row_bram), 
            .douta(data_from_permutation_count_row_bram), 
            .ena(1), 
            .wea(write_permutation_count_row)); 

    //stores constraints to eachcolumn (from left to right)
    row_bram col_constraints_bram(
            .addra(addr_constraint_column), 
            .clka(clk_in), 
            .dina(data_to_column_bram), 
            .douta(data_from_column_bram), 
            .ena(1), 
            .wea(write_constraint_column)); 
            
   logic [3:0] addr_constraint_column; //sicne at most 10 (4 bits)
   
   logic [19:0] data_to_column_bram;
   logic [19:0] data_from_column_bram;
   logic write_constraint_column;
   

    //stores constraints to each row (from top to bottom)
    row_bram row_constraints_bram(
            .addra(addr_constraint_row), 
            .clka(clk_in), 
            .dina(data_to_row_bram), 
            .douta(data_from_row_bram), 
            .ena(1), 
            .wea(write_constraint_row)
            );  
    logic [19:0] data_to_row_bram;
   logic [19:0] data_from_row_bram;
   logic write_constraint_row; 
   logic [3:0] addr_constraint_row; //sicne 10 at msot
 
    generate_rows my_generate_rows(   
                    .clk_in(clk_in),
                    .reset_in(reset_in),
                    .start_in(start_generating),
                    .assignment(selected_assignment),
                    .outputing(generate_rows_outputing),
                    .done(done_generation),
                    .new_row(new_row_version),
                    .count(current_row_version_index),
                    .total_count(total_n_of_row_versions)

    ); 
    
    
    logic [19:0] new_row_version;
    
    logic [19:0] selected_assignment;
    logic start_generating;
    
    

    logic [2:0] n_of_constraints; //number of "numebrs" in a given array of cosntraints

    logic done_generation; //outptu from generate rows - says if they finsihed returnng all teh eprmutation for a given row
    logic new_permutation;
    //selected_assignemnt is usead as an imput regsier to geenrate_rows


    logic [6:0] total_n_of_row_versions;
    logic [6:0] current_row_version_index;
    logic generate_rows_outputing;



    logic [19:0] allowable_input; //20 bits since each cell impelemned as 2 bit number


//    solution_bram solution_bram_column(
//            .addra(addr_column_solution), 
//            .clka(clk_in), 
//            .dina(data_to_solution_column_bram), 
//            .douta(data_from_solution_column_bram), 
//            .ena(1), 
//            .wea(write_solution_column)); 
            
            
//    solution_bram solution_bram_row(
//            .addra(addr_row_solution), 
//            .clka(clk_in), 
//            .dina(data_to_solution_row_bram), 
//            .douta(data_from_solution_row_bram), 
//            .ena(1), 
//            .wea(write_solution_row)); 
            
   logic write_solution_row;
   logic data_from_solution_row_bram;
   logic data_to_solution_row_bram;
   logic addr_row_solution;
   
               
   logic write_solution_column;
   logic data_from_solution_column_bram;
   logic data_to_solution_column_bram;
   logic addr_column_solution;
   
   logic [7:0] start_address_h;
   
   


    logic [100:0] start_addresses;  //straes teh start adddres of rows/ columns at the index  i 
    logic [200:0] allowable_start_addresses; //stores start adderss for each rows/col in the allwoable bram 

    logic [9:0] mod_cols_in;
    logic [9:0] mod_rows_in;
    logic [19:0] c;

    logic [9:0] allowable_output_rows [19:0]; // 10 roes each is 20 len

    logic [29:0] results [19:0]; // this can potenailly store all the permutations (which is about 30 for 10x10 case)
    logic results_counter;

    logic [19:0] fake_row_assignment_collector  [9:0] ; //collects the constraint assginemtns for bram testing
    logic [19:0] fake_col_assignment_collector [9:0]; //collects the constraint assginemtns for bram testing


    logic [19:0] fake_row_permutation_collector [150:0]; //terrrible naming - the are ROW versions (not numbers)
    logic [19:0] fake_col_permutation_collector [150:0]; //collects the constraint assginemtns for bram testing


    logic [15:0] fake_row_permutation_counter [9:0]; //collbram testing - count is whtaever numer fo bits, cna be more since it will trunctae it anyways
    logic [15:0] fake_col_permutation_counter [9:0]; //collng




    // logic [19:0] basic_row_storage [40:0]; //stores actual rows - at most 60 row states 

    // logic [19:0] all_row_storage [40:0]; //stores actual rows - at most 60 row states 
    
    
    logic row_done;
    logic column_done;
    
    logic move_to_row_generating;
    
    logic counter_out;
    
    logic column_number;
    
    logic saving;
    
    logic move_to_solving;
    logic called_generate_rows;
    
    logic [6:0] addr_constraint;
    
    logic [8:0] row_start_addresses [9:0]; //starting address for thethe state of each row;
    logic [8:0] column_start_addresses [9:0];
    
    logic [19:0] can_do [9:0];
    
    logic  move_to_allowable_section;
    
    logic [8:0] allowable_counter;
    logic [19:0] allowable_result;
    
    logic allowable_for_a_row_started;
    logic save_allowable_result;
    logic move_to_for_loop_section;
    logic [8:0] row_counter_allowable; //at moste 10 so 4 bits
    
    logic [15:0] current_permutation_count;
    logic [15:0] permutation_counter_allowable_section;

    logic [4:0] fix_col_counter; //20 
    
    logic [3:0] range_w_i;
    
    logic move_to_output;
    logic for_range_w_started;
    logic for_range_w_ended;
    logic [4:0] range_w_i_index; //up to 20
    logic fix_col_section_started;
    
    logic start_enumerate_for_loop_row;
    logic done_create_c_array;
    logic [7:0] for_c_coln_counter;
    logic [19:0] allowed_things;
    
    logic [4:0] allowed_thing_counter; //for 10 len
    logic [4:0] allowed_thing_index_counter; //for 20 len
    logic for_range_h_started;
    logic fix_row_section_started;
    logic for_range_h_ended;
    
    logic [3:0] range_h_i;
    
    logic [5:0] old_index;
    logic wait_on_clock;
    logic left_to_rest;

    logic [4:0] fix_col_counter_small;

    logic blob;
    logic blab;
    logic [19:0] can_do_seq;
    logic move_to_x;

    //TODO tarck with counter not outputing od do one clock cycle delay inoutputing vs done
                
    logic [6:0] tracker;

    logic [8:0] start_address;

    logic starter_marker;
    logic starter_marker_h;
    
    logic start_enumerate_for_loop_row_h;
    
    logic [5:0] range_h_i_index;
    logic [7:0] for_c_row_counter_h;
    
    
 logic [4:0]    allowed_thing_counter_h;
 logic [4:0] allowed_thing_index_counter_h;
                        

 logic [19:0] allowed_things_h;
 
 logic done_create_c_array_h;
 logic start_enumerate_for_loop_row_h;
 logic increment_range_h;
 logic increment_range_w;


    always_ff @(posedge clk_in) begin

        if(reset_in) begin
            // on init, nitilzie he bram to all zeros :)
            
            done_create_c_array_h <=0;
            start_enumerate_for_loop_row_h <=0;
            counter_out <=0;
            started<=0;
            column_number <=0;
            row_number <=0;
            write <=0;
            move_to_x<=0;

            tracker <=0;
            range_h_i_index <=0;
            for_c_row_counter_h<=0;
            
            allowed_thing_counter_h<=0;
            allowed_thing_index_counter_h<=0;
                        

            allowed_things_h<=0;
            
            start_address_h<=0;

            

            row_done <=0;
            column_done <=0;
            addr_row_permutation <=0;
            addr_column_permutation<=0;
            mod_cols_in <=10'b1111111111;
            mod_rows_in <=10'b0;
            c <=20'b0;
            allowable_result <= 20'b0;
            allowed_things <=20'b0;
            
            //counters
            allowable_counter <=0;
            addr_constraint_row<=0;
            
            addr_constraint<=0;
            move_to_row_generating<=0;
            row_counter_allowable<=0;
            permutation_counter_allowable_section<=0;
            fix_col_counter<=0;
            range_w_i<=0;
            range_w_i_index<=0;
            allowed_thing_counter<=0; //for 10 len
            allowed_thing_index_counter<=0; //for 20 len
            range_h_i<=0;
            addr_constraint_column <=0;

            fix_col_counter_small <=0;
                
            start_address<=0;

            starter_marker<=0;
            starter_marker_h<=0;
            
            
            //FSM
            saving<=0;
             move_to_solving<=0;
             called_generate_rows<=0;
              move_to_allowable_section <=0;
            allowable_for_a_row_started<=0;
            save_allowable_result <=0;
            move_to_for_loop_section<=0;
            
            start_enumerate_for_loop_row_h<=0;
            
            current_permutation_count <=0;
            move_to_output<=0;
            for_range_w_started<=0;
            for_range_w_ended<=0;
            fix_col_section_started<=0;
            
            start_enumerate_for_loop_row <=0;
            done_create_c_array<=0;
            for_c_coln_counter<=0;
            for_range_h_started <=0;
            fix_row_section_started <=0;
           for_range_h_ended <=0;
           old_index<=0;

           selected_assignment<=0;
           wait_on_clock <=0;
           left_to_rest<=0;
           increment_range_h <=0;
           increment_range_w <=0;
            

              
            
            
        end else begin
            if(start_sending_nonogram && ~left_to_rest) begin
                //we have just started sending a nongoram - send constrina lien by csontrint, first rows then columns
                //addr_constraint_row <= addr_constraint_row+1;
                
                column_number <= column_number_in;
                row_number <= row_number_in;
//                saving <=1;
                done_generation <=0; //marked as 0 if we finished generating al states for all comuns and rows
                limit <= row_number_in + column_number_in; // remebr to subtract 1 sicne we need to zero index

//                fake_row_assignment_collector[addr_constraint_row] <= assignment_in;

//            end else if (saving) begin
                if(addr_constraint_column >= 10) begin

                    //we have saved everything

                    saving<=0;
                    //addr <= 0;
                    write_constraint_column <=0;
                    write_constraint_row <=0;
                    addr_constraint_column <= 0;
                    addr_constraint_row <= 0;
                    left_to_rest<=1;
                    move_to_row_generating<=1;
                end else begin
                    if(index_in >= 10 && index_in<=19) begin
                        //SENDING COLS
                        //we are always sending 

                        //we have finished sending all the rows, now we are sending all the columsn 

                        old_index <= index_in;
//                        if (index_in !=old_index) begin
                        write_constraint_column <=1;
                        write_constraint_row <=0;
                        addr_constraint_column <= addr_constraint_column +1;
                       data_to_column_bram  <= assignment_in;
                        fake_col_assignment_collector[addr_constraint_column] <= assignment_in;
                       

                    end else begin
                        //SENDING ROWS

                        //we are still sending rows

                        old_index <=index_in;
                        
//                        if(old_index!= index_in) begin
                        
                            write_constraint_column <=0;
                            
                            write_constraint_row <=1;
                            addr_constraint_row <= addr_constraint_row+1; // selects teh cosntrin the the to that we passed at teh beginign 
                            data_to_row_bram  <= assignment_in; 
                            fake_row_assignment_collector[addr_constraint_row] <= assignment_in;
                        
                        
                        
//                        end


                    end

                end
                
            end else if(move_to_row_generating) begin

                //----------------------row generating---------------------------------

                //1) gerenate all rows for each row

                if (~wait_on_clock) begin
                    
                    
                    if(~row_done) begin
                        //when im currently gerneting rows
                        selected_assignment <= fake_row_assignment_collector[addr_constraint_row];
                        write_permutation_count_column <=0;
                        row_start_addresses[addr_constraint_row] <= addr_row_permutation;


                    end else begin
                        //when im currently gerneting cols
                        //data_to_permutation_count_column_bram <= n_of_constraints;
                        selected_assignment <= fake_col_assignment_collector[addr_constraint_column];

                        //column_start_addresses[addr_constraint_column] <= addr_column_permutation;

                        //addr_constraint_column <= addr_constraint_column+1;
                        write_permutation_count_row <=0;

                        column_start_addresses[addr_constraint_column] <= addr_column_permutation;
                        
                    end

                    called_generate_rows <=1;
                    wait_on_clock <=1;

                end else if (called_generate_rows) begin
                     called_generate_rows <=0;
                     start_generating <=1;
                     move_to_x<=1;

                    
                
                    

                end else if (move_to_x) begin
                    start_generating <=0; // we dont need to hold it on 
                    wait_on_clock<=1;
                    move_to_x <=0;
                    
                    
                    
                end else if (generate_rows_outputing) begin


                    tracker <= tracker + 1;
                    start_generating <=0; //maybe?

                    //geenrate rows finally outputs

                    if( ~row_done) begin
                        //if im genreating rows
                        addr_row_permutation <= addr_row_permutation+1;

                        data_to_row_permutation_bram <= new_row_version;
                        fake_row_permutation_collector[addr_row_permutation] <= new_row_version; // this index is sued o put new states of the row to th sotrgae - can be mroe than one per row
                        write_permutation_column <=0;
                        write_permutation_row <=1;
                        write_permutation_count_row <=0;
                        write_permutation_count_column <=0;

                    end else if ( ~column_done) begin
                    //if im gerneating columns 10.//11//.01.01.01.01.01.01.//11//.10 ?
                        addr_column_permutation <= addr_column_permutation+1;
                        data_to_column_permutation_bram <= new_row_version;
                        
                        
                        fake_col_permutation_collector[addr_column_permutation] <= new_row_version;

                        write_permutation_row <=0;
                        write_permutation_column <=1;

                        write_permutation_count_row <=0;
                        write_permutation_count_column <=0;
                    end

                //end else if (tracker >= total_n_of_row_versions )

                //end else if (tracker >= (total_n_of_row_versions)  ) begin

               end else if (done_generation && tracker >= (total_n_of_row_versions-1)  ) begin
                    //generate rows finished outptuing for a gvien assignemtn - save length and mvoe to the sart of fsm 

                    called_generate_rows<=0; //restart the fsm
                    wait_on_clock<=0;
                    tracker <=0;

                    //we have just consdiered the last row and wer are savign datat for the last row > change 
                    if(addr_constraint_row == 9) begin
                        row_done <=1;
                        column_done <=0;
                        write_permutation_row <=0;
                        //addr_constraint_row = 0;
                        
                    end 

                    if(~row_done) begin
                        //when im currently gerneting rows
                        data_to_permutation_count_row_bram <= total_n_of_row_versions;
                        
                        //start_addresses[addr_constraint+1] <=addr_row;
                        addr_constraint_row <= addr_constraint_row+1;
                        write_permutation_count_row <=1;
                        write_permutation_count_column <=0;

                        fake_row_permutation_counter[addr_constraint_row] <= total_n_of_row_versions;


                    end else begin
                        //when im currently gerneting cols

                        data_to_permutation_count_column_bram <= n_of_constraints;
                        //selected_assignment <= data_from_column_bram;

                        addr_constraint_column <= addr_constraint_column+1;
                        write_permutation_count_row <=0;
                        write_permutation_count_column <=1;

                        fake_col_permutation_counter[addr_constraint_column] <= total_n_of_row_versions;
                    end

                    
                    if(addr_constraint_column == 9) begin

                        //possibel bug that teh alst one is not saved ? 

                        row_done <=1;
                        column_done <=1;
                        start_generating <=0;
                        write_permutation_column <=0;
                        write_permutation_row <=0;
                        addr_row <= 0;
                        addr_column <= 0;
                        move_to_allowable_section <=1;
                        move_to_row_generating <=0;
                        addr_constraint <=0;

                        addr_row_permutation <=0;
                        addr_column_permutation <=0;
                        
                        save_allowable_result<=0;
                        addr_constraint_row <=0;
                        row_counter_allowable<=0;

                        //counts if we submitted all the permutations

                    end
                    
                end


            end else if (move_to_allowable_section) begin
                    
                    //i have collected all nthe possibel assignements
                        //2) do consolidate allowed rows (allowable function)


                        // its deost pick up the first permutation ? 

                if (~allowable_for_a_row_started) begin
                    allowable_for_a_row_started <=1;
                    permutation_counter_allowable_section <=0;
                    current_permutation_count <= fake_row_permutation_counter[row_counter_allowable];
                    move_to_allowable_section<=1;
                    
                end else if (allowable_for_a_row_started && ~ save_allowable_result) begin
                    can_do_seq <=fake_row_permutation_collector[addr_row_permutation];

                    allowable_result <= allowable_result | fake_row_permutation_collector[addr_row_permutation];

                    permutation_counter_allowable_section <= permutation_counter_allowable_section+1;

                    if(permutation_counter_allowable_section == (current_permutation_count-1)) begin
                        save_allowable_result <=1;
                    end 

                    addr_row_permutation <= addr_row_permutation+1;

                end else if (save_allowable_result && allowable_for_a_row_started ) begin
                    //allowable_for_a_row_started<=0;
                    can_do[row_counter_allowable] <=allowable_result;
                    row_counter_allowable <=row_counter_allowable +1;
                    save_allowable_result<=0;
                    allowable_for_a_row_started <=0;
                    allowable_result <=0;

                    if(row_counter_allowable == 9) begin 

                        move_to_allowable_section<=0;
                        allowable_for_a_row_started <=0;
                        save_allowable_result <=0;
                        move_to_for_loop_section<=1;
                        row_counter_allowable<=0;
                        addr_row_permutation <=0;
                        
                    end


                end

                //we have consdeiredall teh rows

                //10 or 9 ?? >> 10


                            


            end else if(move_to_for_loop_section) begin


                if((mod_cols_in[0] + mod_cols_in[1] +mod_cols_in[2] +mod_cols_in[3] +mod_cols_in[4] + mod_cols_in[5] +mod_cols_in[6] +mod_cols_in[7] +mod_cols_in[8] +mod_cols_in[9]) >0) begin
                    for_range_w_started <=1;
                    move_to_for_loop_section<=0;
                end else begin
                    move_to_output <=1;
                    move_to_for_loop_section<=0;
                end


            end else if(for_range_w_started) begin

                //add another state to increment the counter after running the fix_col ended

                if (range_w_i ==10) begin
                    for_range_w_ended <=1;
                    for_range_w_started<=0;
                    range_w_i <=0;
                    range_w_i_index <=0;
                    starter_marker<=0;
                end else begin
                    if(mod_cols_in[range_w_i]) begin
                        fix_col_section_started<=1;
                        for_range_w_started<=0;
                        
                    end else begin
                        fix_col_section_started<=0;
                        for_range_w_started<=0;
                        increment_range_w<=1;

                    end
                    
                    c<=0;
                    allowable_counter<=0;
                    allowable_result <=0;
                    


                end

            end else if (fix_col_section_started) begin
                

                

                if (~done_create_c_array && ~start_enumerate_for_loop_row) begin 

                    ///THIS asiggns zeros incorrectly??? and breaks it since it  


                                                //len_can_do = 9
                    if(fix_col_counter == 20) begin

                        done_create_c_array <=1;
                        fix_col_counter <=0;
                        fix_col_counter_small <=0;

                        start_address <=column_start_addresses[range_w_i];

                        //TODO

                        //starting_address <=starting_address_register[range_w_i]
                                                                    
                    end else begin
                        fix_col_counter <= fix_col_counter+2;
                        fix_col_counter_small <= fix_col_counter_small+1;
                        c[fix_col_counter] <= can_do[fix_col_counter_small][range_w_i_index];
                        c[fix_col_counter+1] <= can_do[fix_col_counter_small][range_w_i_index+1];
                        blob <=can_do[fix_col_counter_small][range_w_i_index];
                        blab <= can_do[fix_col_counter_small][range_w_i_index+1];
                        can_do_seq <=can_do[fix_col_counter_small];

                    end

                end else if (done_create_c_array && ~start_enumerate_for_loop_row) begin

                    for_c_coln_counter<=for_c_coln_counter+1;

                    
                    

                    //if whole row is zero that means it has been deled so you can omit it iwith if statement 
                    if((fake_col_permutation_collector[start_address + for_c_coln_counter]!=10'b0) && (
                            ( (c[1:0] & fake_col_permutation_collector[start_address + for_c_coln_counter][1:0])     >0) &&
                            ( (c[3:2] & fake_col_permutation_collector[start_address + for_c_coln_counter][3:2])     >0) &&
                            ( (c[5:4] & fake_col_permutation_collector[start_address + for_c_coln_counter][5:4])     >0) &&
                            ( (c[7:6] & fake_col_permutation_collector[start_address + for_c_coln_counter][7:6])     >0) &&
                            ( (c[9:8] & fake_col_permutation_collector[start_address + for_c_coln_counter][9:8])     >0) &&
                            ( (c[11:10] & fake_col_permutation_collector[start_address + for_c_coln_counter][11:10]) >0) &&
                            ( (c[13:12] & fake_col_permutation_collector[start_address + for_c_coln_counter][13:12]) >0) &&
                            ( (c[15:14] & fake_col_permutation_collector[start_address + for_c_coln_counter][15:14]) >0) &&
                            ( (c[17:16] & fake_col_permutation_collector[start_address + for_c_coln_counter][17:16]) >0) &&
                            ( (c[19:18] & fake_col_permutation_collector[start_address + for_c_coln_counter][19:18]) >0)) ) begin
                            

                        allowed_things <= allowed_things | fake_col_permutation_collector[start_address + for_c_coln_counter]; // range_w_i - why ? 
                    end else begin
                                //fit retursn false so decrese teh avilaible numebr of permutations and zero the registr  (as deleted)
                        
                       // data_to_results_bram <= 10'b0; //mark as all zeross if deldeted
                        //permutation_count <= permutation_count-1;

                        fake_col_permutation_collector[start_address + for_c_coln_counter] <=0;
                        //fake_col_permutation_counter[addr_col] <=fake_col_permutation_counter[addr_col]-1; do we actually need to decrease it? consider zero ??
                        //allowed_things <= allowed_things || 10'b0;
                    end

                        
                    if(for_c_coln_counter == (fake_col_permutation_counter[range_w_i]-1)) begin
                        //we finished the for loop to create resutl array                
                            start_enumerate_for_loop_row <=1;
                            done_create_c_array<=0;
                            for_c_coln_counter<=0;
                    end

                end else if (start_enumerate_for_loop_row && ~done_create_c_array) begin

                    //this for loop always gors from 0 to 9 inclsuvei since to goes through the itsm in the allwoablae things which is a single arrya f length 10 
                    //TODO - remember they are two bit numbers 



                    if(allowed_thing_counter == 10) begin

                         // to increment the  i in for loop 
                        
                        start_enumerate_for_loop_row<=0;
                        allowed_thing_counter<=0;
                        allowed_thing_index_counter<=0;
                        fix_col_section_started <=0;
                        allowed_things<=0;
                        increment_range_w<=1;



                    end else begin
                        allowed_thing_counter<=allowed_thing_counter+1; //for 10 len 10.01.01.01.01.01.01.01.01.10
                        allowed_thing_index_counter<=allowed_thing_index_counter+2; //for 20 len
                
                        if((allowed_things[allowed_thing_index_counter+:1] != can_do[allowed_thing_counter][range_w_i_index+:1])) begin
                            mod_rows_in[allowed_thing_counter] <= 1;
                            can_do[allowed_thing_counter][range_w_i_index] <= can_do[allowed_thing_counter][range_w_i_index] & allowed_things[allowed_thing_index_counter];

                            can_do[allowed_thing_counter][range_w_i_index +1] <= can_do[allowed_thing_counter][range_w_i_index +1] & allowed_things[allowed_thing_index_counter+1];
                        end

                    end
                                                
                    
                end 
            end else if (increment_range_w) begin
                for_range_w_started <=1;
                increment_range_w <=0;
                range_w_i <=range_w_i +1;
                range_w_i_index <= range_w_i_index+2;


            end else if (fix_row_section_started) begin
                //TODO - for now just increments to move forward through the for loop 
                

                if (~done_create_c_array_h && ~start_enumerate_for_loop_row_h) begin

                    c<=can_do[range_h_i];
                    done_create_c_array_h <=1;
                    start_enumerate_for_loop_row_h<=0;
                    start_address_h <=row_start_addresses[range_h_i];
                                      
                end else if (done_create_c_array_h && ~start_enumerate_for_loop_row_h) begin

                    for_c_row_counter_h<=for_c_row_counter_h+1;

                    
                    

                    //if whole row is zero that means it has been deled so you can omit it iwith if statement 
                    if((fake_row_permutation_collector[start_address_h + for_c_row_counter_h]!=10'b0) && (
                            ( (c[1:0] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][1:0])     >0) &&
                            ( (c[3:2] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][3:2])     >0) &&
                            ( (c[5:4] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][5:4])     >0) &&
                            ( (c[7:6] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][7:6])     >0) &&
                            ( (c[9:8] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][9:8])     >0) &&
                            ( (c[11:10] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][11:10]) >0) &&
                            ( (c[13:12] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][13:12]) >0) &&
                            ( (c[15:14] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][15:14]) >0) &&
                            ( (c[17:16] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][17:16]) >0) &&
                            ( (c[19:18] & fake_row_permutation_collector[start_address_h + for_c_row_counter_h][19:18]) >0)) ) begin
                            

                        allowed_things_h <= allowed_things_h | fake_row_permutation_collector[start_address_h + for_c_row_counter_h]; // range_w_i - why ? 
                    end else begin
                                //fit retursn false so decrese teh avilaible numebr of permutations and zero the registr  (as deleted)
                        
                       // data_to_results_bram <= 10'b0; //mark as all zeross if deldeted
                        //permutation_count <= permutation_count-1;

                        fake_row_permutation_collector[start_address_h + for_c_row_counter_h] <=0;
                        //fake_col_permutation_counter[addr_col] <=fake_col_permutation_counter[addr_col]-1; do we actually need to decrease it? consider zero ??
                        //allowed_things <= allowed_things || 10'b0;
                    end

                        
                    if(for_c_row_counter_h == (fake_row_permutation_counter[range_h_i]-1)) begin
                        //we finished the for loop to create resutl array                
                            start_enumerate_for_loop_row_h <=1;
                            done_create_c_array_h<=0;
                            for_c_row_counter_h<=0;
                    end
                    


                end else if (start_enumerate_for_loop_row_h && ~done_create_c_array_h) begin

                                    //this for loop always gors from 0 to 9 inclsuvei since to goes through the itsm in the allwoablae things which is a single arrya f length 10 
                    //TODO - remember they are two bit numbers 


                    if(allowed_thing_counter_h == 10) begin
                        // to increment the  i in for loop 
                        
                        start_enumerate_for_loop_row_h<=0;
                        allowed_thing_counter_h<=0;
                        allowed_thing_index_counter_h<=0;
                        fix_row_section_started <=0;

                        allowed_things_h<=0;
                        increment_range_h<=1;
                    end else begin 
                        allowed_thing_counter_h<=allowed_thing_counter_h+1; //for 10 len
                        allowed_thing_index_counter_h<=allowed_thing_index_counter_h+2; //for 20 len
                
                        if((allowed_things_h[allowed_thing_index_counter_h] != can_do[range_h_i][allowed_thing_index_counter_h])
                         ||  (allowed_things_h[allowed_thing_index_counter_h+1] != can_do[range_h_i][allowed_thing_index_counter_h+1])

                        ) begin
                            mod_cols_in[allowed_thing_counter_h] <= 1;
                            can_do[range_h_i][allowed_thing_index_counter_h] <= can_do[range_h_i][allowed_thing_index_counter_h] & allowed_things_h[allowed_thing_index_counter_h];

                            can_do[range_h_i][allowed_thing_index_counter_h+1] <= can_do[range_h_i][allowed_thing_index_counter_h+1] & allowed_things_h[allowed_thing_index_counter_h+1];
                        end

                    end

                end
            end else if (increment_range_h) begin
                for_range_h_started <=1; 
                increment_range_h <=0;
                range_h_i<=range_h_i+1; //for 10 len
                range_h_i_index <= range_h_i_index+2; //for 20 len // dont increment


            end else if (for_range_w_ended) begin
                mod_cols_in<=20'b0;
                for_range_w_ended<=0;
                for_range_h_started<=1;

            end else if (for_range_h_ended) begin
                mod_rows_in<=20'b0;
                for_range_h_ended<=0;
                move_to_for_loop_section<=1;

                
            end else if (for_range_h_started) begin
                if (range_h_i ==10) begin
                    for_range_h_ended <=1;
                    for_range_h_started<=0;

                    range_h_i <=0;
                    range_h_i_index <=0;

                    starter_marker_h<=0; // 
                end else begin

                    if(mod_rows_in[range_h_i]) begin
                        fix_row_section_started<=1;
                        for_range_h_started<=0;
                        
                    end else begin
                        fix_row_section_started<=0;
                        //for_range_h_started<=1;
                        increment_range_h<=1;
                        for_range_h_started<=0;

                    end
                    
                    c<=0;


                end




            end else if (move_to_output) begin
                solution_out<=1;
            end

                        


        end
        
        end
        
        

        
    





    
    
endmodule

`default_nettype wire