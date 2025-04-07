`timescale 1ns/1ps

module tb_mux2x1 #();

  logic a = 0;
  logic b = 0;
  logic sel = 0;
  
  logic out;
  logic clk = 0;
  logic rst = 0;

  mux2x1 mux_a(
    .a(a), 
    .b(b), 
    .sel(sel),
    .out(out),
    .clock(clk),
    .reset(rst)
  );

  initial begin
    #2 rst = 1;
  end

  always #1 clk = ~clk;
  always #2 a = ~a;
  always #4 b = ~b;
  always #8 sel = ~sel;

  property prop1;
    @(posedge clk) 
      disable iff (rst)  
      sel |-> ##1 (out == $past(a));
  endproperty

  property prop2;
    @(posedge clk) 
      disable iff (rst) 
      sel == 0 |-> ##1 (out == $past(b));
  endproperty

  always @(posedge clk) begin
    assert property(prop1);
    assert property(prop2);
  end
  
endmodule: tb_mux2x1