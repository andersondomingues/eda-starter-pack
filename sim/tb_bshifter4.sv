`timescale 1ns/1ps

module tb_bshifter4 #();

  reg[3:0] val;
  reg ssl;
  reg i;
  reg o; 
  reg[3:0] res;

  // instancia um novo shifter de 4 bits
  bshifter4 shifter_a(
    .val(val), 
    .ssl(ssl),
    .i(i),
    .o(o),     
    .res(res)
  );

  initial begin    
    val = 'b1110;    // entrada no shifter em 1110
    ssl = 'b1;       // configura shift para direita
    i = 'b0;         // insere um zero pela esquerda
    #1               // aguarda uma unidade de tempo (1ps)

    // confere se as seguintes propriedades:
    // (A) foi realizado um shift_1 para direita
    // (B) o bit eliminado pela direita é 'b0
    assert property(@(res) val == res >> 1);
    assert property(@(res) o == 'b0);

    val = res;  // utiliza o resultado anterior como nova entrada
    #1          // aguarda uma unidade de tempo

    // confere novamente as propriedades
    // desta vez, o bit eliminado deve ser 'b1
    assert property(@(res) val == res >> 1);
    assert property(@(res) o == 'b1);

    val = res;  // utiliza o resultado anterior como nova entrada, novamente
    #1          // aguarda uma unidade de tempo

    // confere novamente as propriedades
    // o bit eliminado conitinua a ser 'b1
    assert property(@(res) val == res >> 1);
    assert property(@(res) o == 'b1);

    val = res;  // repete o processo uma última vez 
    #1          // aguarda uma unidade de tempo

    // confere novamente as propriedades
    // o bit eliminado, dessa vez, será 'b0
    assert property(@(res) val == res >> 1);
    assert property(@(res) o == 'b0);
  end
  
endmodule: tb_bshifter4