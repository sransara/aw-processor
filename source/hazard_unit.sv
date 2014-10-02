// interface include
`include "cpu_types_pkg.vh"
`include "aww_types_pkg.vh"
`include "hazard_unit_if.vh"

module hazard_unit (
  hazard_unit_if.hi huif
);
  import cpu_types_pkg::*;
  import aww_types_pkg::*;

  assign huif.ifid_FLUSH = huif.flushes[0] | huif.dpif_dhit | huif.idex_Halt;
  assign huif.idex_FLUSH = huif.flushes[1];
  assign huif.exmem_FLUSH = huif.flushes[2];
  assign huif.memwb_FLUSH = huif.flushes[3];
  assign huif.pc_WEN = huif.pipe_stall === NO_STALL;

  always_comb
  begin
    huif.pipe_stall = FULL_STALL;
    if(huif.idex_DataRead & ((huif.idex_rt == huif.ifid_rs) | (huif.idex_rt == huif.ifid_rt)))
    begin
      huif.pipe_stall = IDEX_STALL;
    end
    else if (huif.BranchTaken & huif.exmem_Data) begin
      huif.pipe_stall = EXMEM_STALL;
    end
    else if(huif.dpif_dhit | huif.dpif_ihit) begin
      huif.pipe_stall = NO_STALL;
    end
  end
endmodule
