`include "aww_types_pkg.vh"
module pipeline_reg
import aww_types_pkg::*;
(
  input logic CLK, nRST, WEN,
  input logic ifid_WEN, ifid_FLUSH,
  input   ifid_t ifid_n,
  input   idex_t idex_n,
  input   exmem_t exmem_n,
  input   memwb_t memwb_n,
  output  ifid_t ifid,
  output  idex_t idex,
  output  exmem_t exmem,
  output  memwb_t memwb
);

always_ff @(posedge CLK, negedge nRST) begin
  if(~nRST) begin
    ifid  <= ifid_t'(0);
    idex  <= idex_t'(0);
    exmem <= exmem_t'(0);
    memwb <= memwb_t'(0);
  end
  else begin

    if(WEN) begin
      idex <= idex_n;
      exmem <= exmem_n;
      memwb <= memwb_n;
    end
    if(ifid_WEN) begin
      ifid <= ifid_n;
    end
    else if(ifid_FLUSH) begin
      ifid  <= ifid_t'(0);
    end

  end

end

endmodule
