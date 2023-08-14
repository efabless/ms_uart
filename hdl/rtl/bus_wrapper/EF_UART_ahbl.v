
/*
	Copyright 2023 efabless

	Author: Mohamed Shalan (mshalan@efabless.com)

	This file is auto-generated by wrapper_gen.py

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	    http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.

*/


`timescale			1ns/1ns
`default_nettype	none

`define		AHB_BLOCK(name, init)	always @(posedge HCLK or negedge HRESETn) if(~HRESETn) name <= init;
`define		AHB_REG(name, init)		`AHB_BLOCK(name, init) else if(ahbl_we & (last_HADDR==``name``_ADDR)) name <= HWDATA;
`define		AHB_ICR(sz)				`AHB_BLOCK(ICR_REG, sz'b0) else if(ahbl_we & (last_HADDR==ICR_REG_ADDR)) ICR_REG <= HWDATA; else ICR_REG <= sz'd0;

module EF_UART_ahbl (
	input	wire 		RX,
	output	wire 		TX,
	input	wire 		HCLK,
	input	wire 		HRESETn,
	input	wire [31:0]	HADDR,
	input	wire 		HWRITE,
	input	wire [1:0]	HTRANS,
	input	wire 		HREADY,
	input	wire 		HSEL,
	input	wire [2:0]	HSIZE,
	input	wire [31:0]	HWDATA,
	output	wire [31:0]	HRDATA,
	output	wire 		HREADYOUT,
	output	wire 		irq
);
	localparam[15:0] DATA_REG_ADDR = 16'h0000;
	localparam[15:0] PRESCALE_REG_ADDR = 16'h0004;
	localparam[15:0] TXFIFOTR_REG_ADDR = 16'h0008;
	localparam[15:0] RXFIFOTR_REG_ADDR = 16'h000c;
	localparam[15:0] CONTROL_REG_ADDR = 16'h0010;
	localparam[15:0] ICR_REG_ADDR = 16'h0f00;
	localparam[15:0] RIS_REG_ADDR = 16'h0f04;
	localparam[15:0] IM_REG_ADDR = 16'h0f08;
	localparam[15:0] MIS_REG_ADDR = 16'h0f0c;

	reg             last_HSEL;
	reg [31:0]      last_HADDR;
	reg             last_HWRITE;
	reg [1:0]       last_HTRANS;

	always@ (posedge HCLK) begin
		if(HREADY) begin
			last_HSEL       <= HSEL;
			last_HADDR      <= HADDR;
			last_HWRITE     <= HWRITE;
			last_HTRANS     <= HTRANS;
		end
	end

	reg	[7:0]	DATA_REG;
	reg	[15:0]	PRESCALE_REG;
	reg	[3:0]	TXFIFOTR_REG;
	reg	[3:0]	RXFIFOTR_REG;
	reg			CONTROL_REG;
	reg	[5:0]	RIS_REG;
	reg	[5:0]	ICR_REG;
	reg	[5:0]	IM_REG;

	wire[6:0]	wdata	= DATA_REG[6:0];
	wire[14:0]	prescale	= PRESCALE_REG[14:0];
	wire[3:0]	txfifotr	= TXFIFOTR_REG[3:0];
	wire[3:0]	rxfifotr	= RXFIFOTR_REG[3:0];
	wire		en	= CONTROL_REG[0:0];
	wire		to_flag;
	wire		_TX_EMPTY_FLAG_FLAG_	= to_flag;
	wire		match_flag;
	wire		_TX_FULL_FLAG_FLAG_	= match_flag;
	wire		cp_flag;
	wire		_TX_BELOW_FLAG_FLAG_	= cp_flag;
	wire		cp_flag;
	wire		_RX_EMPTY_FLAG_FLAG_	= cp_flag;
	wire		match_flag;
	wire		_RX_FULL_FLAG_FLAG_	= match_flag;
	wire		cp_flag;
	wire		_RX_BELOW_FLAG_FLAG_	= cp_flag;
	wire[5:0]	MIS_REG	= RIS_REG & IM_REG;
	wire		ahbl_valid	= last_HSEL & last_HTRANS[1];
	wire		ahbl_we	= last_HWRITE & ahbl_valid;
	wire		ahbl_re	= ~last_HWRITE & ahbl_valid;
	wire		_clk_	= HCLK;
	wire		_rst_	= ~HRESETn;
	wire		rd	= (ahbl_re & (last_HADDR==DATA_REG_ADDR));
	wire		wr	= (ahbl_we & (last_HADDR==DATA_REG_ADDR));

	EF_UART inst_to_wrap (
		.clk(_clk_),
		.rst_n(~_rst_),
		.prescale(prescale),
		.en(en),
		.rd(rd),
		.wr(wr),
		.wdata(wdata),
		.tx_empty(tx_empty),
		.tx_full(tx_full),
		.tx_level(tx_level),
		.rdata(rdata),
		.rx_empty(rx_empty),
		.rx_full(rx_full),
		.rx_level(rx_level),
		.RX(RX),
		.TX(TX)
	);

	`AHB_REG(DATA_REG, 0)
	`AHB_REG(PRESCALE_REG, 0)
	`AHB_REG(TXFIFOTR_REG, 0)
	`AHB_REG(RXFIFOTR_REG, 0)
	`AHB_REG(CONTROL_REG, 0)

	`AHB_ICR(6)

	always @(posedge HCLK or negedge HRESETn)
		if(~HRESETn) RIS_REG <= 32'd0;
		else begin
			if(_TX_EMPTY_FLAG_FLAG_) RIS_REG[0] <= 1'b1; else if(ICR_REG[0]) RIS_REG[0] <= 1'b0;
			if(_TX_FULL_FLAG_FLAG_) RIS_REG[1] <= 1'b1; else if(ICR_REG[1]) RIS_REG[1] <= 1'b0;
			if(_TX_BELOW_FLAG_FLAG_) RIS_REG[2] <= 1'b1; else if(ICR_REG[2]) RIS_REG[2] <= 1'b0;
			if(_RX_EMPTY_FLAG_FLAG_) RIS_REG[3] <= 1'b1; else if(ICR_REG[3]) RIS_REG[3] <= 1'b0;
			if(_RX_FULL_FLAG_FLAG_) RIS_REG[4] <= 1'b1; else if(ICR_REG[4]) RIS_REG[4] <= 1'b0;
			if(_RX_BELOW_FLAG_FLAG_) RIS_REG[5] <= 1'b1; else if(ICR_REG[5]) RIS_REG[5] <= 1'b0;

		end

	assign irq = |MIS_REG;

	assign	HRDATA = 
			(last_HADDR == DATA_REG_ADDR) ? DATA_REG :
			(last_HADDR == PRESCALE_REG_ADDR) ? PRESCALE_REG :
			(last_HADDR == TXFIFOTR_REG_ADDR) ? TXFIFOTR_REG :
			(last_HADDR == RXFIFOTR_REG_ADDR) ? RXFIFOTR_REG :
			(last_HADDR == CONTROL_REG_ADDR) ? CONTROL_REG :
			(last_HADDR == RIS_REG_ADDR) ? RIS_REG :
			(last_HADDR == ICR_REG_ADDR) ? ICR_REG :
			(last_HADDR == IM_REG_ADDR) ? IM_REG :
			(last_HADDR == MIS_REG_ADDR) ? MIS_REG :
			32'hDEADBEEF;


	assign HREADYOUT = 1'b1;

endmodule
