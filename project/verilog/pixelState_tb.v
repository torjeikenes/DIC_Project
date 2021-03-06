`timescale 1 ns / 1 ps


module pixelState_tb;

   //------------------------------------------------------------
   // Testbench clock
   //------------------------------------------------------------
   logic clk =0;
   logic reset =0;
   logic start =0;
   parameter integer clk_period = 500;
   parameter integer sim_end = clk_period*2400;
   always #clk_period clk=~clk;

   //Digital
   wire              erase;
   wire              expose;
   wire             read1;
   wire             read2;
   wire             convert;



   PIXEL_STATE #(.c_erase(5),.c_expose(255),.c_convert(255),.c_read(5))
   stateMachine1(.*);


   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   initial
     begin
        reset = 1;

        #clk_period  reset=0;

        $dumpfile("pixelState_tb.vcd");
        $dumpvars(0,pixelState_tb);


        #2000 start = 1;
        #500 start = 0;

        #600000 start = 1;
        #clk_period  start=0;

        #300000 reset = 1;
        #clk_period  reset=0;

        #sim_end
          $stop;

     end

endmodule // test   
