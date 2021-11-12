module fix_row( 

    input wire row_in,
    input wire clk_in,
    input wire reset_in,
    input wire start_in,
    input wire n, // paramter to the function in the python file
    input wire [9:0] c,
    input wire [19:0] row_in,
    input wire current_permutation_count,
    input wire number_of_items_in_cols_n,
    input wire done_sending_columns, //asswerted when whole cols[n] is sent
    input wire mod_cols_in,
    input wire can_do_in,
    input wire [9:0] allowable_output_rows [19:0], //there are ten rows of length 20 --alowabale berges or permutaitons into one
    output logic new_permution_count,
    output logic row_out,
    output logic can_do_out,
    output logic mod_cols_out,
    output logic done_fix_row

);

endmodule