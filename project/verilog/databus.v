`timescale 1 ns / 1 ps

`include "gray2bin.v"

module DATABUS(
    input   wire        clk,
    input   wire        reset, 
    input   wire        read1, 
    input   wire        read2,
    input   wire[7:0]   pixData11, 
    input   wire[7:0]   pixData12, 
    input   wire[7:0]   pixData21, 
    input   wire[7:0]   pixData22, 
    output  logic[15:0] pixelDataOut1,
    output  logic[15:0] pixelDataOut2
);


   wire [7:0] binData11;
   wire [7:0] binData12;
   wire [7:0] binData21;
   wire [7:0] binData22;

   GRAY2BIN g2b1(pixData11,binData11);
   GRAY2BIN g2b2(pixData12,binData12);
   GRAY2BIN g2b3(pixData21,binData21);
   GRAY2BIN g2b4(pixData22,binData22);


   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         pixelDataOut1 = 0;
         pixelDataOut2 = 0;
      end
      else begin
        if(read1) begin
            pixelDataOut1 <= {binData11, binData12};
          end
          else if(read2) begin
            pixelDataOut2 = {binData21, binData22};
          end

      end
   end
endmodule

