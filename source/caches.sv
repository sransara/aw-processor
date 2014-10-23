/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/
module caches (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  cache_control_if.caches ccif
);
parameter CPUID = 0;
// icache
icache #(.CPUID(CPUID))  ICACHE(CLK, nRST, dcif, ccif);
// dcache
dcache #(.CPUID(CPUID)) DCACHE(CLK, nRST, dcif, ccif);

endmodule
