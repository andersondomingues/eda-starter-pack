// device: xc7a100tcsg324-1
module top_nexys_a7 #()(
    input clock,         // clock, from board
    input reset,         // button n17 (middle)
    input logic ssl,     // shift op left, button m18 (top)
    input logic ssr,     // shift op right, button p18 (bottom)

    input logic[15:0] SW,    // switches, use to enter value to shift
    output logic[15:0] LED,  // leds, actual shifting result

    output logic[7:0] DDP,  // displays values from switches
    output logic[7:0] AN    //  
);

logic io, op;
logic[5:0] d1, d2, d3, d4, d5, d6, d7, d8;

// instanciação de um shifter de 16 bits
bshifter16 shifter_a(
    .clock(clock), .reset(~reset),
    .val(SW), 
    .ssl(op), 
    .i(io), 
    .res(LED), 
    .o(io)
);

dspl_drv_NexysA7 display(
  .clock(clock), .reset(reset),
  .d1(d1), .d2(d2), .d3(d3), .d4(d4), 
  .d5(d5), .d6(d6), .d7(d7), .d8(d8),
  .an(AN), .dec_ddp(DDP)
);

// processo que atualiza o display
always @(posedge clock, negedge reset) begin
  if (reset == 0) begin
    // 1 - 1111 - 1 
    // en - val - dot
    d1 <= {1'b1, SW[3], SW[2], SW[1], SW[0], 1'b1};
    d2 <= {1'b1, SW[7], SW[6], SW[5], SW[4], 1'b1};    
    d3 <= {1'b1, SW[11], SW[10], SW[9], SW[8], 1'b1};    
    d4 <= {1'b1, SW[15], SW[14], SW[13], SW[12], 1'b1};
    d5 <= 0;
    d6 <= 0;
    d7 <= 0;
    d8 <= 0;
  end else begin
    d1 <= 0;
    d2 <= 0;
    d3 <= 0;
    d4 <= 0;
    d5 <= 0;
    d6 <= 0;
    d7 <= 0;
    d8 <= 0;    
  end
end

// processo mostra nos leds o resultado do shifting 
always_comb begin
    if(ssr) op = 0;
    if(ssl) op = 1;
end
 
endmodule