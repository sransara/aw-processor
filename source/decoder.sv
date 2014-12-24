`include "decoder_if.vh"
`include "cpu_types_pkg.vh"

module decoder
import cpu_types_pkg::*;
(
  decoder_if.dif instruction
);

r_t rtype;
i_t itype;
j_t jtype;

assign rtype = instruction.load;
assign itype = instruction.load;
assign jtype = instruction.load;

assign instruction.opcode = rtype.opcode;
assign instruction.funct = rtype.funct;
assign instruction.shamt = rtype.shamt;
assign instruction.rd = rtype.rd;
assign instruction.rt = rtype.rt;
assign instruction.rs = rtype.rs;
assign instruction.imm = itype.imm;
assign instruction.addr = jtype.addr;

endmodule
