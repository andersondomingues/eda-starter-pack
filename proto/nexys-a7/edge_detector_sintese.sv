module edge_detector_s
(
  input clock, reset, din,
  output reg rising
);

  reg [16:0] contador;
  reg [1:0] EA;

  always @(posedge clock or posedge reset)
  begin
    if (reset == 1'b1) begin
	  EA <= 2'd0;
      rising <= 1'b0;
	  contador <= 17'd0;
    end
    else begin
      case (EA)
        2'd0 : begin
          if (din == 1'b1) begin
            contador <= 17'd0;
			EA <= 2'd1;
			rising <= 1'b1;
          end
        end
        2'd1 : begin
	      EA <= 2'd2;
	      rising <= 1'b0;
        end	
        default : begin
          if (din == 1'b0 && contador > 130000) begin // tempo de 2,6 ms para filtrar ruido
            EA <= 2'd0;
		  end
		  else begin
		    contador <= contador + 1;
          end
        end
      endcase
    end
  end

endmodule