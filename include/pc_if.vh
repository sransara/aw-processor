`ifndef PC_IF_VH
`define PC_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pc_if;
  // import types
  import cpu_types_pkg::*;

  word_t cpc, pc_plus, rdat;
  logic [IMM_W-1:0] imm;
  logic [ADDR_W-1:0] addr;
  logic ihit, alu_zero;
  logic BrEq, BrNeq, RegToPc, Jump, Halt;

  // ports
  modport pci (
    input imm, addr,
    input ihit, alu_zero,
    input BrEq, BrNeq, RegToPc, Jump, Halt,
    input rdat,
    output cpc, pc_plus
  );

endinterface

`endif //CONTROL_UNIT_IF
