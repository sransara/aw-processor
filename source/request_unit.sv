`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"

module request_unit
import cpu_types_pkg::word_t;
(
  input logic CLK, nRST,
  request_unit_if.r ruif
);

assign ruif.req_iREN = 1 & ~ruif.halt;

always_ff @(posedge CLK, negedge nRST)
begin
  if(!nRST)
  begin
    ruif.req_dREN <= 0;
    ruif.req_dWEN <= 0;
  end
  else if(ruif.ihit)
  begin
    ruif.req_dREN <= ruif.DataRead;
    ruif.req_dWEN <= ruif.DataWrite;
  end
  else if(ruif.dhit)
  begin
    ruif.req_dREN <= 0;
    ruif.req_dWEN <= 0;
  end
end

endmodule
