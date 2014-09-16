`include "decoder_if.vh"
`include "cpu_types_pkg.vh"

module decoder
import cpu_types_pkg::*;
(
  decoder_if.dif idecoded
);

// boundaries starting from LSB
localparam OPCODE_S = ADDR_W;
localparam OPCODE_E = OPCODE_S + OP_W - 1;
localparam FUNC_S = 0;
localparam FUNC_E = FUNC_S + FUNC_W - 1;
localparam SHAM_S = FUNC_E + 1;
localparam SHAM_E = SHAM_S + SHAM_W - 1;
localparam REG_D_S = SHAM_E + 1;
localparam REG_D_E = REG_D_S + REG_W - 1;
localparam REG_T_S = REG_D_E + 1;
localparam REG_T_E = REG_T_S + REG_W - 1;
localparam REG_S_S = REG_T_E + 1;
localparam REG_S_E = REG_S_S + REG_W - 1;
localparam IMM_S = 0;
localparam IMM_E = IMM_S + IMM_W - 1;
localparam ADDR_S = 0;
localparam ADDR_E = ADDR_S + ADDR_W - 1;


assign idecoded.opcode = opcode_t'(idecoded.instruction[OPCODE_E:OPCODE_S]);
assign idecoded.funct = funct_t'(idecoded.instruction[FUNC_E:FUNC_S]);
assign idecoded.shamt = idecoded.instruction[SHAM_E:SHAM_S];
assign idecoded.rd = idecoded.instruction[REG_D_E:REG_D_S];
assign idecoded.rt = idecoded.instruction[REG_T_E:REG_T_S];
assign idecoded.rs = idecoded.instruction[REG_S_E:REG_S_S];
assign idecoded.imm = idecoded.instruction[IMM_E:IMM_S];
assign idecoded.addr = idecoded.instruction[ADDR_E:ADDR_S];

endmodule
