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
  pipe_stall_t npipe_stall;
  logic ifid_FLUSH, idex_FLUSH, exmem_FLUSH, memwb_FLUSH;
  logic [0:1] flushes;
  logic exmem_datarequest;
  logic npc_change, pc_WEN;

  modport hi (
    input idex_DataRead, idex_rt, ifid_rs, ifid_rt,
    input dpif_ihit, dpif_dhit, idex_Halt,
    input flushes,
    input npc_change,
    input exmem_datarequest,
    output npipe_stall,
    output ifid_FLUSH, idex_FLUSH,
    output pc_WEN
  );

endinterface

`endif
