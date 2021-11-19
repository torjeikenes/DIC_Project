`timescale 1 ns / 1 ps

`include "pixelSensor.v"

module PIXEL_ARRAY
    (
        input wire anaBias1,
        input wire anaRamp,
        input wire anaReset,
        input wire erase,
        input wire expose,
        input wire read1,
        input wire read2,

        inout [7:0] pixData1,
        inout [7:0] pixData2
    );

    
//Four pixel instances with the same signals except for READ.
    PIXEL_SENSOR #(.dv_pixel(0.4)) px11(
        .VBN1(anaBias1), 
        .RAMP(anaRamp), 
        .RESET(anaReset), 
        .ERASE(erase),
        .EXPOSE(expose), 
        .READ(read1),
        .DATA(pixData1));

    PIXEL_SENSOR #(.dv_pixel(0.5)) px12(
        .VBN1(anaBias1), 
        .RAMP(anaRamp), 
        .RESET(anaReset), 
        .ERASE(erase),
        .EXPOSE(expose), 
        .READ(read1),
        .DATA(pixData2));

    PIXEL_SENSOR #(.dv_pixel(0.6)) px21(
        .VBN1(anaBias1), 
        .RAMP(anaRamp), 
        .RESET(anaReset), 
        .ERASE(erase),
        .EXPOSE(expose), 
        .READ(read2),
        .DATA(pixData1));

    PIXEL_SENSOR  #(.dv_pixel(0.7)) px22(
        .VBN1(anaBias1), 
        .RAMP(anaRamp), 
        .RESET(anaReset), 
        .ERASE(erase),
        .EXPOSE(expose), 
        .READ(read2),
        .DATA(pixData2));
endmodule
