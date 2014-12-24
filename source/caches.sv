/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/
module caches (
  input logic CLK, nRST,
  datapath_cache_if dcif,
  cache_control_if ccif
);
parameter CPUID = 0;
// icache
icache #(.CPUID(CPUID))  ICACHE(CLK, nRST, dcif.icache, ccif.icache);
// dcache
dcache #(.CPUID(CPUID)) DCACHE(CLK, nRST, dcif.dcache, ccif.dcache);

endmodule
