`default_nettype none

//implmentation for at most 6 breaks sorry hardcoded
module generate_rows(   
                    input wire clk_in,
                    input wire start_in,
                    input wire reset_in,
                    input wire [19:0] assignment,
                    output logic done,
                    output logic new_row,
                    output logic count //returns the tola nbumber of optison returend for a given setging


    );  

    //you cna have state

    //you can keep track if the old assingemtn is the same or differnt to the one passed in the input 

    //frist i will get all the permutation for a given row and then sue them to genrate all tehr rows
    //returns one row state at  clock cycle


    logic  [2:0] number_of_breaks;
    logic  [2:0] space_to_fill_left;
    logic [11:0] breaks;
    logic done;
    logic [5:0] count;

    logic [3:0] constrain1;
    logic [3:0] constrain2;
    logic [3:0] constrain3;
    logic [3:0] constrain4;
    logic [3:0] constrain5;

    logic [4:0] permutation_min_length;


    create_a_row my_create_a_row (
        .clk_in(clk_in),
        .reset_in(reset_in),
        .constrain1(constrain1),
        .constrain2(constrain2),
        .constrain3(constrain3),
        .constrain4(constrain4),
        .constrain5(constrain5),
        .number_of_constraints(number_of_numbers)
        .break1(permutation[0:2]),
        .break2(permutation[3:5]),
        .break3(permutation[6:8]),
        .break4(permutation[9:11]),
        .assignment_out(new_row),
        .done(done_generation),
        .min_length(permutation_min_lengt) //retusn the min length fomr black to black that covers all blacks
    );



    get_permutations my_get_permutations(   
                    .clk_in(clk_in),
                    .start_in(),
                    .number_of_breaks(number_of_breaks),//at most 4 breaks
                    .space_to_fill_left(space_to_fill_left), // at most 5 space left (exclude teh compuslory break on the left)
                    .breaks(permutation_out), //  mak of 4 breaks, eahc max encoded by 3 bits 4*3 ==12
                    .done(returned_all_permutations),
                    .count(permutation_count) //returns the tola nbumber of optison returend for a given setging

    );

    logic [2:0] number_of_breaks;
    logic [2:0] space_to_fill_left;
    logic returned_all_permutations;
    logic [11:0] permutation;
    logic [11:0] permutation_out;
    logic [] permutation_count;
    logic [] counter;

    logic [4:0] permutations_min_length_list [29:0]; //at most 30 permuations


    logic [11:0] permutations_list [29:0]; //at most 30 permuations for a agiven set of constraints


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

        end else if (create_rows_from_permutations) begin

            if(~generating || done_generation) begin
                counter <=counter +1;
                generating<=1;
                started_generator <=1;
                permutation <= permutations_list[counter]; // input to create_a_row module
                
            end else if (generating) begin
                
                started_generator <=0;
            end

            if(counter == permutation_count-1) begin

                //i have created and output all the rows for given cosntrinats
                create_rows_from_permutations <=0;
                permutation_started<=0
                done<=1;
                generate_states_from_permutations <=1;
                data_collected <=1;
                
            end


        end else if (permutation_started) begin

            permutations_list[counter] <= permutation_out; // save the "basic" state of the row (shifted to right hand side) => in the NEXT STATE we need to shof it to the right :')
            counter <=counter +1;
            if(counter == permutation_count-1) begin
                create_rows_from_permutations <=1;
                permutation_started<=0
                counter<=0;
                permutation_counter<=0; // used i nthe next state 
                
                generate_states_from_permutations<=1; // okey now we need to shift each basic state kill me
                
            end

        end else if (generate_states_from_permutations) begin
            //we are done with gerneating all the "basic" states for a given csontrin set > shift each basic set to left


                if(~started_shifting) begin

                //we either just entered this state or we are done with shofting for  agiven basci state > introduce a enw basic state to new_row

                    new_row <=permutations_list[permutation_counter];
                    permutation_counter <= permutation_counter +1;
                    started_shifting <= started_shifting +1;
                    shifts_limit <= 20 - permutations_min_length_list[permutation_counter]; //20 - min_length 
                    shifts <=0;
                    
                end else begin

                //we are in the rpocess of shofting a given state 

                    if(shifts < shifts_limit) begin
                    //we are still allowed to shift
                        new_row <= {new_row<<2, 2'b10};
                        shifts <=shifts+2;
                        
                    end else begin
                        started_shifting <=0;
                        
                       
                        
                    end


                    
                end

                

                // if(started_shifting) begin
                //     count<=count+1;
                //     new_row <= permutation; 
                // end else begin if( permutation_counter == permutation_count-1 ) begin
                //     done<=1;
                    
                
                // end else begin
    
                //     if(shifts < shifts_limit) begin
                //         new_row <= {new_row<<2, 2'b10};
                //         shifts <=shifts-2;
                        
                //     end else begin
                //         started_shifting <=0;
                //         //permutation<=permutations_list[permutation_counter];
                //         new_row <=permutations_list[permutation_counter];
                        
                //     end



                // end







        end else if (data_collected) begin

            //WRONG wow so helpful 

            

            //we have collected all the permutatiosn but now we need to shift them

            end else if(min_length == 20) begin

                for(interger i; i<18; i=i+2) begin
                    if(i <assignment[3:0]*2) begin
                            new_row[i] <= 1;
                            new_row[i+1] <= 0;
                    end else if( i == assignment[3:0]*2) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                    end else if(i <assignment[7:4]*2) begin
                            new_row[i] <= 1;
                            new_row[i+1] <= 0;
                    end else if( i == assignment[7:4]*2) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                    end else if(i <assignment[11:8]*2) begin
                            new_row[i] <= 1;
                            new_row[i+1] <= 0;
                    end else if( i == assignment[11:8]*2) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                    end else if(i <assignment[15:12]*2) begin
                            new_row[i] <= 1;
                            new_row[i+1] <= 0;
                    end else if( i == assignment[19:16]*2) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                    end else if( i == assignment[19:16]*2) else begin
                            new_row[i] <= 0;
                            new_row[i+1] <= 1;
                    end

                        

            end else if(number_of_numbers == 1) begin

                if(len_1_started) begin

                    new_row <=new_row <<1;
                    if(output_counter == count) begin
                        done <=1;
                        data_collected<=0;
                    end

                end else begin
                    len_1_started<=1;
                    output_counter <=output_counter+1;

                    count <= 2'd20 - assignment[3:0] +1'd1;
                    new_row<={};
                    for(interger i; i<18; i=i+2) begin
                        if(i <assignment[3:0] + assignment[3:0]) begin
                            new_row[i] = 1;
                            new_row[i+1] = 0;
                        end else begin
                            new_row[i] = 0;
                            new_row[i+1] = 1;
                        end

                        
                    end


                end

            end else begin
                //we can genreates statees "logically" - f

                permutation_started <=1;
                data_collected<=0;
            end
            
            
        end else begin
            data_collected<=1;
            constrain1<=assignment[3:0];
            constrain2<=assignment[7:4];
            constrain3<=assignment[11:8];
            constrain4<=assignment[15:12];
            constrain5<=assignment[19:16;

            //gernate numebr of breaks and spaces lef based on the passed cosntraints 

            if(assignment[3:0]>0) begin
                min_length <= number_of_constraints + assignment[3:0] -1;
                number_of_breaks<=0;
                number_of_numbers<=1;
                space_to_fill_left <= 20 - assignment[3:0] - assignment[7:4] - assignment[11:8] - assignment[15:12] - assignment[19:16];

            end else if (assignment[7:4]>0) begin
                number_of_breaks<=1;
                number_of_numbers<=2;
                min_length <= number_of_constraints + assignment[3:0] + assignment[7:4] -1;
                space_to_fill_left <= 20 - assignment[3:0] - assignment[7:4] - assignment[11:8] - assignment[15:12] - assignment[19:16] - 

                
            end else if (assignment[11:8]>0) begin
                number_of_breaks<=2;
                number_of_numbers<=3;
                min_length <= number_of_constraints + assignment[3:0] + assignment[7:4] +assignment[11:8]  -1;

                
            end else if (assignment[15:12]>0) begin
                number_of_breaks<=3;
                number_of_numbers<=4;
                min_length <= number_of_constraints + assignment[3:0] + assignment[7:4] +assignment[11:8]  + assignment[15:12]-1;

                
            end else if (assignment[19:16]>0) begin
                number_of_breaks<=4;
                number_of_numbers<=5;
                min_length <= number_of_constraints + assignment[3:0] + assignment[7:4] +assignment[11:8]  + assignment[15:12] + assignment[19:16]-1;

                
            end
        end
        
    end

endmodule

`default_nettype wire