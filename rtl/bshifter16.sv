module bshifter16 #()(
  input  logic clock,
  input  logic reset,
  input  logic[15:0] val, 
  input  logic ssl,
  input  logic i,
  output logic[15:0] res,
  output logic o
);

logic[3:0] out;
logic[3:0] src;

bshifter4 shifter16_3(
  .clock(clock), .reset(reset),
  .val(val[15:12]),
  .ssl(ssl),
  .i(src[3]),
  .res(res[15:12]),
  .o(out[3])
);

bshifter4 shifter16_2(
  .clock(clock), .reset(reset),
  .val(val[11:8]),
  .ssl(ssl),
  .i(src[2]),
  .res(res[11:8]),
  .o(out[2])
);

bshifter4 shifter16_1(
  .clock(clock), .reset(reset),
  .val(val[7:4]),
  .ssl(ssl),
  .i(src[1]),
  .res(res[7:4]),
  .o(out[1])
);

bshifter4 shifter16_0(
  .clock(clock), .reset(reset),
  .val(val[3:0]),
  .ssl(ssl),
  .i(src[0]),
  .res(res[3:0]),
  .o(out[0])
);

// left shift sources
// i321 0321 0321 0321   0

// right shift sources
// 
assign src = (ssl) ? {out[2:0], i} : {i, out[3:1]};
assign o = (ssl) ? out[3] : out[0]; 

endmodule: bshifter16