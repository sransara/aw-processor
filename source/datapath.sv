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
branch_predictor_if bpif();

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
  huif.ifid_FLUSH, huif.idex_FLUSH,
  ifid_n, idex_n, exmem_n, memwb_n,
  ifid, idex, exmem, memwb
);
branch_predictor BP(CLK, nRST, bpif);

// pipeline stuff
  // IF and D
  assign ifid_n.imemload = dpif.imemload;
  assign ifid_n.bp_hit = bpif.hit;
  assign ifid_n.cpc = pcif.cpc;
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
  assign idex_n.StoreConditional = cuif.StoreConditional;
  assign idex_n.LinkedLoad = cuif.LinkedLoad;
  assign idex_n.rdat1 = rfif.rdat1;
  assign idex_n.rdat2 = rfif.rdat2;

  assign idex_n.bp_hit = ifid.bp_hit;
  assign idex_n.cpc = ifid.cpc;
  assign idex_n.pc_plus = ifid.pc_plus;
  // end D and EX

  // EX and MEM
  assign exmem_n.aluout = aluif.out;

  assign exmem_n.imm = idex.imm;

  assign exmem_n.RegWr = idex.RegWr;
  assign exmem_n.DataRead = idex.DataRead & ~exmem.Halt;
  assign exmem_n.DataWrite = idex.DataWrite & ~exmem.Halt;
  assign exmem_n.ImmToReg = idex.ImmToReg;
  assign exmem_n.Jal = idex.Jal;
  assign exmem_n.Halt = idex.Halt;
  assign exmem_n.StoreConditional = idex.StoreConditional;
  assign exmem_n.LinkedLoad = idex.LinkedLoad;
  assign exmem_n.pc_plus = idex.pc_plus;
  // end EX and MEM

  // MEM and WB
  assign memwb_n.dmemload = dpif.dmemload;

  assign memwb_n.Halt = exmem.Halt;
  assign memwb_n.RegWr = exmem.RegWr;
  assign memwb_n.DataRead = exmem.DataRead;

  assign memwb_n.wdat = exmem_wdat;
  assign memwb_n.wsel = exmem.wsel;

  assign memwb_n.pc_plus = exmem.pc_plus;
  // end MEM and WB
// end pipeline stuff

// in general
  logic [IMM_W-1:0] immwzeroes;
  assign immwzeroes = '0;


// all about hazards
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
    regbits_t idex_wsel;
    word_t forward_a_data, forward_b_data;
    assign idex_n.forward_exmem_a = ~(instruction.rs == 0) & idex.RegWr & (instruction.rs == idex_wsel);
    assign idex_n.forward_memwb_a = ~(instruction.rs == 0) & exmem.RegWr & (instruction.rs == exmem.wsel);

    assign idex_n.forward_exmem_b = ~(instruction.rt == 0) & idex.RegWr & (instruction.rt == idex_wsel);
    assign idex_n.forward_memwb_b = ~(instruction.rt == 0) & exmem.RegWr & (instruction.rt == exmem.wsel);

    assign forward_a_data = (idex.forward_exmem_a ? exmem_wdat :
                              (idex.forward_memwb_a ? memwb_wdat : idex.rdat1));

    assign forward_b_data = (idex.forward_exmem_b ? exmem_wdat:
                              (idex.forward_memwb_b ? memwb_wdat : idex.rdat2));

  // set signals for exmem_n
    assign exmem_n.rdat2 = forward_b_data;
    assign idex_wsel = idex.RegDst ? idex.rd : (idex.Jal ? 5'd31 : idex.rt);
    assign exmem_n.wsel = idex_wsel;

  // alu glue logic
    logic [WORD_W-SHAM_W:0] shamzeroes;
    assign shamzeroes = '0;

    assign aluif.port_a = forward_a_data;
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
      else begin
        aluif.port_b = forward_b_data;
      end
    end
  // end alu glue
  // pc glue
    j_t jtype;
    logic equals;
    word_t pc_npc_branch, pc_npc_addr;
    assign jtype = dpif.imemload;
    assign equals = forward_a_data == forward_b_data;
    assign bpif.hash_sel = pcif.cpc[3:2];
    assign bpif.tag_sel = pcif.cpc[31:4];

    always_comb
    begin
        pc_npc_branch = idex.pc_plus + {{IMM_W-2{idex.imm[IMM_W-1]}}, idex.imm, 2'b0 };
        pc_npc_addr  = { pcif.pc_plus[WORD_W-1:WORD_W-4], jtype.addr, 2'b0 };
        huif.flushes = 2'b00;
        huif.npc_change = 1;

        // branch predict
        bpif.hash_wsel = idex.cpc[3:2];
        bpif.tag_n = idex.cpc[31:4];
        bpif.target_n = '0;
        bpif.active_n = 0;
        bpif.WEN = 0;

        if(((idex.BrEq & equals) || (idex.BrNeq & ~equals)) & ~idex.bp_hit) begin
          // branch predict
          bpif.target_n = pc_npc_branch[31:2];
          bpif.active_n = 1;
          bpif.WEN = 1;

          huif.npc_change = 1;
          pcif.npc = pc_npc_branch;
          huif.flushes = 2'b11;
        end
        else if(((idex.BrEq & ~equals) || (idex.BrNeq & equals)) & idex.bp_hit) begin
          // took the wrong turn at BTB buffer now time to go back
          // branch predict
          bpif.active_n = 0;
          bpif.WEN = 1;

          huif.npc_change = 1;
          pcif.npc = idex.pc_plus;
          huif.flushes = 2'b11;
        end
        else if(idex.Jr) begin
          pcif.npc = forward_a_data;
          huif.flushes = 2'b11;
        end
        else if(jtype.opcode === J || jtype.opcode === JAL) begin
          pcif.npc = pc_npc_addr;
          huif.npc_change = 0;
        end
        else begin
          pcif.npc = bpif.hit ? { bpif.target, 2'b0 } : pcif.pc_plus;
          huif.npc_change = 0;
        end
    end
  // end pc glue

  word_t rmwstate;
// MEM
  // wdat
    always_comb
    begin
      if(exmem.Jal) begin
        exmem_wdat = exmem.pc_plus;
      end
      else if(exmem.ImmToReg) begin
        // Zero padder
        exmem_wdat = word_t'({ exmem.imm, immwzeroes});
      end
      else if(exmem.StoreConditional) begin
          exmem_wdat = dpif.dmemload;
      end
      else begin
        exmem_wdat = exmem.aluout;
      end
    end

    assign dpif.datomic = exmem.StoreConditional | exmem.LinkedLoad;

  // datacache
    assign dpif.dmemaddr = exmem.aluout;
    assign dpif.dmemstore = exmem.rdat2;
    assign dpif.dmemWEN = exmem.DataWrite;
    assign dpif.dmemREN = exmem.DataRead;

// WB
  // datacache
    assign dpif.imemREN = ~memwb.Halt;
    assign dpif.halt = memwb.Halt;
    assign huif.dpif_halt = memwb.Halt;
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
