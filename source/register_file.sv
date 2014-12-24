`include "register_file_if.vh"
`include "cpu_types_pkg.vh"

module register_file
import cpu_types_pkg::word_t;
(
  input logic CLK, nRST,
  register_file_if.rf rfif
);

word_t register[31:0];

always_ff @(negedge CLK, negedge nRST)
begin
  if(!nRST)
  begin
    register <= '{default:32'b0};
  end
  else if(rfif.WEN)
  begin
    register[rfif.wsel] <= (rfif.wsel == 0) ? 0 : rfif.wdat;
  end
end

assign rfif.rdat1 = register[rfif.rsel1];
assign rfif.rdat2 = register[rfif.rsel2];

endmodule
