`include "aww_types_pkg.vh"
module pipeline_reg
import aww_types_pkg::*;
(
  input logic CLK, nRST,
  input pipe_stall_t pipe_stall,
  input logic ifid_FLUSH, idex_FLUSH, exmem_FLUSH, memwb_FLUSH,
  input ifid_t ifid_n,
  input idex_t idex_n,
  input exmem_t exmem_n,
  input memwb_t memwb_n,
  output ifid_t ifid,
  output idex_t idex,
  output exmem_t exmem,
  output memwb_t memwb
);

always_ff @(posedge CLK, negedge nRST) begin
  if(~nRST) begin
    ifid  <= ifid_t'(0);
    idex  <= idex_t'(0);
    exmem <= exmem_t'(0);
    memwb <= memwb_t'(0);
  end
  else begin
    if(pipe_stall == IFID_STALL) begin
      ifid <= ifid_t'(0);
      if(idex_FLUSH) begin
        idex <= idex_t'(0);
      end
      else begin
        idex <= idex_n;
      end
      if (exmem_FLUSH) begin
        exmem <= exmem_t'(0);
      end
      else begin
        exmem <= exmem_n;
      end
      if (memwb_FLUSH) begin
        memwb <= memwb_t'(0);
      end
      else begin
        memwb <= memwb_n;
      end
    end
    else if (pipe_stall == IDEX_STALL) begin
      idex <= idex_t'(0);
      if (exmem_FLUSH) begin
        exmem <= exmem_t'(0);
      end
      else begin
        exmem <= exmem_n;
      end
      if (memwb_FLUSH) begin
        memwb <= memwb_t'(0);
      end
      else begin
        memwb <= memwb_n;
      end
    end
    else if(pipe_stall == NO_STALL) begin
      if(ifid_FLUSH) begin
        ifid <= ifid_t'(0);
      end
      else begin
        ifid <= ifid_n;
      end

      if(idex_FLUSH) begin
        idex <= idex_t'(0);
      end
      else begin
        idex <= idex_n;
      end

      if (exmem_FLUSH) begin
        exmem <= exmem_t'(0);
      end
      else begin
        exmem <= exmem_n;
      end

      if (memwb_FLUSH) begin
        memwb <= memwb_t'(0);
      end
      else begin
        memwb <= memwb_n;
      end
    end
    else begin // FULL_STALL aka WEN = 0
      ifid <= ifid;
      idex <= idex;
      exmem <= exmem;
      memwb <= memwb;
    end

  end

end

endmodule
