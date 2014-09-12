`include "cpu_types_pkg.vh"

module pc
import cpu_types_pkg::*;
(
  input logic CLK, nRST,
  input logic WEN,
  input word_t npc,
  output word_t cpc
);


always_ff @(posedge CLK, negedge nRST)
begin
  if(!nRST)
  begin
    cpc <= '0;
  end
  else if(WEN)
  begin
    cpc <= npc;
  end
end

endmodule
