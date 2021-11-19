`timescale 1 ns / 1 ps

`include "gray2bin.v"

module DATABUS(
    input   wire        read1, 
    input   wire        read2,
    input   wire        reset,
    input   wire[7:0]   pixData1, 
    input   wire[7:0]   pixData2, 
    output  logic[15:0] pixelDataOut
);


   wire [7:0] binData1;
   wire [7:0] binData2;

   GRAY2BIN g2b1(pixData1,binData1);
   GRAY2BIN g2b2(pixData2,binData2);


   always_comb  begin
      if(reset) begin
         pixelDataOut = 0;

      end
      else begin
          if(read1 || read2) begin
              pixelDataOut = {binData1, binData2};
          end
          else begin
              pixelDataOut = 0;
          end

      end
   end
endmodule

