`timescale 1 ns / 1 ps

`include "pixelState.v"
`include "dacAdc.v"
`include "pixelArray.v"
`include "graycounter.v"
`include "databus.v"


module PIXEL_TOP
    (
        input logic reset,
        input logic clk
    );

    //Analog signals
    wire              anaBias1;
    wire              anaRamp;
    wire              anaReset;

    //Tie off the unused lines
    assign anaReset = 1;

    //Digital
    logic           erase;
    logic           expose;
    logic           read1;
    logic           read2;
    tri[7:0]        pixData11; 
    tri[7:0]        pixData12; 
    tri[7:0]        pixData21; 
    tri[7:0]        pixData22; 
    logic[15:0]     pixelDataOut1;
    logic[15:0]     pixelDataOut2;

    logic[7:0]      data;


    GRAYCOUNTER graycounter(.out(data), .clk(clk), .reset(reset), .convert(convert));


    PIXEL_STATE #(.c_erase(5),.c_expose(255),.c_convert(255),.c_read(5))
    stateMachine1(.clk(clk),.reset(reset),.erase(erase),.expose(expose),.read1(read1),
       .read2(read2),.convert(convert));

    PIXEL_ARRAY array(.VBN1(anaBias1), .RAMP(anaRamp), .RESET(anaReset), .ERASE(erase),
                    .EXPOSE(expose), .READ1(read1), .READ2(read2), .DATA11(pixData11), 
                    .DATA12(pixData12), .DATA21(pixData21), .DATA22(pixData22));
                

    DAC_ADC dacadc(.*);

    DATABUS databus(.*);

endmodule //pixelTop
