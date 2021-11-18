`timescale 1 ns / 1 ps

module GRAY2BIN #(
      parameter DATA_WIDTH = 8
   ) (
      input  [DATA_WIDTH-1:0] gray,
      output [DATA_WIDTH-1:0] bin
   );

   // gen vars
   genvar i;

   generate
      for (i=0; i<DATA_WIDTH; i=i+1)
      begin
         assign bin[i] = ^ gray[DATA_WIDTH-1:i];
      end
   endgenerate
endmodule //gray2bin
