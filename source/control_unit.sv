`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

module control_unit
import cpu_types_pkg::*;
(
  control_unit_if.ci cuif
);

always_comb
begin
  cuif.RegDst = 1;
  cuif.RegWr = 1;
  cuif.PcToReg = 0;
  cuif.ImmToReg = 0;
  cuif.ExtOp = 0;
  cuif.AluSrc = 0;
  cuif.MemToReg = 0;
  cuif.DatRead = 0;
  cuif.DatWrite = 0;
  cuif.BrEq = 0;
  cuif.BrNeq = 0;
  cuif.Jump = 0;
  cuif.Jr = 0;
  cuif.Halt = 0;

  if(cuif.opcode == HALT) cuif.Halt = 1;

end


endmodule
