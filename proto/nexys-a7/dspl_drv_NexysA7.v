module dspl_drv_NexysA7 
#(parameter HALF_MS_COUNT = 50000)
(
  input clock, reset,
  input [5:0] d1, d2, d3, d4, d5, d6, d7, d8,
  output reg [7:0] an, dec_ddp
);

  reg ck_1KHz;
  reg [2:0] dig_selection;
  reg [4:0] selected_dig;
  reg [31:0] count_50K;

  // 1KHz clock generation
  always @(posedge clock or posedge reset)
  begin
    if (reset == 1'b1) begin
      ck_1KHz   <= 1'b0;
      count_50K <= 32'd0;
    end
    else begin
      if (count_50K == HALF_MS_COUNT-1) begin
        ck_1KHz   <= ~ck_1KHz;
        count_50K <= 32'd0;
      end
      else begin
        count_50K <= count_50K + 1;
      end
    end
  end

  // 1KHz counter to select digit and register output
  always @(posedge ck_1KHz or posedge reset)
  begin
    if (reset == 1'b1) begin
      dig_selection <= 3'd0;
      selected_dig  <= 5'd0;
      an            <= 8'b11111111; // Disable all displays
    end
    else begin
      // a 3-bit binary counter
      if (dig_selection == 3'b111) begin
        dig_selection <= 3'd0;
      end
      else begin
        dig_selection <= dig_selection + 1;
      end
      
      case (dig_selection)
        3'd0 : begin
          selected_dig <= d1[4:0];
          an <= {7'b1111111, ~d1[5]};
        end
        3'd1 : begin
          selected_dig <= d2[4:0];
          an <= {6'b111111, ~d2[5], 1'b1};
        end
        3'd2 : begin
          selected_dig <= d3[4:0];
          an <= {5'b11111, ~d3[5], 2'b11};
        end
        3'd3 : begin
          selected_dig <= d4[4:0];
          an <= {4'b1111, ~d4[5], 3'b111};
        end
        3'd4 : begin
          selected_dig <= d5[4:0];
          an <= {3'b111, ~d5[5], 4'b1111};
        end
        3'd5 : begin
          selected_dig <= d6[4:0];
          an <= {2'b11, ~d6[5], 5'b11111};
        end
        3'd6 : begin
          selected_dig <= d7[4:0];
          an <= {1'b1, ~d7[5], 6'b111111};
        end
        default : begin
          selected_dig <= d8[4:0];
          an <= {~d8[5], 7'b1111111};
        end
      endcase
    end
  end

  // digit 4-to-hex decoder
  always @*
  begin
    case (selected_dig[4:1])
      4'h0 : dec_ddp[7:1] = 7'b0000001;
      4'h1 : dec_ddp[7:1] = 7'b1001111;
      4'h2 : dec_ddp[7:1] = 7'b0010010;
      4'h3 : dec_ddp[7:1] = 7'b0000110;
      4'h4 : dec_ddp[7:1] = 7'b1001100;
      4'h5 : dec_ddp[7:1] = 7'b0100100;
      4'h6 : dec_ddp[7:1] = 7'b0100000;
      4'h7 : dec_ddp[7:1] = 7'b0001111;
      4'h8 : dec_ddp[7:1] = 7'b0000000;
      4'h9 : dec_ddp[7:1] = 7'b0000100;
      4'hA : dec_ddp[7:1] = 7'b0001000;
      4'hB : dec_ddp[7:1] = 7'b1100000;
      4'hC : dec_ddp[7:1] = 7'b0110001;
      4'hD : dec_ddp[7:1] = 7'b1000010;
      4'hE : dec_ddp[7:1] = 7'b0110000;
      default : dec_ddp[7:1] = 7'b0111000;
    endcase
    dec_ddp[0] = selected_dig[0];
  end

endmodule
