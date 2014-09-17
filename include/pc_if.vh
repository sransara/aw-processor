`ifndef PC_IF_VH
`define PC_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pc_if;
  // import types
  import cpu_types_pkg::*;

  logic [IMM_W-1:0] imm;
  logic [ADDR_W-1:0] addr;
  logic ihit;
  logic alu_zero;
  logic BrEq, BrNeq, Jump, RegToPc, Halt;
  word_t rdat;
  word_t pc_plus;
  word_t cpc;
  logic wen;

  // ports
  modport pci (
    input wen,
    input alu_zero, ihit, imm, addr,
    input BrEq, BrNeq, Jump, RegToPc, Halt,
    input rdat,
    output cpc, pc_plus
  );

endinterface

`endif //CONTROL_UNIT_IF
