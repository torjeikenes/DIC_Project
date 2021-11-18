`timescale 1 ns / 1 ps

   //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------
   //
   
module DAC_ADC
    (
        input logic         clk,
        inout logic         anaRamp,
        inout logic         anaBias1,
        input logic         anaReset,
        
        input logic         read1,
        input logic         read2,
        input logic[7:0]    data,

        inout logic[7:0]    pixData11,
        inout logic[7:0]    pixData12,
        inout logic[7:0]    pixData21,
        inout logic[7:0]    pixData22,

        input logic         expose,
        input logic         convert
    );


   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = expose ? clk : 0;

   // If we're not reading the pixData, then we should drive the bus
   assign pixData11 = read1 ? 8'bZ: data;
   assign pixData12 = read1 ? 8'bZ: data;
   assign pixData21 = read2 ? 8'bZ: data;
   assign pixData22 = read2 ? 8'bZ: data;


endmodule //DAC_ADC
