`timescale 1 ns / 1 ps

`include "pixelSensor.v"

module PIXEL_ARRAY
    (
        input logic VBN1,
        input logic RAMP,
        input logic RESET,
        input logic ERASE,
        input logic EXPOSE,
        input logic READ1,
        input logic READ2,
        inout [7:0] DATA11,
        inout [7:0] DATA12,
        inout [7:0] DATA21,
        inout [7:0] DATA22
    );

    
//Four pixel instances with the same signals except for READ.
    PIXEL_SENSOR #(.dv_pixel(0.4)) px11(
        .VBN1(VBN1), 
        .RAMP(RAMP), 
        .RESET(RESET), 
        .ERASE(ERASE),
        .EXPOSE(EXPOSE), 
        .READ(READ1),
        .DATA(DATA11));

    PIXEL_SENSOR #(.dv_pixel(0.5)) px12(
        .VBN1(VBN1), 
        .RAMP(RAMP), 
        .RESET(RESET), 
        .ERASE(ERASE),
        .EXPOSE(EXPOSE), 
        .READ(READ1),
        .DATA(DATA12));

    PIXEL_SENSOR #(.dv_pixel(0.6)) px21(
        .VBN1(VBN1), 
        .RAMP(RAMP), 
        .RESET(RESET), 
        .ERASE(ERASE),
        .EXPOSE(EXPOSE), 
        .READ(READ2),
        .DATA(DATA21));

    PIXEL_SENSOR  #(.dv_pixel(0.7)) px22(
        .VBN1(VBN1), 
        .RAMP(RAMP), 
        .RESET(RESET), 
        .ERASE(ERASE),
        .EXPOSE(EXPOSE), 
        .READ(READ2),
        .DATA(DATA22));
endmodule
