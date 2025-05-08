`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.04.2025 12:57:44
// Design Name: 
// Module Name: keyboard
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


module keyboard(clk,reset,ps2_in,ps2c,ps2_out,flag,anode,segment);
    input clk,reset, ps2_in, ps2c;
    output [7:0] ps2_out;
    output reg flag;
    output  [7:0]anode;
    output  [6:0]segment;
    
reg [3:0] digit;

wire [7:0]anode_wire;
wire [6:0]segment_wire;

parameter deb = 40;
wire ps2_data;
wire ps2_clk;

debounce #(deb) D1(.out(ps2_clk), .clk(clk), .reset(reset), .button_in(ps2c));
debounce #(deb) D2(.out(ps2_data), .clk(clk), .reset(reset), .button_in(ps2_in));
SSD_display S1(.clk(clk),.reset(reset),.digit(digit),.anode(anode_wire),.segment(segment_wire),.A(A), .B(B), .C(C), .D(D),
        .E(E), .F(F), .G(G), .H(H));

assign anode = anode_wire;
assign segment = segment_wire;

reg [7:0] shift_reg;
reg [3:0] state;

parameter s0 = 4'd0, 
          s1 = 4'd1, 
          s2 = 4'd2, 
          s3 = 4'd3, 
          s4 = 4'd4,
          s5 = 4'd5, 
          s6 = 4'd6, 
          s7 = 4'd7, 
          s8 = 4'd8, 
          s9 = 4'd9,
          s10 = 4'd10;

always @(negedge ps2_clk or posedge reset) begin
    if (reset) begin
        shift_reg <= 8'd0;
        state <= s0;
        flag <= 0;
    end else begin
        case (state)
            s0: begin state <= s1; flag <= 0; end
            s1: begin state <= s2; shift_reg[0] <= ps2_data; end
            s2: begin state <= s3; shift_reg[1] <= ps2_data; end
            s3: begin state <= s4; shift_reg[2] <= ps2_data; end
            s4: begin state <= s5; shift_reg[3] <= ps2_data; end
            s5: begin state <= s6; shift_reg[4] <= ps2_data; end
            s6: begin state <= s7; shift_reg[5] <= ps2_data; end
            s7: begin state <= s8; shift_reg[6] <= ps2_data; end
            s8: begin state <= s9; shift_reg[7] <= ps2_data; end
            s9: begin state <= s10; flag <= 1; end
            s10: begin state <= s0; flag <= 0; end
            default: begin state <= s0; end
        endcase
    end
end


always @(*)
    case(shift_reg)
        8'h45: digit = 0;
        8'h16: digit = 1;
        8'h1E: digit = 2;
        8'h26: digit = 3;
        8'h25: digit = 4;
        8'h2E: digit = 5;
        8'h36: digit = 6;
        8'h3D: digit = 7;
        8'h3E: digit = 8;
        8'h46: digit = 9;
//        8'h1C: digit = 10;
//        8'h32: digit = 11;
//        8'h21: digit = 12;
//        8'h23: digit = 13;
//        8'h24: digit = 14;
//        8'h2B: digit = 15;  
//        default : digit = 0;        
    endcase

assign ps2_out = shift_reg;

reg [3:0] A,B,C,D,E,F,G,H;
reg [2:0]refresh_count;
always @(posedge flag or posedge reset)begin
    if(reset)begin
       {A,B,C,D,E,F,G,H} <=0;
        refresh_count <= 0;
    end
    else begin
        if(refresh_count == 2)begin
        H <= G;
        G <= F;
        F <= E;
        E <= D;
        D <= C;
        C <= B;
        B <= A;
        A <= digit;
        refresh_count <= 0;
        end
        else 
        refresh_count <= refresh_count +1;
    end
end

endmodule