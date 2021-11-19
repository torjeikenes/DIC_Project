`timescale 1 ns / 1 ps

`include "pixelState.v"
`include "dac.v"
`include "pixelArray.v"
`include "graycounter.v"
`include "databus.v"


module PIXEL_TOP
    (
        input logic reset,
        input logic clk,
        input logic start
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
    tri[7:0]        pixData1; 
    tri[7:0]        pixData2; 
    logic[15:0]     pixelDataOut;



    GRAYCOUNTER graycounter(.*);


    PIXEL_STATE #(.c_erase(5),.c_expose(255),.c_convert(255),.c_read(5))
    stateMachine1(.start(start), .clk(clk),.reset(reset),.erase(erase),.expose(expose),.read1(read1),
       .read2(read2),.convert(convert));

    PIXEL_ARRAY array(.*);
                

    DAC dacadc(.*);

    DATABUS databus(.*);

endmodule //pixelTop
