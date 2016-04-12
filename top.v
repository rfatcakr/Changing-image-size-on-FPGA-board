`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:59:49 10/14/2011 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top( mclk, OutBlue, OutGreen, OutRed, HS, VS);
	input mclk;
	output [2:0] OutRed;
	output [2:0] OutGreen;
	output [1:0] OutBlue;
	output HS, VS;
	
	vga vgainst(.ck(mclk), .HS(HS), .VS(VS), .outRed(OutRed), .outGreen(OutGreen), .outBlue(OutBlue));

endmodule
