`timescale 1 ns / 1 ps

module GRAYCOUNTER(out, clk, reset, convert);
    parameter WIDTH = 8;
    output [WIDTH-1 : 0] out;
    input clk, reset;
    logic [WIDTH-1 : 0] out;
    wire clk, reset;
    logic [WIDTH-1 : 0] q;
    input convert;

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
        out <= {q[WIDTH-1], q[WIDTH-1:1] ^ q[WIDTH-2:0]};
        //out <= q;
    end
endmodule // graycounter

