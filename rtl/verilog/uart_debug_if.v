//////////////////////////////////////////////////////////////////////
////                                                              ////
////  uart_debug_if.v                                             ////
////                                                              ////
////                                                              ////
////  This file is part of the "UART 16550 compatible" project    ////
////  http://www.opencores.org/cores/uart16550/                   ////
////                                                              ////
////  Documentation related to this project:                      ////
////  - http://www.opencores.org/cores/uart16550/                 ////
////                                                              ////
////  Projects compatibility:                                     ////
////  - WISHBONE                                                  ////
////  RS232 Protocol                                              ////
////  16550D uart (mostly supported)                              ////
////                                                              ////
////  Overview (main Features):                                   ////
////  UART core debug interface.                                  ////
////                                                              ////
////  Author(s):                                                  ////
////      - gorban@opencores.org                                  ////
////      - Jacob Gorban                                          ////
////                                                              ////
////  Created:        2001/12/02                                  ////
////                  (See log for the revision history)          ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000, 2001 Authors                             ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
//
// CVS Revision History
//
// $Log: not supported by cvs2svn $
// Revision 1.1  2001/12/04 21:14:16  gorban
// committed the debug interface file
//

// synopsys translate_off
`include "timescale.v"
// synopsys translate_on

`include "uart_defines.v"

module uart_debug_if (/*AUTOARG*/
// Outputs
wb_dat32_o, 
// Inputs
wb_clk_i, wb_rst_i, wb_adr_i, re_o, ier, iir, fcr, mcr, lcr, msr, 
lsr, rf_count, tf_count, tstate, rstate
) ;

input 									wb_clk_i;
input 									wb_rst_i;
input [`UART_ADDR_WIDTH-1:0] 		wb_adr_i;
output [31:0] 							wb_dat32_o;
input 									re_o;
input [3:0] 							ier;
input [3:0] 							iir;
input [1:0] 							fcr;  /// bits 7 and 6 of fcr. Other bits are ignored
input [4:0] 							mcr;
input [7:0] 							lcr;
input [7:0] 							msr;
input [7:0] 							lsr;
input [`UART_FIFO_COUNTER_W-1:0] rf_count;
input [`UART_FIFO_COUNTER_W-1:0] tf_count;
input [2:0] 							tstate;
input [3:0] 							rstate;


wire [`UART_ADDR_WIDTH-1:0] 		wb_adr_i;
reg [31:0] 								wb_dat32_o;

always @(/*AUTOSENSE*/fcr or ier or iir or lcr or lsr or mcr or msr
			or rf_count or rstate or tf_count or tstate or wb_adr_i)
	case (wb_adr_i)
		                      // 8 + 8 + 4 + 4 + 8
		5'b01000: wb_dat32_o = {msr,lcr,iir,ier,lsr};
		               // 5 + 2 + 5 + 4 + 5 + 3
		5'b01100: wb_dat32_o = {8'b0, fcr,mcr, rf_count, rstate, tf_count, tstate};
		default: wb_dat32_o = 0;
	endcase // case(wb_adr_i)

endmodule // uart_debug_if

