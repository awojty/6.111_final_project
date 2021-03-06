`default_nettype none

module generate_rows(   
                    input wire clk_in,
                    input wire start_in,
                    input wire reset_in,
                    input wire [19:0] assignment, // at most 5 sontrains of length 4 
                    output logic done,
                    output logic outputing, //asserted when the new_row is ready on the output (fully)
                    output logic [19:0] new_row,
                    output logic [6:0] count, //current index of the row in the set of that we are oging to return 
                    output logic [6:0] total_count //returns the tola nbumber of optison returend for a given setging
);  



    parameter original = 20'b10101010101010101010;

    logic [5:0] i; //counter in for llop for 20 row genration
    logic  [2:0] number_of_breaks;
    logic  [2:0] space_to_fill_left;
    logic [11:0] breaks;
    logic start_generator;
    
    logic data_collected;
    logic permutation_started;
    
    logic started_shifting;

    logic [19:0] new_row1;
    

    logic [3:0] constrain1;
    logic [3:0] constrain2;
    logic [3:0] constrain3;
    logic [3:0] constrain4;
    logic [3:0] constrain5;

    logic [4:0] permutation_min_length;
    logic [3:0] number_of_numbers; // 5 is the max numer 
    logic [2:0] number_of_breaks;
    logic [2:0] space_to_fill_left;

    logic returned_all_permutations;
    logic [15:0] permutation; // 6 bits encoding of breaks frm permutaiont module

    logic [11:0] permutation_out;
    logic [5:0] permutation_count;
    logic [5:0] counter; //used to coutn permutations when they are being returned
    
    logic [4:0] permutations_min_length_list [40:0]; //61 arryas of 5 bits ? 
    logic [16:0] permutations_list [40:0]; //stroes numebrs -at most 30 permuations for a agiven set of constraints
    
    logic [19:0] basic_row_storage [40:0]; //stores actual rows - at most 60 row states 

    logic [19:0] all_row_storage [40:0]; //stores actual rows - at most 60 row states 
    
    
    
    logic create_a_row_from_permutations;
    
    logic [6:0] permutation_counter;
    
    
    logic in_progress;
    logic new_data; //assereted when new input to create_a_row is given 
    
    logic done_generation;
    logic generating;
    logic generate_rows_from_basic;
    
    logic [6:0] shifts_limit;
    logic [6:0] shifts;
    logic [6:0] min_length;
    logic generate_states_from_permutations;
    logic len_1_started;
    
    logic [6:0] all_rows_counter;

    logic [4:0] running_sum_1; //5 bits sinnce max numebr is 20
    logic [4:0] running_sum_2;
    logic [4:0] running_sum_3;
    logic [4:0] running_sum_4;
    logic [4:0] running_sum_5;
    logic [4:0] running_sum_6;
    logic [4:0] running_sum_7;
    logic [4:0] running_sum_8;
    logic [19:0] new_row1;
    logic [19:0] new_row_from_create_a_row;

    logic [5:0] total_permutation_count;

    create_a_row my_create_a_row (
        .clk_in(clk_in),
        .reset_in(reset_in),
        .new_data(start_generator),
        
        .constrain1(constrain1),
        .constrain2(constrain2),
        .constrain3(constrain3),
        .constrain4(constrain4),
        .constrain5(constrain5),
        .number_of_constraints(number_of_numbers),
        .break1(permutation[3:0]),
        .break2(permutation[7:4]),
        .break3(permutation[11:8]),
        .break4(permutation[15:12]),
        .assignment_out(new_row_from_create_a_row),
        .done(done_generation),
        .min_length(permutation_min_length) //retusn the min length from filled to filled that covers all filled
    );

    get_permutations my_get_permutations(   
                    .clk_in(clk_in),
                    .reset_in(reset_in),
                    .start_in(starter), // asserted when we want to start generating permutations
                    .number_of_breaks_in(number_of_breaks),//at most 4 breaks
                    .space_to_fill_in(space_to_fill_left), // at most 5 space left (exclude teh compuslory break on the left)
                    .permutation_out(permutation_out), //  mak of 4 breaks, eahc max encoded by 3 bits 4*3 ==12
                    .done(returned_all_permutations),
                    .counting(started_outputing_permutations),
                    .total_counter(permutation_count) //returns the tola nbumber of optison returend for a given setging
    );

    logic started_outputing_permutations;
    logic [6:0] create_a_row_counter;
    logic wait_clock;

    logic [19:0] old_version;

    logic [6:0]  return_counter;

    logic start_returning;
    logic finished_returning;
    logic starter;

    logic [5:0] min_length;

    logic [19:0] new_row2;

    logic [19:0] assignment_stored;
    logic returned_all_permutations_internal;
    logic outputing_done;


    always_ff @(posedge clk_in) begin

        if(reset_in || finished_returning) begin

            wait_clock<=0;
            outputing_done <=0;

            constrain1<=0;
            constrain2<=0;
            constrain3<=0;
            constrain4<=0;
            constrain5<=0;
            new_row1<=0;

            //permutation_min_length<=0;
            number_of_numbers<=0; // 5 is the max numer 
            number_of_breaks<=0;
            space_to_fill_left<=0;

            //counters
            shifts <=0;
            number_of_breaks<=0;
            space_to_fill_left<=0;
            shifts_limit<=0;
            counter<=0;
            permutation_counter <=0;
            i<=0;
            create_a_row_counter <=0;
            
            number_of_numbers <=0;

            total_permutation_count<=0;
            all_rows_counter<=0;
            returned_all_permutations_internal<=0;

            //FSM
            in_progress <=0;
            len_1_started<=0;
            create_a_row_from_permutations<=0;
            //done_generation<=0;
            generating<=0;
            generate_rows_from_basic<=0;
            permutation_started<=0;
            data_collected<=0;
            generate_states_from_permutations <=0;
            start_generator <=0;
            //returned_all_permutations<=0;

            //outputs
            outputing<=0;
            count<=0;
            done <=0;
            total_count <=0;
            new_row<=20'b0;
            new_row1<=20'b0;
            //new_row_from_create_a_row<=20'b0;
            
            //regs
            //permutation_out <=0;

            running_sum_1<=0; //5 bits sinnce max numebr is 20
            running_sum_2<=0;
            running_sum_3 <=0;
            running_sum_4<=0;
            running_sum_5<=0;
            running_sum_6<=0;
            running_sum_7<=0;
            running_sum_8<=0;

            old_version <=0;
            return_counter <=0;
            start_returning <=0;
            finished_returning <=0;
            min_length<=0;

            new_row2 <=0;
            started_shifting<=0;
            assignment_stored<=0;


        end else if (start_returning) begin 

            if (return_counter <=  (all_rows_counter-1)) begin

                return_counter <= return_counter +1;
                outputing <=1;
                new_row <=all_row_storage[return_counter];
                
            end else begin

                //on done reset the whole state machine

                //HERE

                finished_returning <=1;

                done <=1;
                outputing <=0;
                return_counter <=0;
                total_count<= all_rows_counter;

                //reset the state machine

                wait_clock<=0;

                permutation<=0;

                //counters
                shifts <=0;
                number_of_breaks<=0;
                space_to_fill_left<=0;
                shifts_limit<=0;
                counter<=0;
                permutation_counter <=0;
                i<=0;
                create_a_row_counter <=0;

                total_permutation_count<=0;

                min_length <=0;

                //FSM
                in_progress <=0;
                len_1_started<=0;
                create_a_row_from_permutations<=0;
                //done_generation<=0;
                generating<=0;
                generate_rows_from_basic<=0;
                permutation_started<=0;
                data_collected<=0;
                generate_states_from_permutations <=0;
                start_generator <=0;
                //returned_all_permutations<=0;
                returned_all_permutations_internal <=0;

                //outputs
                outputing<=0;
                count<=0;
                
                
                new_row<=20'b0;
                new_row1<=20'b0;
                new_row2<=20'b0;
                //new_row_from_create_a_row<=20'b0;
            
                //regs
                //permutation_out <=0;

                running_sum_1<=0; //5 bits sinnce max numebr is 20
                running_sum_2<=0;
                running_sum_3 <=0;
                running_sum_4<=0;
                running_sum_5<=0;
                running_sum_6<=0;
                running_sum_7<=0;
                running_sum_8<=0;

                old_version <=0;
                return_counter <=0;
                start_returning <=0;
                starter <=0;
                started_shifting<=0;
                assignment_stored<=0;
                new_data <=0;

            end

        end else if (create_a_row_from_permutations) begin

            // create BASIC rows 

            if(~wait_clock) begin
                wait_clock <=1;
                
            end else if(~generating && wait_clock) begin
                
                generating<=1;
                start_generator <=1;
                 //used in create a row to mark incommingn new data
                permutation <= permutations_list[create_a_row_counter]; // input to create_a_row module - it only retusn ONE row per permutaiont numerbs - the basic one, shifted to the left 
                
            end else if (generating && start_generator) begin
                start_generator <=0;
            
            end else if (done_generation && generating) begin
                //save returned row
                old_version <=new_row_from_create_a_row;

                if (old_version != new_row_from_create_a_row) begin
                    basic_row_storage[create_a_row_counter] <= new_row_from_create_a_row;
                    permutations_min_length_list[create_a_row_counter] <= permutation_min_length;
                    create_a_row_counter <=create_a_row_counter +1;
                end
                
                
                generating<=0;
                wait_clock <=0;
                start_generator<=0;

            end

            if(create_a_row_counter >= total_permutation_count) begin

                //i have created and output all the rows for given cosntrinats
                create_a_row_from_permutations <=0;
                permutation_started<=0;
                

                in_progress <=0;

                generate_rows_from_basic <=1;
                counter <=0;
                create_a_row_counter <=0;
                new_data <=0;
                wait_clock<=0;
                generating <=0;
                
            end


        end else if (permutation_started) begin

            starter <=0;

            if(started_outputing_permutations) begin
                permutations_list[counter] <= permutation_out; 
                
                counter <=counter +1;

                
            end else if(returned_all_permutations) begin
                returned_all_permutations_internal <=1;
                create_a_row_from_permutations <=1;
                permutation_started<=0;
                counter<=0;
                permutation_counter<=0; // used i nthe next state 
                permutation_count <=counter;
                total_permutation_count <=counter;
                all_rows_counter<=0;
                
                
            end

        end else if (generate_rows_from_basic) begin
            //we are done with gerneating all the "basic" states for a given csontrin set > shift each basic set to left


                if(~started_shifting) begin

                    //we either just entered this state or we are done with shofting for  agiven basci state > introduce a enw basic state to new_row

                    new_row2 <=basic_row_storage[permutation_counter];
                    all_row_storage[all_rows_counter] <= basic_row_storage[permutation_counter];
                    all_rows_counter <=all_rows_counter+1;

                    // outputing <=1;
                    // count <= count +1;

                    permutation_counter <= permutation_counter +1;
                    shifts <=0;

                    min_length <=permutations_min_length_list[permutation_counter];

                    started_shifting <=1;



                end else begin

                    //save this whole thing to bram wbc clickcyclses suckkkk instead of returning avery clock cycle 

                    //we are in the rpocess of shofting a given state 

                    if(min_length < 5'd20) begin
                    //we are still allowed to shift
                        new_row2 <= {new_row2, 2'b10};
                        min_length <=min_length+ 2'b10;
                        all_row_storage[all_rows_counter] <= {new_row2, 2'b10};
                        all_rows_counter <=all_rows_counter+1;
                        
                    end else begin
                        started_shifting <=0;
                        outputing <=0; // why ? 


                        if(permutation_counter == total_permutation_count) begin

                            start_returning <=1; 
                            //done<=1; // finish the whole genratE_row
                            generate_states_from_permutations <=0; // [otenailly need  ozero all the staes here ust to make sure
                    end
                        
                    end

                    



                    
                end


        end else if (data_collected && in_progress) begin

            //we have collected all the permutatiosn but now we need to shift them

            if (assignment_stored == 20'b0) begin

                count <= count+1;

                if(count == 11) begin
                    done <=1;
                    outputing <=0;
                    finished_returning <=1;
                    total_count<= 11;
                end else begin
                    new_row <= original;
                    outputing <=1;
                    done <=0;

                end

                
                
            
            end else if(min_length == 10) begin
                //if it's the "best case scenario" - we have onyl one posible way to create a row - return it right away
                i<=i+2;
                
                if(outputing_done) begin
                    finished_returning <=1;
                    outputing<=0;
                    outputing_done <=0;
                
                end

                if(i == 20) begin
                    done<=1;
                    count<=1;
                    total_count <=1;
                    i<=0;
                    outputing<=1;
                    new_row <=new_row1;
                    outputing_done <=1;
                    
                end else if(i <running_sum_1) begin
                            new_row1[i] <= 1'b1;
                            new_row1[i+1] <= 1'b0;
                end else if( i == running_sum_1) begin
                            new_row1[i] <= 1'b0;
                            new_row1[i+1] <= 1'b1;
                end else if(i < running_sum_2 && i > running_sum_1) begin
                            new_row1[i] <= 1'b1;
                            new_row1[i+1] <= 1'b0;
                end else if( i ==  running_sum_2) begin
                            new_row1[i] <= 1'b0;
                            new_row1[i+1] <= 1'b1;
                end else if(i < running_sum_3 && i >  running_sum_2) begin
                            new_row1[i] <= 1'b1;
                            new_row1[i+1] <= 1'b0;
                end else if( i ==  running_sum_3) begin
                            new_row1[i] <= 0;
                            new_row1[i+1] <= 1;
                end else if(i < running_sum_4 && i >  running_sum_3 ) begin
                            new_row1[i] <= 1'b1;
                            new_row1[i+1] <= 1'b0;
                end else if( i ==  running_sum_4) begin
                            new_row1[i] <= 1'b0;
                            new_row1[i+1] <= 1'b1;
                end else if( i <  running_sum_5 && i >  running_sum_4) begin
                            new_row1[i] <= 1'b1;
                            new_row1[i+1] <= 1'b0;
                end



                        

            end else if(number_of_numbers == 1) begin

                //we have a single constrain

                if(len_1_started) begin
                    
                    count <= count+1; //increment the "idnex" of the returend row

                    new_row <= {new_row, 2'b10}; //shoft one to the left

                    if(count == total_count-1) begin

                        //TODO - add one more FSM state to have one clock cycel delay between outpuing and done  ? 

                        //HERE - done up, out down
                        done <=1;
                        data_collected<=0;
                        
                        outputing<=0;
                        len_1_started <=0;
                        in_progress <=0;
                    end

                end else begin
                    //start internal fsm to shift
                    total_count <= 7'd10 - assignment[3:0] +1'd1; // total number of rows toreturn 
                    
                    i<=i+2;
                
                    if( i > 18) begin
                        len_1_started<=1;
                        outputing<=1;
                        i<=0;
                        new_row<=new_row1;
                        //count <=count+1;
                        
                    end else if(i <(assignment[3:0] + assignment[3:0])) begin
                            new_row1[i] = 1;
                            new_row1[i+1] = 0;
                    end else begin
                            new_row1[i] = 0;
                            new_row1[i+1] = 1;
                    end

                        
                end


            end else begin
                //we can genreates statees "logically" - f

                permutation_started <=1;
                starter <=1;
                data_collected<=0;
                count<=0;
                
            end
            
            
        end else if (start_in && (~in_progress)) begin

            //we have provided new data in assingemtne > syart the whole fsm again 
            data_collected<=1;
            in_progress <=1; //start generation

            //zero all the values that might have been assignesd to sth before
            total_count <=0;
            count <=0;
            done <=0;
            outputing <=0;
            
            i<=0;

            assignment_stored <=assignment;

            constrain1<=assignment[3:0];
            constrain2<=assignment[7:4];
            constrain3<=assignment[11:8];
            constrain4<=assignment[15:12];
            constrain5<=assignment[19:16];

            running_sum_1 <= assignment[3:0] + assignment[3:0]; // always add tiwce sicne we migrate from 10 to 20
            running_sum_2 <= assignment[3:0] + assignment[3:0] + 2 + assignment[7:4] + assignment[7:4] ;
            running_sum_3 <= assignment[3:0] + assignment[3:0] + 2 + assignment[7:4] + assignment[7:4] + 2 + assignment[11:8] + assignment[11:8];
            running_sum_4 <= assignment[3:0] + assignment[3:0] + 2 + assignment[7:4] + assignment[7:4] + 2 + assignment[11:8] + assignment[11:8] + 2 + assignment[15:12] + assignment[15:12];
            running_sum_5 <= assignment[3:0] + assignment[3:0] + 2 + assignment[7:4] + assignment[7:4] + 2 + assignment[11:8] + assignment[11:8] + 2 + assignment[15:12] + assignment[15:12] + 2 + assignment[19:16] + assignment[19:16];


            //gernate numebr of breaks and spaces lef based on the passed cosntraints 

            if (assignment[3:0] > 4'b0000 && assignment[7:4]<=4'b0000) begin
                min_length <= assignment[3:0];
                number_of_breaks <= 3'd0;
                number_of_numbers <= 3'd1;
                space_to_fill_left <= 10 - assignment[3:0];
                
                running_sum_1 <= assignment[3:0] + assignment[3:0]; // always add tiwce sicne we migrate from 10 to 20
                running_sum_2 <= assignment[3:0] + assignment[3:0];
                running_sum_3 <= assignment[3:0] + assignment[3:0];
                running_sum_4 <= assignment[3:0] + assignment[3:0];
                running_sum_5 <= assignment[3:0] + assignment[3:0];



            end else if (assignment[7:4]>4'b0000 && assignment[11:8]<=4'b0000) begin
                number_of_breaks<=1;
                number_of_numbers<=2;
                min_length <= assignment[3:0] + assignment[7:4] +1;
                space_to_fill_left <= 10 - assignment[3:0] - assignment[7:4] - 1;

                running_sum_1 <= assignment[3:0] + assignment[3:0]; // always add tiwce sicne we migrate from 10 to 20
                running_sum_2 <= assignment[3:0] + assignment[3:0] + 2 + assignment[7:4] + assignment[7:4] ;
                running_sum_3 <=5'b11111;
                running_sum_4 <= 5'b11111;
                running_sum_5 <= 5'b11111;

                
            end else if ((assignment[11:8]>4'b0000) && assignment[15:12]<=1'b0) begin
                number_of_breaks<=2;
                number_of_numbers<=3;
                space_to_fill_left <= 10 - assignment[3:0] - assignment[7:4] - assignment[11:8]  - 2'd2;


                min_length <= assignment[3:0] + assignment[7:4] + assignment[11:8] + 2; // min lenght of the run
                running_sum_1 <= assignment[3:0] + assignment[3:0]; // always add tiwce sicne we migrate from 10 to 20
                running_sum_2 <= assignment[3:0] + assignment[3:0] + 2 + assignment[7:4] + assignment[7:4] ;
                running_sum_3 <= assignment[3:0] + assignment[3:0] + 2 + assignment[7:4] + assignment[7:4] + 2 + assignment[11:8] + assignment[11:8];
                running_sum_4 <= 5'b11111;
                running_sum_5 <= 5'b11111;

                
            end else if (assignment[15:12]>1'b0 && assignment[19:16]<=1'b0) begin
                number_of_breaks<=3;
                number_of_numbers<=4;
                space_to_fill_left <= 10 - assignment[3:0] - assignment[7:4] - assignment[11:8] - assignment[15:12]  - 3;

                min_length <= assignment[3:0] + assignment[7:4] + assignment[11:8] + assignment[15:12] + 3; // min lenght of the run

                
            end else if (assignment[19:16]>1'b0) begin
                number_of_breaks<=4;
                number_of_numbers<=5;
                min_length <= assignment[3:0] + assignment[7:4] + assignment[11:8] + assignment[15:12] + assignment[19:16] + 4; // min lenght of the run
                space_to_fill_left <= 10 - (assignment[3:0] + assignment[7:4] +assignment[11:8]  + assignment[15:12] + assignment[19:16]) -4;

                
            end
        end
        
    end

endmodule

`default_nettype wire