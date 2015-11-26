// Implements the augmented Nios II system for the DE0-Nano board.
// Inputs: SW3−0 are parallel port inputs to the Nios II system.
// CLOCK_50 is the system clock.
// KEY0 is the active-low system reset.
// Outputs: LED3−0 are parallel port outputs from the Nios II system.
// SDRAM ports correspond to the signals in Figure 2; their names are those
// used in the DE0-Nano User Manual.
module lights (SW, KEY, CLOCK_50, LED, DRAM_CLK, DRAM_CKE,
DRAM_ADDR, DRAM_BA, DRAM_CS_N, DRAM_CAS_N, DRAM_RAS_N,
DRAM_WE_N, DRAM_DQ, DRAM_DQM);
input [3:0] SW;
input [0:0] KEY;
input CLOCK_50;
output [3:0] LED;
output [12:0] DRAM_ADDR;
output [1:0] DRAM_BA;
output DRAM_CAS_N, DRAM_RAS_N, DRAM_CLK;
output DRAM_CKE, DRAM_CS_N, DRAM_WE_N;
output [1:0] DRAM_DQM;
inout [15:0] DRAM_DQ;
// Instantiate the Nios II system module generated by the SOPC Builder
nios2_gen2_0 NiosII (
CLOCK_50,
KEY[0],
LED,
SW,
DRAM_ADDR,
DRAM_BA,
DRAM_CAS_N,
DRAM_CKE,
DRAM_CS_N,
DRAM_DQ,
DRAM_DQM,
DRAM_RAS_N,
DRAM_WE_N);
assign DRAM_CLK = CLOCK_50;
endmodule


/*// Implements a simple Nios II system for the DE-series board.
// Inputs: SW7−0 are parallel port inputs to the Nios II system
// CLOCK_50 is the system clock
// KEY0 is the active-low system reset
// Outputs: LEDG7−0 are parallel port outputs from the Nios II system
module lights (SW, KEY, CLOCK_50, LEDG);
input [7:0] SW;
input [0:0] KEY;
input CLOCK_50;
output [7:0] LEDG;
// Instantiate the Nios II system module generated by the SOPC Builder:
// nios2_gen2_0 (clk_0, reset_n, out_port_from_the_LEDs, in_port_to_the_Switches)
nios2_gen2_0 NiosII (CLOCK_50, KEY[0], LEDG, SW);
endmodule
*/