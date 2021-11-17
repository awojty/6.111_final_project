//`default_nettype none
//module top_level_display(input wire clk_100mhz, 
//					input wire [15:0] sw, 
//					input wire btnc,

//					output logic ca,cb,cc,cd,ce,cf,cg, dp,
//					output logic [7:0] an  
//					);


//	//display


//    	//debounce example instance:

//	seven_seg_controller my_7_seg_controller(
//		.clk_in(clk_100mhz),
//        .rst_in(sw[0]),
//        .val_in(val_display),
//        .cat_out(cat_out),
//    	.an_out(an)
//    );

//    logic [799:0] assignment_out;
//    logic done;


//    assignments_registry uut(   
//                    .clk_in(clk_100mhz),
//                    .confirm_in(1),
//                    .reset_in(0),
//                    .row_number_in(0),
//                    .col_number_in(0),
//                    .address_in(0),
//                   .assignment_out(assignment_out),
//                   .done(done)

//    ); 

//	assign {cg,cf,ce,cd,cc,cb,ca} = cat_out;
	
   


//	assign val_display = assignment_out[31:0];
	
	
    
//endmodule

//`default_nettype wire

