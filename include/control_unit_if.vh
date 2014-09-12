`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  opcode_t opcode;
  logic RegDst, RegWr, PcToReg, ImmToReg, MemToReg;
  logic DatRead, DatWrite;
  logic AluSrc;
  logic BrEq, BrNeq, Jump, Jr;
  logic ExtOp, Halt;

  // ports
  modport ci (
    input   opcode,
    output  RegDst, RegWr, PcToReg, ImmToReg, MemToReg,
    output  DatRead, DatWrite,
    output  AluSrc,
    output  BrEq, BrNeq, Jump, Jr,
    output  ExtOp, Halt
  );

endinterface

`endif //CONTROL_UNIT_IF
