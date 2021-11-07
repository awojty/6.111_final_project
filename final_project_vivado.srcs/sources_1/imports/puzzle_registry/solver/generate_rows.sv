`default_nettype none

//implmentation for at most 6 breaks sorry hardcoded
module generate_rows(   
                    input wire clk_in,
                    input wire start_in,
                    input wire assignment,
                    input wire [2:0] number_of_constraints,//at most 4 breaks
                    output logic done,
                    output logic new_row,
                    output logic count //returns the tola nbumber of optison returend for a given setging


    );  

    //you cna have state

    //you can keep track if the old assingemtn is the same or differnt to the one passed in the input 

    //frist i will get all the permutation for a given row and then sue them to genrate all tehr rows
    //returns one row state at  clock cycle 

    get_permutations my_get_permutations(   
                    input wire clk_in,
                    input wire start_in,
                   
                    input wire [2:0] number_of_breaks,//at most 4 breaks
                    input wire [2:0] space_to_fill_left, // at most 5 space left
//most signifcant bits encode numebrs
                    output logic [11:0] breaks, //  mak of 4 breaks, eahc max encoded by 3 bits 4*3 ==12
                    output logic done,
                    output logic count //returns the tola nbumber of optison returend for a given setging


    );  

endmodule

`default_nettype wire