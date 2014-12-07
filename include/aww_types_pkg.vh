/*
  more types used to make life easier.
*/
`ifndef AWW_TYPES_PKG_VH
`define AWW_TYPES_PKG_VH
`include "cpu_types_pkg.vh"
package aww_types_pkg;
  import cpu_types_pkg::*;

  // IF | ID
  typedef struct packed {

    // from Cache
    word_t imemload;
    word_t pc_plus;

  } ifid_t;

  // ID | EX
  typedef struct packed {
    logic forward_exmem_a;
    logic forward_memwb_a;

    logic forward_exmem_b;
    logic forward_memwb_b;

    // from idecoded.(Rs | Rt)
    regbits_t rs;
    regbits_t rt;
    regbits_t rd;
    funct_t funct;
    logic [SHAM_W-1:0] shamt;
    logic [IMM_W-1:0] imm;
    logic [ADDR_W-1:0] addr;

    // from Control
    aluop_t aluop;
    logic RegDst;
    logic RegWr;
    logic ExtOp;
    logic ShamToAlu;
    logic ImmToAlu;
    logic ImmToReg;
    logic DataRead;
    logic DataWrite;
    logic BrEq;
    logic BrNeq;
    logic Jump;
    logic Jal;
    logic Jr;
    logic Halt;
    logic LinkedLoad;
    logic StoreConditional;

    // from Register
    word_t rdat1;
    word_t rdat2;

    // Revenge of the fallen from IF|ID
    word_t pc_plus;

  } idex_t;

  // EX | MEM
  typedef struct packed {

    // from Alu
    word_t aluout;

    // Revenge of the fallen from ID | EX
    logic [IMM_W-1:0] imm;

    logic RegWr;
    logic DataRead;
    logic DataWrite;
    logic ImmToReg;
    logic Jal;
    logic Halt;
    logic LinkedLoad;
    logic StoreConditional;
    word_t rdat2;

    regbits_t wsel; // mux output for wsel

    // Revenge of the fallen from IF|ID
    word_t pc_plus;

  } exmem_t;

  // MEM | WB
  typedef struct packed {

    // from cache
    word_t dmemload;

    // Revenge of the fallen from ID | EX
    logic Halt;
    logic RegWr;
    logic DataRead;

    // Revenge of the fallen from EX | MEM
    word_t wdat;
    regbits_t wsel; // mux output for wsel

    // Revenge of the fallen from IF|ID
    word_t pc_plus;

  } memwb_t;

  typedef enum logic [2:0] {
    NO_STALL,
    IFID_STALL,
    IDEX_STALL,
    FULL_STALL
  } pipe_stall_t;

endpackage
`endif //AWW_TYPES_PKG_VH
