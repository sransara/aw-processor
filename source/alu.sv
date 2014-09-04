`include "alu_if.vh"
`include "cpu_types_pkg.vh"

module alu
import cpu_types_pkg::*;
(
  alu_if.ai aluif
);

logic msb_a, msb_b, msb_o;
assign aluif.negative = (aluif.out[WORD_W-1] == 1);
assign aluif.zero = (aluif.out == 0);
assign msb_a = aluif.port_a[WORD_W - 1];
assign msb_b = aluif.port_b[WORD_W - 1];
assign msb_o = aluif.out[WORD_W - 1];

always_comb
begin
  aluif.out = '0;
  aluif.overflow = 1'b0;
  casez (aluif.aluop)
    ALU_SLL : aluif.out = (aluif.port_a << aluif.port_b);
    ALU_SRL : aluif.out = (aluif.port_a >> aluif.port_b);
    ALU_ADD : begin
              aluif.out = ($signed(aluif.port_a) +  $signed(aluif.port_b));
              aluif.overflow = (msb_a == msb_b) ? (msb_a != msb_o) : 0;
              end
    ALU_SUB : begin
              aluif.out = ($signed(aluif.port_a) -  $signed(aluif.port_b));
              aluif.overflow = (msb_a == ~msb_b) ? (msb_a != msb_o) : 0;
              end
    ALU_AND : aluif.out = (aluif.port_a &  aluif.port_b);
    ALU_OR  : aluif.out = (aluif.port_a |  aluif.port_b);
    ALU_XOR : aluif.out = (aluif.port_a ^  aluif.port_b);
    ALU_NOR : aluif.out = ~(aluif.port_a | aluif.port_b);
    ALU_SLT : aluif.out = ($signed(aluif.port_a) <  $signed(aluif.port_b));
    ALU_SLTU: aluif.out = (aluif.port_a <  aluif.port_b);
  endcase
end

endmodule
