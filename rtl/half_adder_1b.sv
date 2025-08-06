module half_adder_1b(
  input logic a,
  input logic b,
  output logic carry,
  output logic sum
);

assign carry = a & b;
assign sum = a ^ b;

endmodule 