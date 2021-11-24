module top_level_solver(
    input logic clk_in,
    input logic start_in, // assered when in the correct stata
    input logic [15:0] sw,
    input logic btnc,
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


    iterative_solver my_iterative_solver(   
                    .clk_in(clk_in),
                    .reset_in(reset_in),
                    .index_in(index_in), //idnex of row/col beign send - max is 20 so 6 bits
                    .column_number_in(10), //grid size - max 10
                    .row_number_in(10), //grid size - max 10
                    .assignment_in(assignment_in_solver), // array of cosntraitnrs in - max of 20 btis since 4 btis * 5 slots
                    .start_sending_nonogram(start_sending_nonogram), //if asserted to 1, im in the rpcoess of sendifg the puzzle
                    .solution_out(nonogram_solver_done)
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

                    
    ); 



    assignments_registry my_assignments_registry(
        .clk_in(clk_in), 
        .rst_in(rst_in), 
        .start_in(done_address),
        .row_number_in(dimensions[15:7]),
        .col_number_in(dimensions[6:0]),
        .address_in(address), 
        .assignment_out(assignment_out1),
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




   always_ff @(posedge clk_in) begin

    if(reset_in) begin

        row1_in_translator <= 0;
        row2_in_translator <= 0;
        row3_in_translator <= 0;
        row4_in_translator <= 0;
        row5_in_translator <= 0;
        row6_in_translator <= 0;
        row7_in_translator <= 0;
        row8_in_translator <= 0;
        row9_in_translator <= 0;
        row10_in_translator <= 0;

        row1_out_solver <=0;
        row2_out_solver <=0;
        row3_out_solver <=0;
        row4_out_solver <=0;
        row5_out_solver <=0;
        row6_out_solver <=0;
        row7_out_solver <=0;
        row8_out_solver <=0;
        row9_out_solver <=0;
        row10_out_solver <=0;

        start_sending_nonogram<=0;
        nonogram_solver_done<=0;
        start_in_translator <=0;
        

    end else begin


        if(start_in && ~in_progress) begin

            start_getting_assignment <=1;
            in_progress <=1;

            
        end else if (sending) begin

            start_sending_nonogram<=1;
            assignment_in_solver <=assignment_out1;
            index_in_solver <= index_out_registry;
        end else if (~sending && start_sending_nonogram) begin
            start_sending_nonogram<=0;
            
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