module top_level_solver(
    input wire clk_in,
    input wire start_in, // assered when in the correct stata
    input wire reset_in,
    input wire get_output,
    input wire [15:0] sw,
    output logic sending_assignment,
    output logic [19:0] assignment_out,
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
    output logic top_level_solver_done,
    output logic assignment_out_done

   );

   translator my_translator(   
                    .clk_in(clk_in),
                    .reset_in(reset_in),
                    .start_in(start_in_translator),
                    .row1(row1_in_translator),
                    .row2(row2_in_translator),
                    .row3(row3_in_translator),
                    .row4(row4_in_translator),
                    .row5(row5_in_translator),
                    .row6(row6_in_translator),
                    .row7(row7_in_translator),
                    .row8(row8_in_translator),
                    .row9(row9_in_translator),
                    .row10(row10_in_translator),
                    .row1_out(row1_out_translator),
                    .row2_out(row2_out_translator),
                    .row3_out(row3_out_translator),
                    .row4_out(row4_out_translator),
                    .row5_out(row5_out_translator),
                    .row6_out(row6_out_translator),
                    .row7_out(row7_out_translator),
                    .row8_out(row8_out_translator),
                    .row9_out(row9_out_translator),
                    .row10_out(row10_out_translator),
                    .done(translator_done));


    iterative_solver_wth_reset my_iterative_solver(   
                    .clk_in(clk_in),
                    .reset_in(reset_in),
                    .index_in(counter_out), //idnex of row/col beign send - max is 20 so 6 bits
                    .column_number_in(4'd10), //grid size - max 10
                    .row_number_in(4'd10), //grid size - max 10
                    .assignment_in(assignment_in_solver), // array of cosntraitnrs in - max of 20 btis since 4 btis * 5 slots
                    .start_sending_nonogram(sending && nonogram_part), //if asserted to 1, im in the rpcoess of sendifg the puzzle
                    .solution_out(nonogram_solver_done),
                    .row1(row1_in_translator),
                    .row2(row2_in_translator),
                    .row3(row3_in_translator),
                    .row4(row4_in_translator),
                    .row5(row5_in_translator),
                    .row6(row6_in_translator),
                    .row7(row7_in_translator),
                    .row8(row8_in_translator),
                    .row9(row9_in_translator),
                    .row10(row10_in_translator)

                    
    ); 



    assignments_registry my_assignments_registry(
        .clk_in(clk_in), 
        .reset_in(reset_in), 
        .start_in(start_getting_assignment),
        .address_in(sw), 
        .assignment_out(assignment_in_solver),
        .sending(sending),
        .counter_out(counter_out),
        .done(done));


   logic nonogram_solver_done;
   logic start_sending_nonogram;
   logic start_in_translator;

   logic [19:0] row1_in_translator;
   logic [19:0] row2_in_translator;
   logic [19:0] row3_in_translator;
   logic [19:0] row4_in_translator;
   logic [19:0] row5_in_translator;
   logic [19:0] row6_in_translator;
   logic [19:0] row7_in_translator;
   logic [19:0] row8_in_translator;
   logic [19:0] row9_in_translator;
   logic [19:0] row10_in_translator;

   logic [9:0] row1_out_translator;
   logic [9:0] row2_out_translator;
   logic [9:0] row3_out_translator;
   logic [9:0] row4_out_translator;
   logic [9:0] row5_out_translator;
   logic [9:0] row6_out_translator;
   logic [9:0] row7_out_translator;
   logic [9:0] row8_out_translator;
   logic [9:0] row9_out_translator;
   logic [9:0] row10_out_translator;
   
   logic in_progress;
   logic move_to_translator;
   
   logic [19:0] assignment_in_solver;
   logic start_getting_assignment;

   logic [19:0] assignment_out1;
   logic sending;

   logic [19:0] temporary_storage [19:0];


   logic [5:0] counter_out;

   logic [5:0] index;
   logic take_in;
   logic start_getting_output;
   logic start_getting_assignment1;
   logic nonogram_part;




   always_ff @(posedge clk_in) begin

    if(reset_in) begin

//        row1_in_translator <= 0;
//        row2_in_translator <= 0;
//        row3_in_translator <= 0;
//        row4_in_translator <= 0;
//        row5_in_translator <= 0;
//        row6_in_translator <= 0;
//        row7_in_translator <= 0;
//        row8_in_translator <= 0;
//        row9_in_translator <= 0;
//        row10_in_translator <= 0;
//        assignment_in_solver<=0;
        //sending <=0;
        take_in <=0;



        start_sending_nonogram<=0;
        //nonogram_solver_done<=0;
        start_in_translator <=0;
        top_level_solver_done<=0;
        in_progress<=0;
        move_to_translator<=0;
        start_getting_assignment <=0;
        assignment_out1<=0;
        //counter_out <=0;
        index <=0;
        start_getting_output <= 0;
        start_getting_assignment1 <= 0;
        sending_assignment<=0;
        nonogram_part <=0;
        

    end else begin
        assignment_out_done <=0;

        if(get_output && ~start_getting_output) begin
            
            start_getting_output <= 1;
            start_getting_assignment <= 1;
            index <= 0;

        end else if (sending && start_getting_output) begin

            assignment_out <= assignment_in_solver;
            start_getting_assignment1 <= 1;
            sending_assignment<=1;
            
        end else if (~sending && start_getting_assignment1) begin
            start_getting_assignment1 <= 0;
            assignment_out_done <= 1;
            start_getting_output <= 0;
            sending_assignment <=0;
        
        end


        if(start_in && ~in_progress) begin

            start_getting_assignment <=1;
            in_progress <=1;
            index <=0;
            nonogram_part <=1;


        end else if (sending && in_progress) begin
            start_sending_nonogram<=1;
            nonogram_part <=1;
            //assignment_in_solver <=assignment_out1;
            temporary_storage[index] <= assignment_in_solver;
            index <=index + 1;
            start_getting_assignment <=0;


            //index_in_solver <= index_out_registry;
        end else if (~sending && start_sending_nonogram ) begin
            start_sending_nonogram<=0;
            take_in <=0;
            nonogram_part <=0;
            
        end else if (nonogram_solver_done && ~move_to_translator) begin

                start_in_translator <=1;
                move_to_translator <=1;
                // row1_in_translator <= row1_out_solver;
                // row2_in_translator <= row2_out_solver;
                // row3_in_translator <= row3_out_solver;
                // row4_in_translator <= row4_out_solver;
                // row5_in_translator <= row5_out_solver;
                // row6_in_translator <= row6_out_solver;
                // row7_in_translator <= row7_out_solver;
                // row8_in_translator <= row8_out_solver;
                // row9_in_translator <= row9_out_solver;
                // row10_in_translator <= row10_out_solver;
        end else if (~translator_done && move_to_translator) begin
            start_in_translator <=0; // free the button 


        end else if (translator_done && move_to_translator) begin
            move_to_translator <=0;
            start_in_translator <=0;

            top_level_solver_done <=1;
            row1_out <=row1_out_translator;
            row2_out <=row2_out_translator;
            row3_out <=row3_out_translator;
            row4_out <=row4_out_translator;
            row5_out <=row5_out_translator;
            row6_out <=row6_out_translator;
            row7_out <=row7_out_translator;
            row8_out <=row8_out_translator;
            row9_out <=row9_out_translator;
            row10_out <=row10_out_translator;

        end


        

    end

       

   end

endmodule
