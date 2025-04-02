module edge_detector
(
  input clock, reset, din,
  output rising
);

  reg din_reg;

  assign rising = (din_reg == 1'b0 && din == 1'b1) ? 1'b1 : 1'b0;

  always @(posedge clock or posedge reset)
  begin
    if (reset == 1'b1) begin
      din_reg <= 1'b0;
    end
    else begin
      din_reg <= din;
    end
  end

endmodule