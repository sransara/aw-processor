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
request_unit_if ruif();
control_unit_if cuif();

// MAPPINGS
request_unit RQU(.CLK(CLK), .nRST(nRST), .ruif(ruif));
register_file RFU(.CLK(CLK), .nRST(nRST), .rfif(rfif));
alu AU(aluif);
decoder DEC(idecoded);
pc #(.PC_INIT(PC_INIT)) PCU(.CLK(CLK), .nRST(nRST), .pcif(pcif));
control_unit CU(cuif);

// datapath
  assign idecoded.instruction = dpif.imemload;
  assign dpif.imemaddr = pcif.cpc;
  assign dpif.dmemaddr = aluif.out;
  assign dpif.dmemstore = rfif.rdat2;
// end datapath

// request unit
  assign ruif.DataRead = cuif.DataRead;
  assign ruif.DataWrite = cuif.DataWrite;
  assign ruif.ihit = dpif.ihit;
  assign ruif.dhit = dpif.dhit;
  assign ruif.halt = dpif.halt;
  assign dpif.imemREN = ruif.req_iREN;
  assign dpif.dmemREN = ruif.req_dREN;
  assign dpif.dmemWEN = ruif.req_dWEN;
// end request unit

// general
logic msb_imm;
assign msb_imm = idecoded.imm[IMM_W-1];

// pc glue
  assign pcif.wen = dpif.ihit;

  always_comb
  begin
      if((cuif.BrEq & aluif.zero) || (cuif.BrNeq & ~aluif.zero)) begin
        pcif.npc = pcif.pc_plus + { {IMM_W-2{msb_imm}}, idecoded.imm, 2'b0 };
      end
      else if(cuif.RegToPc) begin
        pcif.npc = rfif.rdat1;
      end
      else if(cuif.Jump) begin
        pcif.npc = { pcif.pc_plus[WORD_W-1:WORD_W-4], idecoded.addr, 2'b0 };
      end
      else begin
        pcif.npc = pcif.pc_plus;
      end
  end
// end pc glue

// control unit glue
  logic halt;

  assign cuif.opcode = idecoded.opcode;
  assign cuif.funct = idecoded.funct;
  assign halt = (cuif.Halt === 1);

  always_ff @(negedge CLK or negedge nRST) begin
    if(~nRST) begin
      dpif.halt <= 0;
    end
    else if(dpif.halt === 0) begin
      dpif.halt <= halt;
    end
  end
// end cu glue

// reg file glue logic
  logic [IMM_W-1:0] immwzeroes;
  assign immwzeroes = '0;

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
    if(cuif.Jal)
      rfif.wdat = pcif.pc_plus;
    else if(cuif.ImmToReg)
      // Zero padder
      rfif.wdat = word_t'({ idecoded.imm, immwzeroes});
    else if(cuif.DataRead)
      rfif.wdat = dpif.dmemload;
  end
// end reg file glue

// alu glue logic
  logic [WORD_W-SHAM_W:0] shamzeroes;
  assign shamzeroes = '0;

  assign aluif.port_a = rfif.rdat1;
  assign aluif.aluop = cuif.aluop;

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
// end alu glue

endmodule
