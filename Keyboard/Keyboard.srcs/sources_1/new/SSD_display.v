`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.04.2025 11:04:36
// Design Name: 
// Module Name: SSD_display
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


module SSD_display(clk,reset,digit,anode,segment, A,B,C,D,E,F,G,H);
input clk,reset;
input [3:0] A,B,C,D,E,F,G,H;
input [3:0]digit;
output reg [7:0]anode;
output reg [6:0]segment;


reg [2:0] display_anode;
reg [3:0] display_digit;
reg [14:0]count;

always @(posedge clk or posedge reset) begin
    if(reset==1)begin
    count<=0;
    display_anode <= 0;
    end
    else begin 
        if(count==10000)begin
           count<=0;
           display_anode <= display_anode + 1;
           if(display_anode ==7)
              display_anode<=0;
        end
              else 
              count<=count+1;                   
       end
end


always @(*) begin
    case (display_anode)
        3'd0: begin anode = 8'b11111110; display_digit = A ; end
        3'd1: begin anode = 8'b11111101; display_digit = B ; end
        3'd2: begin anode = 8'b11111011; display_digit = C ; end
        3'd3: begin anode = 8'b11110111; display_digit = D ; end
        3'd4: begin anode = 8'b11101111; display_digit = E ; end
        3'd5: begin anode = 8'b11011111; display_digit = F ; end
        3'd6: begin anode = 8'b10111111; display_digit = G ; end
        3'd7: begin anode = 8'b01111111; display_digit = H ; end
        default: begin anode = 8'b11111111; display_digit = 4'd0; end
    endcase
end

always@(*)
begin
    case(display_digit)
    4'b0000 : segment = 7'b1000000;
    4'b0001 : segment = 7'b1111001;
    4'b0010 : segment = 7'b0100100;
    4'b0011 : segment = 7'b0110000;
    4'b0100 : segment = 7'b0011001;
    4'b0101 : segment = 7'b0010010;
    4'b0110 : segment = 7'b0000010;
    4'b0111 : segment = 7'b1111000;
    4'b1000 : segment = 7'b0000000;
    4'b1001 : segment = 7'b0010000;        
//    4'b1010 : segment = 7'b0001000;
//    4'b1011 : segment = 7'b0000011;
//    4'b1100 : segment = 7'b1000110;
//    4'b1101 : segment = 7'b0100001;
//    4'b1110 : segment = 7'b0000110;
//    4'b1111 : segment = 7'b0001110;
//    default : segment = 7'b1111111;  
    endcase
end

//always @(*)begin
//    anode = 8'b11111110;
//end
endmodule
