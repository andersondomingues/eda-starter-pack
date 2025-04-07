module mux2x1 #()(

  input logic clock,
  input logic reset,

  input logic a,
  input logic b,
  input logic sel,

  output logic out
);

always @(posedge clock, negedge reset) begin
  if(~reset) begin
    out <= 1'b0;
  end else begin
    out <= (sel) ? a : b;
  end  
end

endmodule: mux2x1