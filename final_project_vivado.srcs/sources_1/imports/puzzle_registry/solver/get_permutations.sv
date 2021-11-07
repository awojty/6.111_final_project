`default_nettype none

//implmentation for at most 6 breaks sorry hardcoded
module get_permutations(   
                    input wire clk_in,
                    input wire start_in,
                   
                    input wire [2:0] number_of_breaks,//at most 4 breaks
                    input wire [2:0] space_to_fill_left, // at most 5 space left
//most signifcant bits encode numebrs
                    output logic [11:0] breaks, //  mak of 4 breaks, eahc max encoded by 3 bits 4*3 ==12
                    output logic done,
                    output logic count //returns the tola nbumber of optison returend for a given setging


    );  

    //assume that if ther eis one break (2 numbers in the row) or a single sumber (no breaks) - it will be handled by the solver



always_ff @(posedge clk_in) begin

    if (rst_in) begin
        done <=0;
        break_1<=0;
        break_2<=0;
        break_3<=0;
        break_4<=0;
        break_5<=0;
        break_6<=0;
        counter <=0;
        counter<=0;

10101

//5 is the max amount of space to fill (4 bits)

    end else if (start_in) begin
        
        counting <=1;
        done<=0;
        
    end else if (counting) begin

        if(number_of_breaks == 2) begin

            if(space_to_fill ==0) begin

                case(counter)
                    4'b0: 12'b000000000000;
                    default: 12'b000000000000
                
                endcase

                if(counter ==0) begin
                    counting <=0;
                    done<=1;
                end

            end else if (space_to_fill ==1) begin

                case(counter)
                    4'b0: 12'b000000000001; // each break is encoded by 3 bits
                    4'b1: 12'b000000001000;
                    default: 12'b000000000000
                
                endcase

                if(counter ==1) begin
                    counting <=0;
                    done<=1;
                end

            else if (space_to_fill ==2) begin

                case(counter)
                    4'b0: 12'b000_000_001_001; // 11
                    4'd1: 12'b000_000_000_010; //02
                    4'd2: 12'b000_000_010_000; //20
                    default: 12'b000000000000
                
                endcase

                if(counter ==2) begin
                    counting <=0;
                    done<=1;
                end

            else if (space_to_fill ==3) begin

                case(counter)
                    4'b0: 12'b000_000_001_010; // 12
                    4'd1: 12'b000_000_010_001; //21
                    4'd2: 12'b000_000_000_011; //03
                    4'd3: 12'b000_000_011_000; //30
                    default: 12'b000000000000
                
                endcase

                if(counter ==3) begin
                    counting <=0;
                    done<=1;
                end

            else if (space_to_fill ==4) begin

                case(counter)
                    4'b0: 12'b000_000_010_010; // 22
                    4'd1: 12'b000_000_011_001; //31
                    4'd2: 12'b000_000_011_001; //13
                    4'd3: 12'b000_000_100_000; //40
                    4'd4: 12'b000_000_000_100; //04
                    default: 12'b000000000000
                
                endcase

                if(counter ==4) begin
                    counting <=0;
                    done<=1;
                end

            end else if (space_to_fill ==5) begin

                case(counter)
                    4'b0: 12'b000_000_101_000; // 50
                    4'd1: 12'b000_000_000_101; //05
                    4'd2: 12'b000_000_100_001; //41
                    4'd3: 12'b000_000_001_100; //14
                    4'd4: 12'b000_000_011_010; //32
                    4'd5: 12'b000_000_010_011; //23
                    default: 12'b000000000000
                
                endcase

                if(counter ==5) begin
                    counting <=0;
                    done<=1;
                end

            end
        counter +=1

        end else if (number_of_breaks == 3) begin

            if(space_to_fill ==0) begin

                case(counter)
                    4'b0: 12'b000000000000;
                    default: 12'b000000000000
                
                endcase

                if(counter ==0) begin
                    counting <=0;
                    done<=1;
                end

            end else if (space_to_fill ==1) begin

                case(counter)
                    4'b0: 12'b000_000_000_001;
                    4'd1: 12'b000_000_001_000;
                    4'd2: 12'b000_001_000_000;
                    default: 12'b000000000000
                endcase

                if(counter ==2) begin
                    counting <=0;
                    done<=1;
                end

            end else if (space_to_fill ==2) begin

                case(counter)
                    4'b0: 12'b000_000_001_001;
                    4'd1: 12'b000_001_001_000;
                    4'd2: 12'b000_001_000_001;
                    4'd3: 12'b000_000_000_010;
                    4'd4: 12'b000_010_000_000;
                    4'd5: 12'b000_000_010_000;
                    default: 12'b000000000000
                endcase

                if(counter ==5) begin
                    counting <=0;
                    done<=1;
                end

            end else if (space_to_fill ==3) begin

                case(counter)
                    4'b0: 12'b000_001_001_001; //111
                    4'd1: 12'b000_000_000_011; //003
                    4'd2: 12'b000_000_011_000; //030
                    4'd3: 12'b000_011_000_000; //300
                    4'd4: 12'b000_000_010_001; //021
                    4'd5: 12'b000_001_010_000; //120
                    4'd6: 12'b000_000_001_010; //012
                    4'd7: 12'b000_010_001_000; //210
                    4'd8: 12'b000_010_000_001; //201
                    4'd9: 12'b000_001_000_010; //102
                    default: 12'b000000000000
                endcase

                if(counter ==9) begin
                    counting <=0;
                    done<=1;
                end


            end else if (space_to_fill ==4) begin

            
                case(counter)
                    4'b0: 12'b000_000_100_000; //004
                    4'd1: 12'b000_000_000_100; //040
                    4'd2: 12'b000_100_000_000; //400
                    4'd3: 12'b000_000_011_001; //031
                    4'd4: 12'b000_001_000_011; //103
                    4'd5: 12'b000_001_011_000; //130
                    4'd6: 12'b000_011_000_001; //301
                    4'd7: 12'b000_000_010_011; //013
                    4'd8: 12'b000_011_001_000; //310
                    4'd9: 12'b000_000_010_010; //022
                    4'd10: 12'b000_010_010_000; //220
                    default: 12'b000_000_000_000
                endcase

                if(counter ==10) begin
                    counting <=0;
                    done<=1;
                end



            end else if (space_to_fill ==5) begin

                case(counter)
                    4'b0: 12'b000_000_000_101; //005
                    4'd1: 12'b000_000_101_000; //050
                    4'd2: 12'b000_101_000_000; //500

                    4'd3: 12'b000_000_011_010; //032
                    4'd4: 12'b000_010_011_000; //230
                    4'd5: 12'b000_000_010_011; //023
                    4'd6: 12'b000_011_010_000; //320
                    4'd7: 12'b000_010_000_011; //203
                    4'd8: 12'b000_011_000_010; //302

                    4'd9: 12'b000_011_001_001; //311
                    4'd10: 12'b000_001_011_001; //131
                    4'd11: 12'b000_001_001_011; //113

                    4'd12: 12'b000_000_001_100; //014
                    4'd13: 12'b000_100_001_000; //410
                    4'd14: 12'b000_000_100_001; //041
                    4'd15: 12'b000_001_100_000; //140
                    4'd16: 12'b000_100_000_001; //401
                    4'd17: 12'b000_100_000_100; //104
                    default: 12'b000_000_000_000
                endcase

                if(counter ==17) begin
                    counting <=0;
                    done<=1;
                end





            
        end else if (number_of_breaks == 4) begin


            if (space_to_fill ==0) begin

            
                case(counter)
                    4'b0: 12'b000_000_000_000;
                    default: 12'b000000000000
                endcase

                if(counter ==0) begin
                    counting <=0;
                    done<=1;
                end

            end else if (space_to_fill ==1) begin

                case(counter)
                    4'b0: 12'b000_000_000_001;
                    4'd1: 12'b000_000_001_000;
                    4'd2: 12'b000_001_000_000;
                    4'd3: 12'b001_000_000_000;
                    default: 12'b000000000000
                endcase

                if(counter ==3) begin
                    counting <=0;
                    done<=1;
                end

            end else if (space_to_fill ==2) begin

                case(counter)
                    4'b0: 12'b000_000_001_001; //0011
                    4'd1: 12'b000_001_001_000; //0110
                    4'd2: 12'b001_001_000_000; //1100
                    4'd3: 12'b000_001_000_001; //0101
                    4'd4: 12'b001_000_001_000; //1010
                    4'd5: 12'b001_000_000_001; //1001
                    4'd6: 12'b000_000_000_010; //0002
                    4'd7: 12'b000_000_010_000; //0020
                    4'd8: 12'b000_010_000_000; //0200
                    4'd9: 12'b010_000_000_000; //2000
                    default: 12'b000000000000
                endcase

                if(counter ==9) begin
                    counting <=0;
                    done<=1;
                end

            end else if (space_to_fill ==3) begin

                case(counter)
                    4'b0: 12'b000_000_001_010; //0012
                    4'd1: 12'b000_001_010_000; //0120
                    4'd2: 12'b001_010_000_000; //1200
                    4'd3: 12'b000_001_000_010; //0102
                    4'd4: 12'b001_000_010_000; //1020
                    4'd5: 12'b001_000_000_010; //1002
                    4'd6: 12'b000_000_010_001; //0021
                    4'd7: 12'b000_010_001_000; //0210
                    4'd8: 12'b010_001_000_000; //2100
                    4'd9: 12'b000_010_000_001; //0201
                    4'd10: 12'b010_000_001_000; //2010
                    4'd11: 12'b010_000_000_001; //2001


                    4'd12: 12'b000_000_000_011; //0003
                    4'd13: 12'b000_000_011_000; //0030
                    4'd14: 12'b000_011_000_000; //0300
                    4'd15: 12'b011_000_000_000; //3000

                    4'd16: 12'b000_001_001_001; //0111
                    4'd17: 12'b001_001_001_000; //1110
                    4'd18: 12'b001_001_000_001; //1101
                    4'd19: 12'b001_000_001_001; //1011
                    default: 12'b000000000000
                endcase

                if(counter ==19) begin
                    counting <=0;
                    done<=1;
                end

            end else if (space_to_fill ==4) begin
            end else if (space_to_fill ==5) begin


    end
end

endmodule
101010101

`default_nettype wire

