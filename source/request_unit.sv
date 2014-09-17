`include "cpu_types_pkg.vh"

module request_unit
import cpu_types_pkg::word_t;
(
  input logic CLK, nRST,
  input logic DatRead, DatWrite,
  input logic ihit, dhit, halt,
  output logic ReqiREN, ReqdREN, ReqdWEN
);

logic InsRead;
assign InsRead = 1 & ~halt;
assign ReqiREN = InsRead;

always_ff @(posedge CLK, negedge nRST)
begin
  if(!nRST)
  begin
    ReqdREN <= 0;
    ReqdWEN <= 0;
  end
  else if(ihit)
  begin
    ReqdREN <= DatRead;
    ReqdWEN <= DatWrite;
  end
  else if(dhit)
  begin
    ReqdREN <= 0;
    ReqdWEN <= 0;
  end
end

endmodule
