/*
  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"

module datapath
import cpu_types_pkg::*;
(
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
// pc init
parameter PC_INIT = 0;

register_file_if rfif();
decoder_if idecoded();
alu_if aluif();
pc_if pcif();
control_unit_if cuif();

// Definitions
opcode_t opcode;
assign idecoded.instruction = dpif.imemload;
assign opcode  = idecoded.opcode;

// Alu
logic msb_imm;
logic halt;
logic [IMM_W-1:0] immwzeroes;
logic [WORD_W-SHAM_W:0] shamzeroes;
aluop_t alu_op, alu_ftop;
assign msb_imm = idecoded.imm[IMM_W-1];
assign immwzeroes = '0;
assign shamzeroes = '0;

// MAPPINGS
request_unit RQU(
  .CLK(CLK), .nRST(nRST), .DatRead(cuif.DatRead), .DatWrite(cuif.DatWrite),
  .ihit(dpif.ihit), .dhit(dpif.dhit), .halt(dpif.halt),
  .ReqiREN(dpif.imemREN), .ReqdREN(dpif.dmemREN), .ReqdWEN(dpif.dmemWEN)
);
register_file RFU(CLK, nRST, rfif);
alu AU(aluif);
decoder DEC(idecoded);
pc #(.PC_INIT(PC_INIT)) PCU(.CLK(CLK), .nRST(nRST), .pcif(pcif));
control_unit CU(cuif);

assign dpif.imemaddr = pcif.cpc;
assign dpif.dmemaddr = aluif.out;
assign dpif.dmemstore = rfif.rdat2;

// pc glue
  assign pcif.imm = idecoded.imm;
  assign pcif.addr = idecoded.addr;
  assign pcif.ihit = dpif.ihit;
  assign pcif.alu_zero = aluif.zero;
  assign pcif.rdat = rfif.rdat1;
  assign pcif.BrEq = cuif.BrEq;
  assign pcif.BrNeq = cuif.BrNeq;
  assign pcif.RegToPc = cuif.RegToPc;
  assign pcif.Jump = cuif.Jump;
  assign pcif.Halt = dpif.halt;
// end pc glue

// control unit glue
  assign cuif.opcode = opcode;
  assign cuif.funct = idecoded.funct;
  assign halt = (cuif.Halt === 1);
  always_ff @(negedge CLK) begin
    if(dpif.halt === 0) begin
      dpif.halt <= halt;
    end
    else if(dpif.halt === 1) begin
      dpif.halt <= 1;
    end
    else begin
      dpif.halt <= 0;
    end
  end
// end cu glue

// reg file glue logic
  assign rfif.WEN = cuif.RegWr;
  assign rfif.rsel1 = idecoded.rs;
  assign rfif.rsel2 = idecoded.rt;
  always_comb
  begin
    rfif.wsel = idecoded.rt;
    if(cuif.RegDst)
      rfif.wsel = idecoded.rd;
    else if(cuif.Jal)
      rfif.wsel = 5'd31;
  end
  // wdat selector MUX
  always_comb
  begin
    rfif.wdat = aluif.out;
    if(cuif.PcToReg)
      rfif.wdat = pcif.pc_plus;
    else if(cuif.ImmToReg)
      // Zero padder
      rfif.wdat = word_t'({ idecoded.imm, immwzeroes});
    else if(cuif.MemToReg)
      rfif.wdat = dpif.dmemload;
  end
// end reg file glue

// alu glue logic
  assign aluif.port_a = rfif.rdat1;
  assign aluif.aluop = alu_op;

  // alu port_b select
  always_comb
  begin
    aluif.port_b = rfif.rdat2;
    if(cuif.ShamToAlu) begin
      aluif.port_b = word_t'({ shamzeroes, idecoded.shamt });
    end else if(cuif.ImmToAlu) begin
      if(cuif.ExtOp) begin
        // sign extend
        aluif.port_b = word_t'({ {IMM_W{msb_imm}}, idecoded.imm });
      end
      else begin
        // zero extend
        aluif.port_b = word_t'({ immwzeroes, idecoded.imm });
      end
    end
  end

  // alu control logic
  always_comb
  begin
    alu_op = ALU_ADD;
    casez (opcode)
      RTYPE:  alu_op = alu_ftop;
      ADDIU:  alu_op = ALU_ADD;
      ANDI:   alu_op = ALU_AND;
      ORI:    alu_op = ALU_OR;
      SLTI:   alu_op = ALU_SLT;
      SLTIU:  alu_op = ALU_SLTU;
      XORI:   alu_op = ALU_XOR;
      BEQ:    alu_op = ALU_SUB;
      BNE:    alu_op = ALU_SUB;
      SW:     alu_op = ALU_ADD;
      LW:     alu_op = ALU_ADD;
    endcase
  end

  // alu func_t to aluop_t
  always_comb
  begin
    alu_ftop = ALU_ADD;
    casez (idecoded.funct)
      SLL:  alu_ftop = ALU_SLL;
      SRL:  alu_ftop = ALU_SRL;
      ADD:  alu_ftop = ALU_ADD;
      ADDU: alu_ftop = ALU_ADD;
      SUB:  alu_ftop = ALU_SUB;
      SUBU: alu_ftop = ALU_SUB;
      AND:  alu_ftop = ALU_AND;
      OR:   alu_ftop = ALU_OR;
      XOR:  alu_ftop = ALU_XOR;
      NOR:  alu_ftop = ALU_NOR;
      SLT:  alu_ftop = ALU_SLT;
      SLTU: alu_ftop = ALU_SLTU;
    endcase
  end
// end alu glue

endmodule
