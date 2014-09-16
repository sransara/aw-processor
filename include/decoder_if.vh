`ifndef DECODER_IF
`define DECODER_IF

// all types
`include "cpu_types_pkg.vh"

interface decoder_if;
  // import types
  import cpu_types_pkg::*;

  word_t instruction;
  opcode_t opcode;
  funct_t funct;
  regbits_t rs, rd, rt;
  logic [ADDR_W-1:0] addr;
  logic [IMM_W-1:0] imm;
  logic [SHAM_W-1:0] shamt;

  // alu ports
  modport dif (
    input   instruction,
    output  opcode, funct, rs, rd, rt, addr, imm, shamt
  );
endinterface

`endif //ALU_IF
