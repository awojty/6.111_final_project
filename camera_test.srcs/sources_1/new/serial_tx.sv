`default_nettype none

module serial_tx(   input wire      clk_in,
                    input wire      rst_in,
                    input wire      trigger_in,
                    input wire [7:0]     val_in,
                    output logic    data_out);
    parameter   DIVISOR = 868; //treat this like a constant!!
    
    logic [9:0]         shift_buffer; //10 bits...interesting
    logic [31:0]        count;
    logic [31:0]        counter;
    logic [3:0] index;
    
    //assign shift_buffer = {1, val_in[7], val_in[6], val_in[5], val_in[4],val_in[3], val_in[2],val_in[1],val_in[0], 0};
    
    logic done;
    always_ff @(posedge clk_in)begin
        if(rst_in) begin
            counter<=0;
            index<=0;
            done <=0;
            
            shift_buffer <= 0;

        end else if (trigger_in) begin
            shift_buffer <= {1'b1, val_in, 1'b0};
//            counter<=counter+1;
            done <=0;
            
            

        end else if (done!=1) begin
            if (index == 10) begin
                done <=1;
                counter<=0;
                index<=0;
             end else begin
                if (counter == DIVISOR-1)begin
                    data_out <= shift_buffer[index];
                    index <= index+1;// if index == 9 > done =1
                    counter<=0;
                end else begin
                    counter<=counter+1;
                end
            end
        end
    end  
                
endmodule
`default_nettype wire