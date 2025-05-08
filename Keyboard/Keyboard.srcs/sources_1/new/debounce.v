`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 12:16:31
// Design Name: 
// Module Name: debounce
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module debounce #(parameter deb = 10)(
    output reg out,
    input clk,
    input reset,
    input button_in
);

reg old_in;
reg [31:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        old_in <= 0;
        out <= 0;
    end else begin
        if (old_in == button_in) begin
            if (counter >= deb-1) begin
                out <= old_in;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            counter <= 0;
            old_in <= button_in;
        end
    end
end

endmodule