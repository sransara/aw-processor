/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"
module caches (
  input logic CLK, nRST,
  datapath_cache_if dcif,
  cache_control_if ccif
);
parameter CPUID = 0;
// icache
//icache #(.CPUID(CPUID))  ICACHE(CLK, nRST, dcif.icache, ccif.iwait[CPUID], ccif.iload[CPUID], ccif.iREN[CPUID], ccif.iaddr[CPUID]);
icache #(.CPUID(CPUID))  ICACHE(CLK, nRST, dcif.icache, ccif);
// dcache
dcache #(.CPUID(CPUID)) DCACHE(CLK, nRST, dcif.dcache, ccif);

endmodule
