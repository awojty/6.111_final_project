`default_nettype none
//implmentation for at most 6 breaks sorry hardcoded
module get_permutations(   
                    input wire clk_in,
                    input wire reset_in,
                    input wire start_in,
                    input wire [2:0] number_of_breaks_in,//at most 4 breaks
                    input wire [2:0] space_to_fill_in, // at most 5 space left
//most signifcant bits encode numebrs
                    output logic [11:0] permutation_out, //  mak of 4 breaks, eahc max encoded by 3 bits 4*3 ==12
                    output logic done,
                    output logic [5:0] total_counter //returns the tola nbumber of optison returend for a given setging


    );  

    //assume that if ther eis one break (2 numbers in the row) or a single sumber (no breaks) - it will be handled by the solver

//5 is the max amount of space to fill (4 bits)


logic [5:0] counter;
logic counting;

logic  [2:0] number_of_breaks;//at most 4 breaks
logic [2:0] space_to_fill; // at most 5 space left

    always_ff @(posedge clk_in) begin

        if (reset_in) begin
            done <=0;
            counter <=0;
            counting <=0;
            
            total_counter <=0;
            permutation_out<=0;
            number_of_breaks<=0;
            space_to_fill<=0;

        end else if (start_in && ~counting) begin
        
            counting <=1;
            done<=0;
            number_of_breaks<=number_of_breaks_in;
            space_to_fill<=space_to_fill_in; 
        
        end else if (counting) begin
            counter<=counter +1;

            if(number_of_breaks == 1) begin

                if(space_to_fill ==0) begin
                    counter<=counter +1;


                    case(counter)
                        6'b0: permutation_out<=12'b0000_0000_0000;
                        default: permutation_out<= 12'b000_000000000;
                    endcase

                    if(counter ==0) begin
                        counting <=0;
                        total_counter <=total_counter + 1;
                        done<=1;
                    end

                end else if (space_to_fill ==1) begin
                counter<=counter +1;

                    case(counter)
                        4'b0: permutation_out <= 12'b00000000_0001;
                        default: permutation_out<= 12'b000000000000;
                    
                    endcase

                    if(counter ==0) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 1;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==2) begin
                counter<=counter +1;
                    case(counter)
                        4'b0: permutation_out<= 12'b00000000_0010;
                        default: permutation_out<= 12'b000000000000;
                    
                    endcase

                    if(counter ==0) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 1;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==3) begin
                    case(counter)
                        4'b0: permutation_out<= 12'b00000000_0011;
                        default: permutation_out<= 12'b000000000000;
                    
                    endcase

                    if(counter ==0) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 1;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==4) begin
                counter<=counter +1;

                    case(counter)
                        4'b0: permutation_out<= 12'b00000000_0100;
                        default: permutation_out<= 12'b000000000000;
                    
                    endcase

                    if(counter ==0) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 1;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==5) begin

                    case(counter)
                        4'b0: permutation_out<= 12'b00000000_0101;
                        default: permutation_out<= 12'b000000000000;
                    
                    endcase

                    if(counter ==0) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 1;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==6) begin

                    case(counter)
                        16'b0: permutation_out<=12'b00000000_0110;
                        default: permutation_out<=12'b000000000000;
                    endcase

                    if(counter ==0) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 1;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==7) begin

                    case(counter)
                        4'b0: permutation_out<=12'b00000000_0111;
                        default: permutation_out<=12'b000000000000;
                    
                    endcase

                    if(counter ==0) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 1;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==8) begin

                    case(counter)
                        4'b0: permutation_out<=12'b00000000_1000;
                        default: permutation_out<=12'b000000000000;
                    
                    endcase

                    if(counter ==0) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 1;
                        space_to_fill <=space_to_fill - 1;
                    end
                end

            

            end else if(number_of_breaks == 2) begin

                if(space_to_fill ==0) begin

                    case(counter)
                        4'b0: permutation_out<=12'b000000000000;
                        default: permutation_out<=12'b000000000000;
                    
                    endcase

                    if(counter ==0) begin
                        counting <=0;
                        done<=1;
                        total_counter <=total_counter + 1;
                    end

                end else if (space_to_fill ==1) begin

                    case(counter)
                        6'b0: permutation_out<=12'b000000_000_001; // each break is encoded by 3 bits
                        6'b1: permutation_out<=12'b000000_001_000;
                        default: permutation_out<=12'b000000000000;
                    
                    endcase

                    if(counter ==1) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 2;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==2) begin

                    case(counter)
                        6'b0: permutation_out<=12'b000_000_001_001; // 11
                        6'd1: permutation_out<=12'b000_000_000_010; //02
                        6'd2: permutation_out<=12'b000_000_010_000; //20
                        default: permutation_out<=12'b000000000000;
                    
                    endcase

                    if(counter ==2) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 3;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==3) begin

                    case(counter)
                        6'b0: permutation_out<=12'b000_000_001_010; // 12
                        6'd1: permutation_out<=12'b000_000_010_001; //21
                        6'd2: permutation_out<=12'b000_000_000_011; //03
                        6'd3: permutation_out<=12'b000_000_011_000; //30
                        default: permutation_out<=12'b000000000000;
                    
                    endcase

                    if(counter ==3) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 4;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==4) begin

                    case(counter)
                        6'b0: permutation_out<=12'b000_000_010_010; // 22
                        6'd1: permutation_out<=12'b000_000_011_001; //31
                        6'd2: permutation_out<=12'b000_000_011_001; //13
                        6'd3: permutation_out<=12'b000_000_100_000; //40
                        6'd4: permutation_out<=12'b000_000_000_100; //04
                        default: permutation_out<=12'b000000000000;
                    
                    endcase

                    if(counter ==4) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 5;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==5) begin

                    case(counter)
                        6'b0: permutation_out<=12'b000_000_101_000; // 50
                        6'd1: permutation_out<=12'b000_000_000_101; //05
                        6'd2: permutation_out<=12'b000_000_100_001; //41
                        6'd3: permutation_out<=12'b000_000_001_100; //14
                        6'd4: permutation_out<=12'b000_000_011_010; //32
                        6'd5: permutation_out<=12'b000_000_010_011; //23
                        default: permutation_out<=12'b000000000000;
                    endcase

                    if(counter ==5) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 6;
                        space_to_fill <=space_to_fill - 1;
                    end

            end
         
        
        end else if (number_of_breaks == 3) begin

            if(space_to_fill ==0) begin

                case(counter)
                    4'b0: permutation_out<= 12'b000000000_000;
                    default: permutation_out<= 12'b000000000000;
                
                endcase

                if(counter ==0) begin
                    counting <=0;
                    total_counter <=total_counter + 1;
                    done<=1;
                end

            end else if (space_to_fill ==1) begin


                case(counter)
                    6'b0: permutation_out<=12'b000_000_000_001;
                    6'd1: permutation_out<=12'b000_000_001_000;
                    6'd2: permutation_out<=12'b000_001_000_000;
                    default: permutation_out<=12'b000000000000;
                endcase

                if(counter ==2) begin
                    counting <=0;
                    done<=1;
                    counter <=0;
                end

            end else if (space_to_fill ==2) begin

                case(counter)
                    6'b0: permutation_out<=12'b000_000_001_001;
                    6'd1: permutation_out<=12'b000_001_001_000;
                    6'd2: permutation_out<=12'b000_001_000_001;
                    6'd3: permutation_out<=12'b000_000_000_010;
                    6'd4: permutation_out<=12'b000_010_000_000;
                    6'd5: permutation_out<=12'b000_000_010_000;
                    default: permutation_out<=12'b000000000000;
                endcase

                if(counter ==5) begin
                    counting <=1;
                    counter<=0;
                    total_counter <=total_counter + 6;
                    space_to_fill <=space_to_fill - 1;
                end

            end else if (space_to_fill ==3) begin

                case(counter)
                    4'b0: permutation_out<=12'b000_001_001_001; //111
                    4'd1: permutation_out<=12'b000_000_000_011; //003
                    4'd2: permutation_out<=12'b000_000_011_000; //030
                    4'd3: permutation_out<=12'b000_011_000_000; //300
                    4'd4: permutation_out<=12'b000_000_010_001; //021
                    4'd5: permutation_out<=12'b000_001_010_000; //120
                    4'd6: permutation_out<=12'b000_000_001_010; //012
                    6'd7: permutation_out<=12'b000_010_001_000; //210
                    6'd8: permutation_out<=12'b000_010_000_001; //201
                    6'd9: permutation_out<=12'b000_001_000_010; //102
                    default: permutation_out<=12'b000000000000;
                endcase

                if(counter ==9) begin
                    counting <=1;
                    counter<=0;
                    total_counter <=total_counter + 10;
                    space_to_fill <=space_to_fill - 1;
                end


            end else if (space_to_fill ==4) begin

            
                case(counter)
                    4'b0: permutation_out<=12'b000_000_100_000; //004
                    4'd1: permutation_out<=12'b000_000_000_100; //040
                    4'd2: permutation_out<=12'b000_100_000_000; //400
                    4'd3: permutation_out<=12'b000_000_011_001; //031
                    4'd4: permutation_out<=12'b000_001_000_011; //103
                    4'd5: permutation_out<=12'b000_001_011_000; //130
                    4'd6: permutation_out<=12'b000_011_000_001; //301
                    4'd7: permutation_out<=12'b000_000_010_011; //013
                    4'd8: permutation_out<=12'b000_011_001_000; //310
                    4'd9: permutation_out<=12'b000_000_010_010; //022
                    4'd10: permutation_out<=12'b000_010_010_000; //220
                    default: permutation_out<=12'b000_000_000_000;
                endcase

                if(counter ==10) begin
                    counting <=1;
                    counter<=0;
                    total_counter <=total_counter + 11;
                    space_to_fill <=space_to_fill - 1;
                end



            end else if (space_to_fill ==5) begin

                case(counter)
                    4'b0: permutation_out<=12'b000_000_000_101; //005
                    4'd1: permutation_out<=12'b000_000_101_000; //050
                    4'd2: permutation_out<=12'b000_101_000_000; //500

                    4'd3: permutation_out<=12'b000_000_011_010; //032
                    4'd4: permutation_out<=12'b000_010_011_000; //230
                    4'd5: permutation_out<=12'b000_000_010_011; //023
                    4'd6: permutation_out<=12'b000_011_010_000; //320
                    4'd7: permutation_out<=12'b000_010_000_011; //203
                    4'd8: permutation_out<=12'b000_011_000_010; //302

                    4'd9: permutation_out<=12'b000_011_001_001; //311
                    4'd10: permutation_out<=12'b000_001_011_001; //131
                    4'd11: permutation_out<=12'b000_001_001_011; //113

                    6'd12: permutation_out<=12'b000_000_001_100; //014
                    6'd13: permutation_out<=12'b000_100_001_000; //410
                    6'd14: permutation_out<=12'b000_000_100_001; //041
                    6'd15: permutation_out<=12'b000_001_100_000; //140
                    6'd16: permutation_out<=12'b000_100_000_001; //401
                    6'd17: permutation_out<=12'b000_100_000_100; //104
                    default: permutation_out<=12'b000_000_000_000;
                endcase

                if(counter ==17) begin
                    counting <=1;
                    counter<=0;
                    total_counter <=total_counter + 18;
                    space_to_fill <=space_to_fill - 1;
                end
                
          end

            end else if (number_of_breaks == 4) begin


                if (space_to_fill ==0) begin

                
                    case(counter)
                        4'b0: permutation_out<=12'b000_000_000_000;
                        default: permutation_out<=12'b000000000000;
                    endcase

                    if(counter ==0) begin
                        counting <=0;
                        total_counter <=total_counter + 1;
                        done<=1;
                    end

                end else if (space_to_fill ==1) begin

                    case(counter)
                        6'b0: permutation_out<=12'b000_000_000_001;
                        6'd1: permutation_out<=12'b000_000_001_000;
                        6'd2: permutation_out<=12'b000_001_000_000;
                        6'd3: permutation_out<=12'b001_000_000_000;
                        default: permutation_out<=12'b000000000000;
                    endcase

                    if(counter ==3) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 4;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==2) begin

                    case(counter)
                        4'b0: permutation_out<=12'b000_000_001_001; //0011
                        4'd1: permutation_out<=12'b000_001_001_000; //0110
                        4'd2: permutation_out<=12'b001_001_000_000; //1100
                        4'd3: permutation_out<=12'b000_001_000_001; //0101
                        4'd4: permutation_out<=12'b001_000_001_000; //1010
                        4'd5: permutation_out<=12'b001_000_000_001; //1001
                        4'd6: permutation_out<=12'b000_000_000_010; //0002
                        4'd7: permutation_out<=12'b000_000_010_000; //0020
                        4'd8: permutation_out<=12'b000_010_000_000; //0200
                        4'd9: permutation_out<=12'b010_000_000_000; //2000
                        default: permutation_out<=12'b000000000000;
                    endcase

                    if(counter ==9) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 10;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==3) begin

                    case(counter)
                        4'b0: permutation_out<=12'b000_000_001_010; //0012
                        4'd1: permutation_out<=12'b000_001_010_000; //0120
                        4'd2: permutation_out<=12'b001_010_000_000; //1200
                        4'd3: permutation_out<=12'b000_001_000_010; //0102
                        4'd4: permutation_out<=12'b001_000_010_000; //1020
                        4'd5: permutation_out<=12'b001_000_000_010; //1002
                        4'd6: permutation_out<=12'b000_000_010_001; //0021
                        4'd7: permutation_out<=12'b000_010_001_000; //0210
                        4'd8: permutation_out<=12'b010_001_000_000; //2100
                        4'd9: permutation_out<=12'b000_010_000_001; //0201
                        4'd10: permutation_out<=12'b010_000_001_000; //2010
                        4'd11: permutation_out<=12'b010_000_000_001; //2001


                        4'd12: permutation_out<=12'b000_000_000_011; //0003
                        4'd13: permutation_out<=12'b000_000_011_000; //0030
                        4'd14: permutation_out<=12'b000_011_000_000; //0300
                        4'd15: permutation_out<=12'b011_000_000_000; //3000

                        6'd16: permutation_out<=12'b000_001_001_001; //0111
                        6'd17: permutation_out<=12'b001_001_001_000; //1110
                        6'd18: permutation_out<=12'b001_001_000_001; //1101
                        6'd19: permutation_out<=12'b001_000_001_001; //1011
                        default: permutation_out<=12'b000000000000;
                    endcase

                    if(counter ==19) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 20;
                        space_to_fill <=space_to_fill - 1;
                    end

                end else if (space_to_fill ==4) begin
                    case(counter)
                        4'b0: permutation_out<=12'b000_000_000_100; //0004
                        4'd1: permutation_out<=12'b000_000_100_000; //0040
                        4'd2: permutation_out<=12'b000_100_000_000; //0400
                        4'd3: permutation_out<=12'b100_000_000_000; //4000
                        4'd4: permutation_out<=12'b000_000_011_001; //0031
                        4'd5: permutation_out<=12'b000_011_001_000; //0310
                        4'd6: permutation_out<=12'b011_001_000_000; //3100
                        4'd7: permutation_out<=12'b000_000_001_011; //0013
                        4'd8: permutation_out<=12'b000_001_011_000; //0130
                        4'd9: permutation_out<=12'b001_011_000_000; //1300
                        4'd10: permutation_out<=12'b000_011_000_001; //0301
                        4'd11: permutation_out<=12'b011_000_001_000; //3010
                        4'd11: permutation_out<=12'b000_001_000_011; //0103
                        4'd12: permutation_out<=12'b001_000_011_000; //1030
                        4'd13: permutation_out<=12'b011_000_000_001; //3001
                        4'd14: permutation_out<=12'b001_000_000_011; //1003
                        4'd15: permutation_out<=12'b000_000_010_010; //0022
                        6'd16: permutation_out<=12'b000_010_000_010; //0202
                        6'd17: permutation_out<=12'b001_001_001_000; //2002
                        6'd18: permutation_out<=12'b001_001_000_001; //2020
                        6'd19: permutation_out<=12'b001_000_001_001; //2200
                        6'd20: permutation_out<=12'b000_001_001_001; //1111

                        6'd21: permutation_out<=12'b001_001_001_000; //0112
                        6'd22: permutation_out<=12'b001_001_000_001; //1120
                        6'd23: permutation_out<=12'b001_001_000_001; //1102
                        6'd24: permutation_out<=12'b001_001_000_001; //1012

                        6'd25: permutation_out<=12'b001_000_001_001; //0121
                        6'd26: permutation_out<=12'b000_001_001_001; //1210
                        6'd27: permutation_out<=12'b001_000_001_001; //1021
                        6'd28: permutation_out<=12'b000_001_001_001; //1201


                        6'd29: permutation_out<=12'b001_001_001_000; //0211
                        6'd30: permutation_out<=12'b001_001_000_001; //2101
                        6'd31: permutation_out<=12'b001_001_001_000; //0211
                        6'd32: permutation_out<=12'b001_001_000_001; //2011

                        default: permutation_out<=12'b000000000000;
                    endcase

                    if(counter ==31) begin
                        counting <=1;
                        counter<=0;
                        total_counter <=total_counter + 32;
                        space_to_fill <=space_to_fill - 1;
                    end


                end else if (space_to_fill ==5) begin
            
                //TODO
            
                    space_to_fill <=space_to_fill - 1;
                    counting <=1;
                    counter<=0;

                end //sapce to fill
            end //n of breaks
        end // if coutnign
    end // always_ff

endmodule
`default_nettype wire

