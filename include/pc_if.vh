`ifndef PC_IF_VH
`define PC_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pc_if;
  // import types
  import cpu_types_pkg::*;

  word_t pc_plus;
  word_t npc, cpc;
  logic WEN;

  // ports
  modport pci (
    input WEN, npc,
    output cpc, pc_plus
  );

endinterface

`endif //CONTROL_UNIT_IF
