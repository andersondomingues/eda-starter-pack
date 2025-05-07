module bshifter4 #()(
  input  logic clock,
  input  logic reset,
  input  logic[3:0] val, 
  input  logic ssl,
  input  logic i,
  output logic[3:0] res,
  output logic o
);

logic[3:0] tmp_res;

mux2x1 mux_3(
  .clock(clock), .reset(reset),
  .a(i),         .b(val[2]),
  .sel(ssl),     .out(tmp_res[3])
);

mux2x1 mux_2(
  .clock(clock), .reset(reset),
  .a(val[3]),    .b(val[1]),
  .sel(ssl),     .out(tmp_res[2])
);

mux2x1 mux_1(
  .clock(clock), .reset(reset),
  .a(val[2]),    .b(val[0]),
  .sel(ssl),     .out(tmp_res[1])
);

mux2x1 mux_0(
  .clock(clock), .reset(reset),
  .a(val[1]),    .b(i),
  .sel(ssl),     .out(tmp_res[0])
);

always @(posedge clock, negedge reset) begin
  if (~reset) begin
    res <= 4'b0;
    o <= 1'b0;
  end else begin
    if (ssl) begin
      res[3:0] <= {tmp_res[2:0], i};
      o <= val[3];
    end else begin
      res[3:0] <= {i, tmp_res[3:1]};
      o <= tmp_res[0];
    end
  end 
end

endmodule: bshifter4