`default_nettype none
//tested - also on chaing input
module constraint_generator(   
                    input wire clk_in,
                    input wire reset_in,
                    input wire start_in, //when asserte, start accumulating
                    input wire [39:0][29:0] image_in ,
                    output  logic [119:0][69:0] constraints_out ,
                    output logic done //320 by 240

    ); 

    logic  [39:0][29:0] image_stored;
//    logic [39:0] column_constraint_storage [39:0];
//    logic [39:0] row_constraint_storage [29:0];

    logic [119:0] [69:0] constraint_storage;


    parameter [5:0] height = 30;
    parameter [5:0] width = 40;

    logic [5:0] run_length;
    logic [5:0] constraint_count; //counts the number of cosntraints in the given row
    logic [5:0] constraint_count_index;

    logic [119:0] temporary_constraint;

    logic [8:0]  constraint_counter;
    
    logic process_columns;

    logic [5:0] i;
    logic [5:0] j;
    
    logic process_rows;
    
    logic run_started;
    logic output_constraints;
    logic move_to_output;
    logic save_constraint;
    logic move_to_columns;
    logic in_progress;
    //120 is the max length since 6b* 20 = 6 bits for 40 and max number of 20 constrainst die to 40 widht 


    always_ff @(posedge clk_in) begin
        if(reset_in) begin
            constraint_counter<=0;
            
            process_columns <=0;
            run_started <= 0;
            j<=0;
            i <=0;
            temporary_constraint<=120'b0;
            output_constraints <=0;
            move_to_output<=0;
            save_constraint <=0;
            move_to_columns<=0;
            done <=0;
            process_rows <=0;
            in_progress <=0;
            constraint_count <=0;
            constraint_count_index <= 0;
            run_length <=0;
             
        end else begin

            if (start_in && ~in_progress) begin
            
                image_stored <=image_in;
                process_rows <= 1;
                in_progress <=1;



                //reset on new input
                constraint_counter<=0;
                process_columns <=0;
                run_started <= 0;
                j<=0;
                i <=0;
                temporary_constraint<=120'b0;
                output_constraints <=0;
                move_to_output<=0;
                save_constraint <=0;
                move_to_columns<=0;
                done <=0;
                
                
                constraint_count <=0;
                constraint_count_index <= 0;
                run_length <=0;

                 
  
            end else if (process_rows && ~save_constraint) begin


                if( i == height) begin
                    //dong zero run legnth here since its gonna be used in the save step 
                    process_rows <=0;
                    move_to_columns <=1;
                    run_started <=0;
                    j<=0;
                    i <=0;
                    save_constraint <=1;
                    constraint_count_index<=0;

                end else begin

                    if((image_stored[i][j] == 1) && run_started) begin
                        run_length <=run_length +1;
                        j <= j + 1;

                    end else if((image_stored[i][j] == 1) && ~run_started) begin
                        run_length <=6'b1;
                        j <= j + 1;
                        run_started <=1;

                    
                    end else if((image_stored[i][j] == 0) && run_started) begin
                        run_started <=0;
                        
                        constraint_count_index <= 6 +constraint_count_index; // add 6 since there are 6 bots per number
                        j <= j + 1;
                        //run_length <=0;

                        temporary_constraint[constraint_count_index] <=run_length[0];
                        temporary_constraint[constraint_count_index+1] <=run_length[1];
                        temporary_constraint[constraint_count_index+2] <=run_length[2];
                        temporary_constraint[constraint_count_index+3] <=run_length[3];
                        temporary_constraint[constraint_count_index+4] <=run_length[4];
                        temporary_constraint[constraint_count_index+5] <=run_length[5];


                    end else if(image_stored[i][j] == 0 && ~run_started) begin
                        j <= j + 1;
                        run_started <=0;

                    end

                    if( j == width-1) begin
                        
                        j<=0;
                        i <= i +1;
                        run_started <=0;
                        save_constraint <=1;

                        if (run_started) begin

                            temporary_constraint[constraint_count_index] <=run_length[0];
                            temporary_constraint[constraint_count_index+1] <=run_length[1];
                            temporary_constraint[constraint_count_index+2] <=run_length[2];
                            temporary_constraint[constraint_count_index+3] <=run_length[3];
                            temporary_constraint[constraint_count_index+4] <=run_length[4];
                            temporary_constraint[constraint_count_index+5] <=run_length[5];

                        end
                    end




                end




            end else if (save_constraint) begin
                run_length <=0;
                run_started <=0;
                save_constraint <=0;
                temporary_constraint <=0;
                constraint_storage[constraint_counter] <=temporary_constraint;
                //constraint_counter <= constraint_counter + 1; // coutns row/colummn
                constraint_count_index <= 0;


                if(move_to_columns) begin
                    process_columns <=1;
                    move_to_columns<=0;
                    i<=0;
                    j<=0;
                    constraint_counter <= constraint_counter ;
                end else begin
                    constraint_counter <= constraint_counter + 1;


                end

                if(move_to_output)begin
                    output_constraints <=1;
                    move_to_output<=0;
                    i<=0;
                    j<=0;
                end

            end else if ( process_columns && ~save_constraint) begin


                if(width == j) begin

                    process_rows <=0;
                    process_columns <=0;
                    run_started <=0;
                    j<=0;
                    i <=0;
                    move_to_output <=1;
                    save_constraint <=1;

                    
                end else begin

                    if(image_stored[i][j] == 1 && run_started) begin
                        run_length <=run_length +1;
                        i <= i + 1;

                    end else if(image_stored[i][j] == 1 && ~run_started) begin
                        run_length <=1;
                        i <= i + 1;
                        run_started <=1;

                    
                    end else if(image_stored[i][j] == 0 && run_started) begin
                        run_started <=0;
                        constraint_count <=1 +constraint_count;
                        constraint_count_index <= 6 +constraint_count_index; // add 6 since there are 6 bots per number
                        i <= i + 1;
                        //run_length <=0;
                        temporary_constraint[constraint_count_index] <=run_length[0];
                        temporary_constraint[constraint_count_index+1] <=run_length[1];
                        temporary_constraint[constraint_count_index+2] <=run_length[2];
                        temporary_constraint[constraint_count_index+3] <=run_length[3];
                        temporary_constraint[constraint_count_index+4] <=run_length[4];
                        temporary_constraint[constraint_count_index+5] <=run_length[5];

                    end else if(image_stored[i][j] == 0 && ~run_started) begin
                        i <= i + 1;

                    end

                    if( i == height-1) begin
                    
                        save_constraint <=1;
                        j<=j+1;
                        i <= 0;
                        run_length <=0;
                        run_started <=0;

                        if (run_started) begin

                            temporary_constraint[constraint_count_index] <=run_length[0];
                            temporary_constraint[constraint_count_index+1] <=run_length[1];
                            temporary_constraint[constraint_count_index+2] <=run_length[2];
                            temporary_constraint[constraint_count_index+3] <=run_length[3];
                            temporary_constraint[constraint_count_index+4] <=run_length[4];
                            temporary_constraint[constraint_count_index+5] <=run_length[5];

                        end

                    end



                end




            end else if (output_constraints) begin
                done <=1;
                constraints_out <= constraint_storage;
                in_progress <=0;


            end




        end


    






        
    end






endmodule