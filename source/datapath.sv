/*
  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath
import cpu_types_pkg::*;
(
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
// pc init
parameter PC_INIT = 0;

union packed {
  r_t rtype;
  j_t jtype;
  i_t itype;
} idecoded_u;

register_file_if rfif();
control_unit_if cuif();
alu_if aluif();

// Definitions
  // PC
  word_t pc_cpc, pc_npc, pc_plus;
  logic pc_WEN;
  logic [1:0] PcSrc;

  //ALU glue
  aluop_t toAluop, toAluop_forr;

// MAPPINGS
control_unit CU(cuif);
pc PCU(.CLK(CLK), .nRST(nRST), .WEN(pc_WEN), .npc(pc_npc), .cpc(pc_cpc));
request_unit RQU(
  .CLK(CLK), .nRST(nRST), .DatRead(cuif.DatRead), .DatWrite(cuif.DatWrite),
  .ihit(dpif.ihit), .dhit(dpif.dhit),
  .ReqiREN(dpif.imemREN), .ReqdREN(dpif.dmemREN), .ReqdWEN(dpif.dmemWEN)
);
register_file RFU(CLK, nRST, rfif);
alu AU(aluif);


assign dpif.imemaddr = pc_cpc;
assign idecoded_u = dpif.imemload;
assign cuif.opcode = idecoded_u.rtype.opcode;
assign dpif.halt = cuif.Halt;

//Register file Glue logic
assign rfif.WEN = cuif.RegWr;
assign rfif.rsel1 = idecoded_u.rtype.rs;
assign rfif.rsel2 = idecoded_u.rtype.rt;
assign rfif.wsel = cuif.RegDst ? idecoded_u.rtype.rd : idecoded_u.rtype.rt;
always_comb
begin
  if(cuif.PcToReg)
    rfif.wdat = pc_plus;
  else if(cuif.ImmToReg)
    // Zero padder
    rfif.wdat = { idecoded_u.itype.imm16, {16{0}} }
  else if(cuif.MemToReg)
    rfif.wdat = dpif.dmemload;
  else
    rfif.wdat = aluif.out;
end
// ALU glue logic
assign aluif.port_a = rfif.rdat1;
always_comb
begin
  if(AluSrc == 2'b00) begin
    aluif.port_b = rfif.rdat2;
  end
  else if(AluSrc == 2'b01) begin
    aluif.port_b = idecoded_u.rtype.shamt;
  end
  else if(AluSrc == 2'b11
  if(cuif.ExtOp == 1) begin
    // Sign Extender
    aluif.port_b = { {16{idecoded_u.itype.imm[15]}, idecoded_u.itype.imm };
  end
  else begin
    // Zero Extended
    aluif.port_b = { {16{0}, idecoded_u.itype.imm };
  end
end
assign aluif.aluop = toAluop;
always_comb
begin
  casez (idecoded_u.rtype.opcode)
    RTYPE: begin
      toAluop = toAluop_forr;
    end
    ADDIU: begin
      toAluop: ALU_ADD;
    end
    ANDI: begin
      toAluop: ALU_AND;
    end
    ORI: begin
      toAluop: ALU_OR;
    end
    SLTI: begin
      toAluop: ALU_SLT;
    end
    SLTIU: begin
      toAluop: ALU_SLT;
    end
    BEQ,
    BNEQ: begin
      toAluop: ALU_SUB;
    default: begin
      toAluop = ALU_ADD;
    end
  endcase
end
always_comb
begin
  casez (idecoded_u.rtype.funct)
    SLL:  toAluop_forr = ALU_SLL;
    SRL:  toAluop_forr = ALU_SRL;
    ADD,
    ADDU: toAluop_forr = ALU_ADD;
    SUB,
    SUBU: toAluop_forr = ALU_SUB;
    AND:  toAluop_forr = ALU_AND;
    OR:   toAluop_forr = ALU_OR;
    XOR:  toAluop_forr = ALU_XOR;
    NOR:  toAluop_forr = ALU_NOR;
    SLT:  toAluop_forr = ALU_SLT;
    SLTU: toAluop_forr = ALU_SLTU;
    default: toAluop_forr = ALU_ADD;
  endcase
end
// END ALU glue

// PC Glue Logic
assign PcSrc = { ((cuif.BrEq & aluif.zero) || (cuif.BrNeq & ~aluif.zero) || cuif.Jr) , (cuif.Jump || cuif.Jr) };
assign pc_plus = pc_cpc + WBYTES;
assign pc_WEN = dpif.ihit & ~cuif.Halt;

always_comb
begin
    casez(PcSrc)
      2'b10:  begin
        // beq and a Z
        // bneq and a ~Z
        pc_npc = pc_cpc + $signed(idecoded_u.itype.imm << 2);
      end
      2'b11:  begin
        // Jr junior instruction
        pc_npc = rfif.rdat1;
      end
      2'b01:  begin
        // jump a cliff
        pc_npc = { pc_plus[31:28], idecoded_u.jtype.addr, {2{0}} };
      end
      default:begin
        // act normal
        pc_npc = pc_plus;
      end
    endcase
end

// End PC glue logic
endmodule
