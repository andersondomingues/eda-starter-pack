// device: xc7a100tcsg324-1
module top_nexys_a7 #()(
    input clock,
    input logic[15:0] SW,    // switches
    output logic[15:0] LED,  // leds
    input logic ssl,
    input logic ssr
);

reg io, op;

// instanciação de um shifter de 16 bits
bshifter16 shifter_a(
    .val(SW), 
    .ssl(op), 
    .i(io), 
    .res(LED), 
    .o(io)
);

// processo mostra nos leds o resultado do shifting 
always_comb begin
    if(ssr) op = 0;
    if(ssl) op = 1;
end
 
endmodule