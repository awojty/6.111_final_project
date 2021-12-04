//module camera_read(
//	input  p_clock_in,
//	input  vsync_in,
//	input  href_in,
//	input wire button_press,
//	input  [7:0] p_data_in,
//	output logic [15:0] pixel_data_out,
//	output logic pixel_valid_out,
//	output logic frame_done_out
//    );
	 
	
//	logic [1:0] FSM_state = 0;
//    logic pixel_half = 0;
	
//	localparam WAIT_BUTTON_PRESS = 2'b00;
//	localparam WAIT_FRAME_START = 2'b10;
//	localparam ROW_CAPTURE = 2'b01;
	
	
//	always_ff@(posedge p_clock_in) begin 
//		case(FSM_state)

//			WAIT_BUTTON_PRESS: begin //wait for VSYNC
//				FSM_state <= (button_press) ? WAIT_FRAME_START : WAIT_BUTTON_PRESS;
//				frame_done_out <= 0;
//				pixel_half <= 0;
//				pixel_valid_out <=0;
//			end
		
//			WAIT_FRAME_START: begin //wait for VSYNC
//				FSM_state <= (!vsync_in) ? ROW_CAPTURE : WAIT_FRAME_START;
//				frame_done_out <= 0;
//				pixel_half <= 0;
//			end
	
//			ROW_CAPTURE: begin 
//			FSM_state <= vsync_in ? WAIT_BUTTON_PRESS : ROW_CAPTURE;
//			frame_done_out <= vsync_in ? 1 : 0;
//			pixel_valid_out <= (href_in && pixel_half) ? 1 : 0; 
//			if (href_in) begin
//				pixel_half <= ~ pixel_half;
//				if (pixel_half) pixel_data_out[7:0] <= p_data_in;
//				else pixel_data_out[15:8] <= p_data_in;
//			end

//			end
//		endcase
//	end
	
//endmodule