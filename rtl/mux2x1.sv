module mux2x1 #()(
  input logic a,
  input logic b,
  input logic sel,

  output logic out
);

assign out = (sel) ? a : b;

endmodule: mux2x1