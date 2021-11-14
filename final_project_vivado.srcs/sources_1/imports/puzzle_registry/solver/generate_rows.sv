`default_nettype none
//TODO - FSM is wrong
// get assginements > gerneate all pemutations (n umerical) for the assingement > based on each permutaion, gernate a basic row > shoft eahc basic row as much as psosible > move to the next basic row
//implmentation for at most 6 breaks sorry hardcoded
module generate_rows(   
                    input wire clk_in,
                    input wire start_in,
                    input wire reset_in,
                    input wire [19:0] assignment,
                    output logic done,
                    output logic outputing, //asserted when the new_row is ready on the output (fully)
                    output logic [19:0] new_row,
                    output logic [6:0] count, //current index of the row in the set of that we are oging to return 
                    output logic [6:0] total_count //returns the tola nbumber of optison returend for a given setging


    );  

    //TODO - only start gneraiotn when new start_in is received BC it's possiblr to have two same assigemnet snext to each other and then we would not return anythgin in hat case 
        // TODO: ^^ might be worn due to how iterative sovler operates  - check how start_in is asserted

    //you cna have state

    //you can keep track if the old assingemtn is the same or differnt to the one passed in the input 

    //frist i will get all the permutation for a given row and then sue them to genrate all tehr rows
    //returns one row state at  clock cycle

    parameter original = 20'b10101010101010101010;

    logic [5:0] i; //counter in for llop for 20 row genration


    logic  [2:0] number_of_breaks;
    logic  [2:0] space_to_fill_left;
    logic [11:0] breaks;
    logic done;
    logic [6:0] count;

    logic [3:0] constrain1;
    logic [3:0] constrain2;
    logic [3:0] constrain3;
    logic [3:0] constrain4;
    logic [3:0] constrain5;
    logic [4:0] permutation_min_length;
    logic [2:0] number_of_numbers; // 5 is the max numer 
    logic [2:0] number_of_breaks;
    logic [2:0] space_to_fill_left;

    logic returned_all_permutations;
    logic [15:0] permutation; // 6 bits encoding of breaks frm permutaiont module

    logic [11:0] permutation_out;
    logic [5:0] permutation_count;
    logic [5:0] counter; //used to coutn permutations when they are being returned
    
    logic [4:0] permutations_min_length_list [60:0]; //61 arryas of 5 bits ? 
    logic [16:0] permutations_list [60:0]; //stroes numebrs -at most 30 permuations for a agiven set of constraints
    
    logic [19:0] basic_row_storage [60:0]; //stores actual rows - at most 60 row states 
    
    
    
    
    
    logic in_progress;


    create_a_row my_create_a_row (
        .clk_in(clk_in),
        .reset_in(reset_in),
        .start_in(start_generator),
        .new_data(new_data),
        .constrain1(constrain1),
        .constrain2(constrain2),
        .constrain3(constrain3),
        .constrain4(constrain4),
        .constrain5(constrain5),
        .number_of_constraints(number_of_numbers)
        .break1(permutation[3:0]),
        .break2(permutation[7:4]),
        .break3(permutation[11:8]),
        .break4(permutation[15:10]),
        .assignment_out(new_row),
        .done(done_generation),
        .min_length(permutation_min_length) //retusn the min length fomr black to black that covers all blacks
    );

    get_permutations my_get_permutations(   
                    .clk_in(clk_in),
                    .start_in(permutation_started), // asserted when we want to start generating permutations
                    .number_of_breaks(number_of_breaks),//at most 4 breaks
                    .space_to_fill_left(space_to_fill_left), // at most 5 space left (exclude teh compuslory break on the left)
                    .breaks(permutation_out), //  mak of 4 breaks, eahc max encoded by 3 bits 4*3 ==12
                    .done(returned_all_permutations),

                    .total_counter(permutation_count) //returns the tola nbumber of optison returend for a given setging

    );




    always_ff @(posedge clk_in) begin

        if(reset_in) begin

            number_of_breaks<=0;
            space_to_fill_left<=0;
            start_in<=0;
            new_row<=20'b0;
            output_counter <=0;
            counter<=0;
            permutation_started<=0
            data_collected<=0;
            create_rows_from_permutations <=0;
            permutation_counter <=0;
            count<=0;
            in_progress <=0;
            

        end else if (create_a_row_from_permutations) begin

            // create BASIC rows 

            if(~generating) begin
                counter <=counter +1;
                generating<=1;
                start_generator <=1;
                new_data <=1; //used in create a row to mark incommingn new data
                permutation <= permutations_list[counter]; // input to create_a_row module - it only retusn ONE row per permutaiont numerbs - the basic one, shifted to the left 
                
            end else if (generating) begin
                start_generator <=0;
                new_data <=0; //used in create a row to mark incommingn new data
            end else if (done_generation) begin
                //save returned row
                basic_row_storage[counter] <= new_row;
                permutations_min_length_list[counter] <= permutation_min_length;
                generating<=0;

            end

            if(counter == permutation_count-1) begin

                //i have created and output all the rows for given cosntrinats
                create_a_row_from_permutations <=0;
                permutation_started<=0
                

                in_progress <=0;

                generate_rows_from_basic <=1;
                counter <=0;
                new_data <=0;
                
            end


        end else if (permutation_started) begin

            permutations_list[counter] <= permutation_out; // save the "basic" state of the row (shifted to right hand side) => in the NEXT STATE we need to shof it to the right :')
            
            
            counter <=counter +1;
            if(returned_all_permutations) begin
                create_a_row_from_permutations <=1;
                permutation_started<=0
                counter<=0;
                permutation_counter<=0; // used i nthe next state 
                
                
            end

        end else if (generate_rows_from_basic) begin
            //we are done with gerneating all the "basic" states for a given csontrin set > shift each basic set to left


                if(~started_shifting) begin

                //we either just entered this state or we are done with shofting for  agiven basci state > introduce a enw basic state to new_row

                    new_row <=basic_row_storage[permutation_counter];
                    outputing <=1;
                    count <= count +1;
                    permutation_counter <= permutation_counter +1;
                    started_shifting <= 1;

                    shifts_limit <= 20 - permutations_min_length_list[permutation_counter]; //20 - min_length 
                    shifts <=0;
                    started_shifting <=1;

                    if(permutation_counter == permutation_count -1) begin
                        done<=1; // finish the whole genratE_row
                        generate_states_from_permutations <=0; // [otenailly need  ozero all the staes here ust to make sure
                    end


                    
                end else begin

                //we are in the rpocess of shofting a given state 

                    if(shifts < shifts_limit) begin
                    //we are still allowed to shift
                        new_row <= {new_row<<2, 2'b10};
                        shifts <=shifts+2;
                        outputing <=1;
                        count <= count +1;
                        
                    end else begin
                        started_shifting <=0;
                        outputing <=0;
                        
                       
                        
                    end


                    
                end


        end else if (data_collected && in_progress) begin

            //we have collected all the permutatiosn but now we need to shift them

            if(min_length == 20) begin
                //if it's the "best case scenario" - we have onyl one posible way to create a row - return it right away
                i<=i+2;

                
                if(i <assignment[3:0]+assignment[3:0]) begin
                            new_row[i] <= 1;
                            new_row[i+1] <= 0;
                    end else if( i == assignment[3:0]+assignment[3:0]) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                    end else if(i <assignment[7:4]+assignment[7:4]) begin
                            new_row[i] <= 1;
                            new_row[i+1] <= 0;
                    end else if( i == assignment[7:4]+assignment[7:4]) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                    end else if(i <assignment[11:8]+assignment[11:8]) begin
                            new_row[i] <= 1;
                            new_row[i+1] <= 0;
                    end else if( i == assignment[11:8]+assignment[11:8]) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                    end else if(i <assignment[15:12]+assignment[15:12]) begin
                            new_row[i] <= 1;
                            new_row[i+1] <= 0;
                    end else if( i == assignment[15:12]+assignment[15:12]) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                    end else if( i < assignment[19:16]+assignment[19:16) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                end

                if(i == min_length-2) begin
                    done<=1;
                    count<=1;
                    i<=0;
                end

                        

            end else if(number_of_numbers == 1) begin

                //we have a single constrain

                if(len_1_started) begin
                    
                    count <= count+1; //increment the "idnex" of the returend row

                    new_row <= new_row <<1; //shoft one to the left

                    if(count == total_count-1) begin
                        done <=1;
                        data_collected<=0;
                        
                        outputing<=0;
                        len_1_started <=0;
                        in_progress <=0;
                    end

                end else begin
                    //start internal fsm to shift
                    
                    total_count <= 7'd20 - assignment[3:0] +1'd1; // total number of rows toreturn 
                    
                    i<=i+2;
                    
                    if(i <assignment[3:0] + assignment[3:0]) begin
                            new_row[i] = 1;
                            new_row[i+1] = 0;
                    end else begin
                            new_row[i] = 0;
                            new_row[i+1] = 1;
                    end

                    if( i == 18) begin
                        len_1_started<=1;
                        outputing<=1;
                        i<=0;
                        count <=count+1;
                        
                    end

                        
                    end


                end


            end else begin
                //we can genreates statees "logically" - f

                permutation_started <=1;
                data_collected<=0;
            end
            
            
        end else if (start_in && ~in_progress) begin

            //we have provided new data in assingemtne > syart the whole fsm again 
            data_collected<=1;
            in_progress <=1; //start generation

            //zero all the values that might have been assignesd to sth before
            total_count <=0;
            count <=0;
            done <=0;
            outputing <=0;

            constrain1<=assignment[3:0];
            constrain2<=assignment[7:4];
            constrain3<=assignment[11:8];
            constrain4<=assignment[15:12];
            constrain5<=assignment[19:16;

            //gernate numebr of breaks and spaces lef based on the passed cosntraints 

            if(assignment[3:0]>0) begin
                min_length <= number_of_constraints + assignment[3:0] -1;
                number_of_breaks<=3'd0;
                number_of_numbers<=3'd1;
                space_to_fill_left <= 20 - assignment[3:0] - assignment[7:4] - assignment[11:8] - assignment[15:12] - assignment[19:16];

            end else if (assignment[7:4]>0) begin
                number_of_breaks<=1;
                number_of_numbers<=2;
                min_length <= number_of_constraints + assignment[3:0] + assignment[7:4] -1;
                space_to_fill_left <= 20 - assignment[3:0] - assignment[7:4] - assignment[11:8] - assignment[15:12] - assignment[19:16] - 1;

                
            end else if (assignment[11:8]>0) begin
                number_of_breaks<=2;
                number_of_numbers<=3;
                space_to_fill_left <= 20 - assignment[3:0] - assignment[7:4] - assignment[11:8]  - 2;


                min_length <= assignment[3:0] + assignment[7:4] + assignment[11:8] + 2; // min lenght of the run

                
            end else if (assignment[15:12]>0) begin
                number_of_breaks<=3;
                number_of_numbers<=4;
                space_to_fill_left <= 20 - assignment[3:0] - assignment[7:4] - assignment[11:8] - assignment[15:12]  - 3;

                min_length <= assignment[3:0] + assignment[7:4] + assignment[11:8] + assignment[15:12] + 3; // min lenght of the run

                
            end else if (assignment[19:16]>0) begin
                number_of_breaks<=4;
                number_of_numbers<=5;
                min_length <= assignment[3:0] + assignment[7:4] + assignment[11:8] + assignment[15:12] + assignment[19:16] + 4; // min lenght of the run
                space_to_fill_left <= 20 - (assignment[3:0] + assignment[7:4] +assignment[11:8]  + assignment[15:12] + assignment[19:16]) -4;

                
            end
        end
        
    end

endmodule

`default_nettype wire