`include "decoder_if.vh"
`include "cpu_types_pkg.vh"

module decoder
import cpu_types_pkg::*;
(
  decoder_if.dif idecoded
);

r_t rtype;
i_t itype;
j_t jtype;

assign rtype = idecoded.instruction;
assign itype = idecoded.instruction;
assign jtype = idecoded.instruction;

assign idecoded.opcode = rtype.opcode;
assign idecoded.funct = rtype.funct;
assign idecoded.shamt = rtype.shamt;
assign idecoded.rd = rtype.rd;
assign idecoded.rt = rtype.rt;
assign idecoded.rs = rtype.rs;
assign idecoded.imm = itype.imm;
assign idecoded.addr = jtype.addr;

endmodule
