`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  opcode_t opcode;
  funct_t funct;
  logic RegDst, RegWr, PcToReg, ImmToReg, MemToReg;
  logic DatRead, DatWrite;
  logic BrEq, BrNeq, Jump, Jal, RegToPc;
  logic ExtOp, Halt;
  logic ShamToAlu, ImmToAlu;

  // ports
  modport ci (
    input   opcode,
    input   funct,
    output  RegDst, RegWr, PcToReg, ImmToReg, MemToReg,
    output  DatRead, DatWrite,
    output  ShamToAlu, ImmToAlu,
    output  BrEq, BrNeq, Jump, Jal, RegToPc,
    output  ExtOp, Halt
  );

endinterface

`endif //CONTROL_UNIT_IF
