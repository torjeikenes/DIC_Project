`timescale 1 ns / 1 ps

module pixelTop_tb;
   logic clk =0;
   logic reset =0;
   parameter integer clk_period = 500;
   parameter integer sim_end = clk_period*2400;
   always #clk_period clk=~clk;

   PIXEL_TOP pixeltop(.clk(clk), .reset(reset));

   initial
     begin
        reset = 1;

        #clk_period  reset=0;

        $dumpfile("pixelTop_tb.vcd");
        $dumpvars(0,pixelTop_tb);

        #sim_end
          $stop;
     end

endmodule
