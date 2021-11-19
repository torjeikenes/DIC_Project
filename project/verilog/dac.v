`timescale 1 ns / 1 ps

module DAC
    (
        input wire         clk,
        inout wire         anaRamp,
        inout wire         anaBias1,
        input wire         expose,
        input wire         convert
    );


   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = expose ? clk : 0;

endmodule //DAC
