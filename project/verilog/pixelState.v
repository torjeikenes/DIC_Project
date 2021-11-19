`timescale 1 ns / 1 ps

module PIXEL_STATE
    (
        input logic start,
        input logic clk,
        input logic reset,
        output logic erase,
        output logic expose,
        output logic read1,
        output logic read2,
        output logic convert
    );

   //------------------------------------------------------------
   // State Machine
   //------------------------------------------------------------
   parameter ERASE=0, EXPOSE=1, CONVERT=2, READ1=3, READ2=4, IDLE=5;

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
   always_ff @(posedge clk or posedge reset or posedge start) begin
      if(reset) begin
         state = IDLE;
         counter  = 0;
         convert  = 0;
      end
      else begin
         case (state)
           ERASE: begin
              if(counter == c_erase) begin
                state <= EXPOSE;
                counter = 0;
              end
           end
           EXPOSE: begin
              if(counter == c_expose) begin
                state <= CONVERT;
                counter = 0;
              end
           end
           CONVERT: begin
              if(counter == c_convert) begin
                state <= READ1;
                counter = 0;
              end
           end
           READ1:
             if(counter == c_read) begin
                state <= READ2;
                counter = 0;
             end
           READ2:
             if(counter == c_read) begin
                state <= IDLE;
                counter = 0;
             end
           IDLE:
             if(start) begin
                state <= ERASE;
                counter = 0;
             end
         endcase // case (state)
         if(state == IDLE)
           counter = 0;
         else
           counter = counter + 1;
      end
   end // always @ (posedge clk or posedge reset)

endmodule //pixelState
