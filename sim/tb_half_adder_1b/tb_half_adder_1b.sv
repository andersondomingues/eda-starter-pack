`timescale 1ns/1ps

module tb_half_adder_1b #();

  logic a;
  logic b;
  logic sum;
  logic carry;

  half_adder_1b hadder(
    .a(a),
    .b(b),
    .sum(sum),
    .carry(carry)
  );

  initial begin  
    a = 0;
    b = 0;
    #2
    $display("a=0, b=0, sum=%d, carry=%d", sum, carry);
    a = 0;
    b = 1;
    #2
    $display("a=0, b=0, sum=%d, carry=%d", sum, carry);
    a = 1;
    b = 0;
    #2
    $display("a=0, b=0, sum=%d, carry=%d", sum, carry);
    a = 1;
    b = 1;
    #2
    $display("a=0, b=0, sum=%d, carry=%d", sum, carry);
  end
  
endmodule: tb_half_adder_1b