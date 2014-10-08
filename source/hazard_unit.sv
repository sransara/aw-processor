// interface include
`include "cpu_types_pkg.vh"
`include "aww_types_pkg.vh"
`include "hazard_unit_if.vh"

module hazard_unit (
  hazard_unit_if.hi huif
);
  import cpu_types_pkg::*;
  import aww_types_pkg::*;

  assign huif.ifid_FLUSH = huif.flushes[0] | huif.idex_Halt;
  assign huif.idex_FLUSH = huif.flushes[1];
  assign huif.exmem_FLUSH = huif.flushes[2];
  assign huif.memwb_FLUSH = huif.flushes[3];
  assign huif.pc_WEN = huif.npc_change | (huif.npipe_stall === NO_STALL);

  always_comb
  begin
    huif.npipe_stall = IFID_STALL;
    if(huif.idex_DataRead & ((huif.idex_rt == huif.ifid_rs) | (huif.idex_rt == huif.ifid_rt)))
    begin
      huif.npipe_stall = IDEX_STALL;
    end
    else if(huif.dpif_dhit) begin
      huif.npipe_stall = IFID_STALL;
    end
    else if(huif.exmem_datarequest) begin
      huif.npipe_stall = FULL_STALL;
    end
    else if(huif.dpif_ihit) begin
      huif.npipe_stall = NO_STALL;
    end
  end
endmodule
