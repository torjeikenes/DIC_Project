`timescale 1 ns / 1 ps

module GRAYCOUNTER(
    input wire clk, 
    input wire reset,
    input wire read1,
    input wire read2,
    input wire convert,
    inout logic[7:0] pixData1,
    inout logic[7:0] pixData2
);

    logic[7:0] data;
    logic[7:0] q;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 0;
        end
        if(convert) begin
            q <= q + 1;
        end
        else begin
            q <= 0;
        end
        data <= {q[7], q[7:1] ^ q[6:0]};
    end


    //If we're not reading the pixData, then we should drive the bus
    assign read = read1 || read2;

    assign pixData1 = read ? 8'bZ: data;
    assign pixData2 = read ? 8'bZ: data;



endmodule // graycounter

