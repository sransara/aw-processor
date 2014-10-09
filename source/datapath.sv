/*
  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
`include "aww_types_pkg.vh"

module datapath
import cpu_types_pkg::*, aww_types_pkg::*;
(
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
// pc init
parameter PC_INIT = 0;

// All the kings horses
ifid_t  ifid, ifid_n;
idex_t  idex, idex_n;
exmem_t exmem, exmem_n;
memwb_t memwb, memwb_n;
word_t exmem_wdat, memwb_wdat;

hazard_unit_if huif();
register_file_if rfif();
alu_if aluif();
decoder_if instruction();
pc_if pcif();
control_unit_if cuif();

// MAPPINGS
register_file RFU(.CLK(CLK), .nRST(nRST), .rfif(rfif));
alu AU(aluif);
decoder DEC(instruction);
pc #(.PC_INIT(PC_INIT)) PCU(.CLK(CLK), .nRST(nRST), .pcif(pcif));
control_unit CU(cuif);
hazard_unit HUZ(huif);
pipeline_reg PIPER (
  CLK, nRST,
  huif.npipe_stall,
  huif.ifid_FLUSH, huif.idex_FLUSH, huif.exmem_FLUSH, huif.memwb_FLUSH,
  ifid_n, idex_n, exmem_n, memwb_n,
  ifid, idex, exmem, memwb
);

// branch_predictor BP ( .CLK(CLK), .nRST(nRST), .branch_taken(branch_taken), .target_addr(target_addr), .current_addr(current_addr), .

// pipeline stuff
  // IF and D
  assign ifid_n.imemload = dpif.imemload;
  assign ifid_n.pc_plus = pcif.pc_plus;
  // end IF and D

  // D and EX
  assign idex_n.rs = instruction.rs;
  assign idex_n.rt = instruction.rt;
  assign idex_n.rd = instruction.rd;
  assign idex_n.funct = instruction.funct;
  assign idex_n.shamt = instruction.shamt;
  assign idex_n.imm = instruction.imm;
  assign idex_n.addr = instruction.addr;

  assign idex_n.aluop = cuif.aluop;
  assign idex_n.RegDst = cuif.RegDst;
  assign idex_n.RegWr = cuif.RegWr;
  assign idex_n.ExtOp = cuif.ExtOp;
  assign idex_n.ShamToAlu = cuif.ShamToAlu;
  assign idex_n.ImmToAlu = cuif.ImmToAlu;
  assign idex_n.ImmToReg = cuif.ImmToReg;
  assign idex_n.DataRead = cuif.DataRead;
  assign idex_n.DataWrite = cuif.DataWrite;
  assign idex_n.BrEq = cuif.BrEq;
  assign idex_n.BrNeq = cuif.BrNeq;
  assign idex_n.Jump = cuif.Jump;
  assign idex_n.Jal = cuif.Jal;
  assign idex_n.Jr = cuif.Jr;
  assign idex_n.Halt = cuif.Halt;

  assign idex_n.rdat1 = rfif.rdat1;
  assign idex_n.rdat2 = rfif.rdat2;

  assign idex_n.pc_plus = ifid.pc_plus;
  // end D and EX

  // EX and MEM
  assign exmem_n.aluout = aluif.out;
  assign exmem_n.zero = aluif.zero;

  assign exmem_n.imm = idex.imm;

  assign exmem_n.RegWr = idex.RegWr;
  assign exmem_n.DataRead = idex.DataRead;
  assign exmem_n.DataWrite = idex.DataWrite;
  assign exmem_n.ImmToReg = idex.ImmToReg;
  assign exmem_n.BrEq = idex.BrEq;
  assign exmem_n.BrNeq = idex.BrNeq;
  assign exmem_n.Jump = idex.Jump;
  assign exmem_n.Jr = idex.Jr;
  assign exmem_n.Jal = idex.Jal;
  assign exmem_n.Halt = idex.Halt;

  assign exmem_n.rdat1 = idex.rdat1;

  assign exmem_n.pc_plus = idex.pc_plus;
  // end EX and MEM

  // MEM and WB
  assign memwb_n.dmemload = dpif.dmemload;

  assign memwb_n.imm = exmem.imm;

  assign memwb_n.RegWr = exmem.RegWr;
  assign memwb_n.DataRead = exmem.DataRead;
  assign memwb_n.ImmToReg = exmem.ImmToReg;
  assign memwb_n.Jal = exmem.Jal;

  assign memwb_n.wdat = exmem_wdat;
  assign memwb_n.wsel = exmem.wsel;
  assign memwb_n.Halt = exmem.Halt;

  assign memwb_n.pc_plus = exmem.pc_plus;
  // end MEM and WB
// end pipeline stuff

// in general
  logic [IMM_W-1:0] immwzeroes;
  assign immwzeroes = '0;


// all about hazards
  //assign pipe_WEN = dpif.dhit | dpif.ihit;
  //assign ifid_WEN = dpif.ihit;
  //assign ifid_FLUSH = dpif.dhit | idex.Halt;
  assign huif.dpif_ihit = dpif.ihit;
  assign huif.dpif_dhit = dpif.dhit;
  assign huif.idex_Halt = idex.Halt;
  assign huif.idex_DataRead = idex.DataRead;
  assign huif.idex_rt = idex.rt;
  assign huif.ifid_rs = instruction.rs;
  assign huif.ifid_rt = instruction.rt;
  assign huif.exmem_datarequest = exmem.DataRead | exmem.DataWrite;

  assign pcif.WEN = huif.pc_WEN;

// IF
  assign dpif.imemaddr = pcif.cpc;

// ID
  assign instruction.load = ifid.imemload;
  // reg file glue logic
    assign rfif.rsel1 = instruction.rs;
    assign rfif.rsel2 = instruction.rt;
  // end reg file glue
  assign cuif.opcode = instruction.opcode;
  assign cuif.funct = instruction.funct;

// EX
  // forward
    logic forward_a, forward_b;
    word_t forward_a_data, forward_b_data;
    assign forward_a = (idex.rs == 0) |
                       (exmem.RegWr & (idex.rs == exmem.wsel)) |
                       (memwb.RegWr & (idex.rs == memwb.wsel)) ;

    assign forward_b = (idex.rt == 0) |
                       (exmem.RegWr & (idex.rt == exmem.wsel)) |
                       (memwb.RegWr & (idex.rt == memwb.wsel)) ;

    assign forward_a_data = ((exmem.RegWr & (idex.rs == exmem.wsel)) ? exmem_wdat :
                              ((memwb.RegWr & (idex.rs == memwb.wsel)) ? memwb_wdat : 0));

    assign forward_b_data = ((exmem.RegWr & (idex.rt == exmem.wsel)) ? exmem_wdat:
                              ((memwb.RegWr & (idex.rt == memwb.wsel)) ? memwb_wdat : 0));

  // set signals for exmem_n
    assign exmem_n.rdat2 = forward_b ? forward_b_data : idex.rdat2;
    assign exmem_n.wsel = idex.RegDst ? idex.rd : (idex.Jal ? 5'd31 : idex.rt);

  // alu glue logic
    logic [WORD_W-SHAM_W:0] shamzeroes;
    assign shamzeroes = '0;

    assign aluif.port_a = forward_a ? forward_a_data : idex.rdat1;
    assign aluif.aluop = idex.aluop;

    // alu port_b select
    always_comb
    begin
      if(idex.ShamToAlu) begin
        aluif.port_b = word_t'({ shamzeroes, idex.shamt });
      end else if(idex.ImmToAlu) begin
        if(idex.ExtOp) begin
          // sign extend
          aluif.port_b = word_t'({{IMM_W{idex.imm[IMM_W-1]}}, idex.imm });
        end
        else begin
          // zero extend
          aluif.port_b = word_t'({ immwzeroes, idex.imm });
        end
      end
      else if(forward_b) begin
        aluif.port_b = forward_b_data;
      end else begin
        aluif.port_b = idex.rdat2;
      end
    end
  // end alu glue
  // pc glue
    word_t pc_npc_branch, pc_npc_addr;
    always_comb
    begin
        pc_npc_branch = idex.pc_plus + {{IMM_W-2{idex.imm[IMM_W-1]}}, idex.imm, 2'b0 };
        pc_npc_addr  = { ifid.pc_plus[WORD_W-1:WORD_W-4], instruction.addr, 2'b0 };
        huif.flushes = 4'b0000;
        huif.npc_change = 1;

        if((idex.BrEq & aluif.zero) || (idex.BrNeq & ~aluif.zero)) begin
          pcif.npc = pc_npc_branch;
          huif.flushes = 4'b1100;
        end
        else if(idex.Jr) begin
          pcif.npc = forward_a ? forward_a_data : idex.rdat1;
          huif.flushes = 4'b1100;
        end
        else if(cuif.Jump) begin
          pcif.npc = pc_npc_addr;
          huif.flushes = 4'b1000;
        end
        else begin
          pcif.npc = pcif.pc_plus;
          huif.npc_change = 0;
        end
    end
  // end pc glue

// MEM
  // wdat
    always_comb
    begin
      if(exmem.Jal)
        exmem_wdat = exmem.pc_plus;
      else if(exmem.ImmToReg)
        // Zero padder
        exmem_wdat = word_t'({ exmem.imm, immwzeroes});
      else
        exmem_wdat = exmem.aluout;
    end

  // datacache
    assign dpif.dmemaddr = exmem.aluout;
    assign dpif.dmemstore = exmem.rdat2;
    assign dpif.dmemWEN = exmem.DataWrite;
    assign dpif.dmemREN = exmem.DataRead;

// WB
  // datacache
    assign dpif.imemREN = ~memwb.Halt;
    assign dpif.halt = memwb.Halt;
  // reg file glue logic - writes
    assign rfif.wsel = memwb.wsel;
    assign rfif.WEN = memwb.RegWr;
    assign rfif.wdat = memwb_wdat;
    // wdat selector MUX
    always_comb
    begin
      if(memwb.DataRead)
        memwb_wdat = memwb.dmemload;
      else
        memwb_wdat = memwb.wdat;
    end

endmodule
