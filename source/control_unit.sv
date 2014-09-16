`include "control_unit_if.vh"
`include "cpu_types_pkg.vh"

module control_unit
import cpu_types_pkg::*;
(
  control_unit_if.ci cuif
);

opcode_t opcode;
funct_t funct;
assign opcode = cuif.opcode;
assign funct = cuif.funct;

assign cuif.RegDst = (opcode === RTYPE) && (funct !== JR);
assign cuif.RegWr = ~((opcode === RTYPE) && (funct  === JR)) && (opcode !== BEQ)
            && (opcode !== BNE) && (opcode !== SW) && (opcode !== J)
            && (opcode !== HALT);

assign  cuif.ImmToReg = (opcode === LUI);
assign  cuif.ExtOp = (opcode === ADDIU) || (opcode === LW) || (opcode === SW)
            || (opcode === SLTIU) || (opcode == SLTI) || (opcode === LL) || (opcode === SC);

assign  cuif.ShamToAlu = (opcode === RTYPE) && ((funct === SLL) || (funct === SRL));

assign  cuif.ImmToAlu= (opcode !== RTYPE) && (opcode !== BEQ) && (opcode !== BNE)
            && (opcode !== JAL) && (opcode !== J) && (opcode !== HALT);

assign cuif.MemToReg = (opcode === LW) || (opcode === LL);
assign cuif.DatRead = (opcode === LW) || (opcode === LL);
assign cuif.DatWrite = (opcode === SW) || (opcode === SC);

assign cuif.BrEq = (opcode === BEQ);
assign cuif.BrNeq = (opcode === BNE);
assign cuif.Jump = (opcode === J) || (opcode === JAL);
assign cuif.RegToPc = (opcode === RTYPE) && (funct === JR);
assign cuif.Jal = (opcode === JAL);
assign cuif.PcToReg = (opcode === JAL);

assign cuif.Halt = (opcode === HALT);

endmodule
