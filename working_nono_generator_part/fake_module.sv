module fake_module(
    
    input wire clk_in,
    input wire reset_in,
    input wire sth,
    output logic on,
    output logic [11:0] pixel_out,
    output logic done
    );


    logic [31:0] counter;
    logic started;


    always_ff @(posedge clk_in) begin

        if (reset_in) begin
            counter <=0;
            started <=0;
            done<=0;
            

        end else begin 
            if(sth || started) begin
                counter <= counter +1;
                pixel_out <= 12'b0;
                started <=1;
                done<=0;
            end

            if(counter ==50000) begin
                on <=1;
                pixel_out <= 12'b111111111;
                done <=1;
                counter <=0;
                started <=0;
            end

        end
        

    end
endmodule