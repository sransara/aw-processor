`include "pc_if.vh"
`include "cpu_types_pkg.vh"

module pc
import cpu_types_pkg::*;
(
  input logic CLK, nRST,
  pc_if.pci pcif
);

enum logic[1:0] {
  PC_BRZ  = 2'b10,
  PC_JR   = 2'b11,
  PC_JUMP = 2'b01,
  PC_NORM = 2'b00
} PcSrc;

word_t npc;
logic WEN, msb_imm;
logic [1:0] shift_two_zeroes;
assign pcif.pc_plus = pcif.cpc + WBYTES;
assign msb_imm = pcif.imm[IMM_W-1];
assign WEN = pcif.ihit & ~pcif.Halt;
assign shift_two_zeroes = '0;

always_ff @(posedge CLK, negedge nRST)
begin
  if(!nRST)
  begin
    pcif.cpc <= '0;
  end
  else if(WEN)
  begin
    pcif.cpc <= npc;
  end
end

always_comb
begin
    if(pcif.BrEq & pcif.alu_zero) PcSrc = PC_BRZ;
    else if(pcif.BrNeq & ~pcif.alu_zero) PcSrc = PC_BRZ;
    else if(pcif.RegToPc) PcSrc = PC_JR; // jump to register
    else if(pcif.Jump) PcSrc = PC_JUMP;
    else PcSrc = PC_NORM;

    casez(PcSrc)
      PC_BRZ:  begin
        // beq and a Z
        // bneq and a ~Z
        npc = pcif.pc_plus + { {IMM_W-2{msb_imm}}, pcif.imm, shift_two_zeroes };
      end
      PC_JR:  begin
        // Jr junior instruction - jump to register
        npc = pcif.rdat;
      end
      PC_JUMP:  begin
        // jump a cliff
        npc = { pcif.pc_plus[WORD_W-1:WORD_W-4], pcif.addr, shift_two_zeroes };
      end
      default:begin
        // act normal
        npc = pcif.pc_plus;
      end
    endcase
end

endmodule
