`ifndef HAZRAD_UNIT_IF_VH
`define HAZRAD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "aww_types_pkg.vh"

interface hazard_unit_if;
  // import types
  import cpu_types_pkg::*;
  import aww_types_pkg::*;

  logic idex_DataRead;
  regbits_t idex_rt, ifid_rs, ifid_rt;
  logic dpif_ihit, dpif_dhit, idex_Halt;
  logic pc_WEN;
  pipe_stall_t pipe_stall;
  logic ifid_FLUSH, idex_FLUSH, exmem_FLUSH, memwb_FLUSH;
  logic [0:3] flushes;
  logic npc_change, exmem_datarequest;

  modport hi (
    input idex_DataRead, idex_rt, ifid_rs, ifid_rt,
    input dpif_ihit, dpif_dhit, idex_Halt,
    input flushes,
    input npc_change, exmem_datarequest,
    output pc_WEN,
    output pipe_stall,
    output ifid_FLUSH, idex_FLUSH, exmem_FLUSH, memwb_FLUSH
  );

endinterface

`endif
