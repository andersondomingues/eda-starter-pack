module bshifter4 #()(
  input  wire[3:0] val, 
  input  wire ssl,
  input  wire i,
  output wire[3:0] res,
  output wire o
);

mux2x1 mux_3(
  .a(i),
  .b(val[2]),
  .sel(ssl),
  .out(res[3])
);

mux2x1 mux_2(
  .a(val[3]),
  .b(val[1]),
  .sel(ssl),
  .out(res[2])
);

mux2x1 mux_1(
  .a(val[2]),
  .b(val[0]),
  .sel(ssl),
  .out(res[1])
);

mux2x1 mux_0(
  .a(val[1]),
  .b(i),
  .sel(ssl),
  .out(res[0])
);

assign o = (ssl) ? val[0] : val[3];

endmodule: bshifter4