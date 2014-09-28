`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
  // import types
  import cpu_types_pkg::*;

  aluop_t aluop;
  word_t    port_a, port_b, out;
  logic     negative, overflow, zero;

  // alu ports
  modport ai (
    input   aluop, port_a, port_b,
    output  out, negative, overflow, zero
  );
  // alu tb
  modport at (
    input   out, negative, overflow, zero,
    output  aluop, port_a, port_b
  );
endinterface

`endif //ALU_IF
