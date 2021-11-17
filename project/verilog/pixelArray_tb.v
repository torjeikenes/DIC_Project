`timescale 1 ns / 1 ps

//====================================================================
// Testbench for pixelArray
// - clock
// - instanciate pixelarray
// - State Machine for controlling pixel sensor
// - Model the ADC and ADC
// - Readout of the databus
// - Stuff neded for testbench. Store the output file etc.
//====================================================================
module pixelArray_tb;

   //------------------------------------------------------------
   // Testbench clock
   //------------------------------------------------------------
   logic clk =0;
   logic reset =0;
   parameter integer clk_period = 500;
   parameter integer sim_end = clk_period*2400;
   always #clk_period clk=~clk;

   //------------------------------------------------------------
   // Pixel
   //------------------------------------------------------------

   //Analog signals
   logic              anaBias1;
   logic              anaRamp;
   logic              anaReset;

   //Tie off the unused lines
   assign anaReset = 1;

   //Digital
   logic              erase;
   logic              expose;
   logic              read1;
   logic              read2;
   tri[7:0]         pixData11; //  We need this to be a wire, because we're tristating it
   tri[7:0]         pixData12; //  We need this to be a wire, because we're tristating it
   tri[7:0]         pixData21; //  We need this to be a wire, because we're tristating it
   tri[7:0]         pixData22; //  We need this to be a wire, because we're tristating it

   //Instanciate the pixel
   PIXEL_ARRAY pa1(.VBN1(anaBias1), .RAMP(anaRamp), .RESET(anaReset), .ERASE(erase),
                    .EXPOSE(expose), .READ1(read1), .READ2(read2), .DATA11(pixData11), 
                    .DATA12(pixData12), .DATA21(pixData21), .DATA22(pixData22));

   //------------------------------------------------------------
   // State Machine
   //------------------------------------------------------------
   parameter ERASE=0, EXPOSE=1, CONVERT=2, READ1=3, READ2=4, IDLE=5;

   logic               convert;
   logic               convert_stop;
   logic [2:0]         state,next_state;   //States
   integer           counter;            //Delay counter in state machine

   //State duration in clock cycles
   parameter integer c_erase = 5;
   parameter integer c_expose = 255;
   parameter integer c_convert = 255;
   parameter integer c_read = 5;

   // Control the output signals
   always_ff @(negedge clk ) begin
      case(state)
        ERASE: begin
           erase <= 1;
           read1 <= 0;
           read2 <= 0;
           expose <= 0;
           convert <= 0;
        end
        EXPOSE: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           expose <= 1;
           convert <= 0;
        end
        CONVERT: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           expose <= 0;
           convert = 1;
        end
        READ1: begin
           erase <= 0;
           read1 <= 1;
           read2 <= 0;
           expose <= 0;
           convert <= 0;
        end
        READ2: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 1;
           expose <= 0;
           convert <= 0;
        end
        IDLE: begin
           erase <= 0;
           read1 <= 0;
           read2 <= 0;
           expose <= 0;
           convert <= 0;
        end
      endcase // case (state)
   end // always @ (state)


   // Control the state transitions.
   //TODO: The counter should probably be an always_comb. Might be a good idea
   //to also reset the counter from the state machine, i.e provide the count
   //down value, and trigger on 0
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         state = IDLE;
         next_state = ERASE;
         counter  = 0;
         convert  = 0;
      end
      else begin
         case (state)
           ERASE: begin
              if(counter == c_erase) begin
                 next_state <= EXPOSE;
                 state <= IDLE;
              end
           end
           EXPOSE: begin
              if(counter == c_expose) begin
                 next_state <= CONVERT;
                 state <= IDLE;
              end
           end
           CONVERT: begin
              if(counter == c_convert) begin
                 next_state <= READ1;
                 state <= IDLE;
              end
           end
           READ1:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= READ2;
             end
           READ2:
             if(counter == c_read) begin
                state <= IDLE;
                next_state <= ERASE;
             end
           IDLE:
             state <= next_state;
         endcase // case (state)
         if(state == IDLE)
           counter = 0;
         else
           counter = counter + 1;
      end
   end // always @ (posedge clk or posedge reset)

   //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------
   logic[7:0] data;

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

   // When convert, then run a analog ramp (via anaRamp clock) and digtal ramp via
   // data bus.
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         data =0;
      end
      if(convert) begin
         data +=  1;
      end
      else begin
         data = 0;
      end
   end // always @ (posedge clk or reset)

   //------------------------------------------------------------
   // Readout from databus
   //------------------------------------------------------------
   logic [7:0] pixelDataOut11;
   logic [7:0] pixelDataOut12;
   logic [7:0] pixelDataOut21;
   logic [7:0] pixelDataOut22;
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         pixelDataOut11 = 0;
         pixelDataOut12 = 0;
         pixelDataOut21 = 0;
         pixelDataOut22 = 0;
      end
      else begin
        if(read1) begin
            pixelDataOut11 <= pixData11;
            pixelDataOut12 <= pixData12;
          end
          else if(read2) begin
            pixelDataOut21 <= pixData21;
            pixelDataOut22 <= pixData22;
          end

      end
   end

   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   initial
     begin
        reset = 1;

        #clk_period  reset=0;

        $dumpfile("pixelArray_tb.vcd");
        $dumpvars(0,pixelArray_tb);

        #sim_end
          $stop;

     end

endmodule // test
