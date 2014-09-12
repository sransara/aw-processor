/*
  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;
  parameter CPUID = 0;

  logic [1:0] pep; // used for priority
  logic dRW;
  assign dRW = ccif.dREN[CPUID] || ccif.dWEN[CPUID];
  assign pep = { dRW, ccif.iREN[CPUID] };

  assign ccif.dload[CPUID] = ccif.ramload;
  assign ccif.iload[CPUID] = ccif.ramload;
  assign ccif.ramstore = ccif.dstore[CPUID];

  always_comb
  begin
    ccif.ramREN = (ccif.iREN[CPUID] && ~ccif.dWEN[CPUID]) || ccif.dREN[CPUID];
    ccif.ramWEN = ccif.dWEN[CPUID];
    ccif.ramaddr =  0;
    ccif.iwait[CPUID] = 1'b1;
    ccif.dwait[CPUID] = 1'b1;

    casez(pep)
      2'b1?: begin
        ccif.ramaddr = ccif.daddr[CPUID];
        ccif.dwait[CPUID] = ~(ccif.ramstate == ACCESS);
      end
      2'b01: begin
        ccif.ramaddr = ccif.iaddr[CPUID];
        ccif.iwait[CPUID] = ~(ccif.ramstate == ACCESS);
      end
    endcase
  end
endmodule
