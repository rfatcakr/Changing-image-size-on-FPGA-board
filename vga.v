
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:22:30 10/14/2011 
// Design Name: 
// Module Name:    vga 
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
`define PAL 640		//--Pixels/Active Line (pixels)
`define LAF 480		//--Lines/Active Frame (lines)
`define PLD 800	   //--Pixel/Line Divider
`define LFD 521	   //--Line/Frame Divider
`define HPW 96		   //--Horizontal synchro Pulse Width (pixels)
`define HFP 16		   //--Horizontal synchro Front Porch (pixels)
//`define HBP 48		--Horizontal synchro Back Porch (pixels)
`define VPW 2   		//--Vertical synchro Pulse Width (lines)
`define VFP 10	
`define PRV  50
`define PRH  200
`define PRVF 306
`define PRHF 456
`define INITIAL  0
	   //--Vertical synchro Front Porch (lines)
//`define VBP 29     //--Vertical synchro Back Porch (lines)

module vga(ck, Hcnt, Vcnt, HS, VS, outRed, outGreen, outBlue);
	input ck;
	output reg HS, VS;
	output reg [2:0] outRed, outGreen;
	output reg [1:0] outBlue;
	//reg INITIAL;
	output reg [9:0] Hcnt, Vcnt;	
	reg ck25MHz;
	
	// -- divide 50MHz clock to 25MHz

	always @ (posedge ck)
		ck25MHz<= ~ck25MHz;
		
	always @ (posedge ck25MHz) begin
		if (Hcnt == `PLD-1) begin
			Hcnt<= 10'h0;
			if (Vcnt == `LFD-1) 
				Vcnt <= 10'h0;
				
			else 
				Vcnt <= Vcnt + 10'h1;
		end
		else 
			Hcnt<= Hcnt +10'h1;
	end
			
	
//-- Generates HS - active low
	always @(posedge ck25MHz) begin
		if (Hcnt == `PAL-1 +`HFP)
			HS<=1'b0;
		else if (Hcnt == `PAL-1+`HFP+`HPW)
			HS<=1'b1;
	end

//-- Generates VS - active low
	always @(posedge ck25MHz) begin
		if (Vcnt ==`LAF-1+`VFP)
			VS <= 1'b0;
		else if (Vcnt== `LAF-1+`VFP+`VPW)
			VS <= 1'b1;	
	end 

	reg [0:0] cycle;
	reg [1:0] btur;
	reg [1:0] tur;
   reg [14:0] addra;
	wire [7:0] douta;
	always @ (posedge ck25MHz) begin
		
		if ((Hcnt <`PAL) && (Vcnt < `LAF)) begin
		    if((Hcnt==`INITIAL) &&(Vcnt==`INITIAL))begin
			      addra<=15'b00000000000000;
					outRed<=3'b000;
					outGreen<=3'b00;
					outBlue<=2'b00;
					tur <= 0;
					cycle <= 0;
			 end 
			 else if((Hcnt>= 100 && Hcnt<=355) && (Vcnt>=100 && Vcnt<=355))begin
			      
					if(tur==0 && Hcnt==355)begin
						addra<=addra-128;
						tur<=1;
					end
					else if(tur==1 && Hcnt==355) begin
						tur<=0;
					end
					
					else if(cycle == 1'b1) begin
						addra<=addra+14'b00000000000001;
					end
					
					cycle <= cycle + 1'b1;
					
					outRed<=douta[7:5];
					outGreen<=douta[4:2];
					outBlue<=douta[1:0];
				
			 end
			 else begin
			      addra<=addra;
					outRed<=3'b000;
					outGreen<=3'b00;
					outBlue<=2'b00;
					
		    end
		
		
		end
		else begin
			outRed <= 3'b000;
			outGreen <= 3'b000;
			outBlue <= 2'b00;
		end
	end
	frameBuffer inst_parrot (
  .clka(ck25MHz), // input clka
  
  .addra(addra), // input [14 : 0] addra
  .douta(douta) // output [7 : 0] douta
   );
			
endmodule
