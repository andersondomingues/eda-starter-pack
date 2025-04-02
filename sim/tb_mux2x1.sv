`timescale 1ns/1ps

module tb_mux2x1 #();

  reg a, b, sel;
  
  logic out;

  mux2x1 mux_a(
    .a(a), 
    .b(b), 
    .sel(sel),
    .out(out)
  );

  initial begin 
    int i, j, k;

    for (i = 0; i < 2; i = i+1) begin
      for (j = 0; j < 2; j = j+1) begin
        for (k = 0; k < 2; k = k+1) begin
          a = i;
          b = j; 
          sel = k;  
          #2    
          assert property(@(a, b, sel) out == (sel) ? a : b);
          $display(a, b, sel, out);
        end
      end
    end 
  end
  
endmodule: tb_mux2x1