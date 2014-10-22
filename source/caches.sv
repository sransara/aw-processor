/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


module caches (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  cache_control_if.caches ccif
);
  parameter CPUID = 0;

  typedef enum bit [2:0]{IDLE, DACCESS, IACCESS, IHIT, DHIT} stateType;
  stateType state;
  stateType nextstate;

  // icache
  icache  ICACHE(dcif, ccif);
  // dcache
  dcache  DCACHE(dcif, ccif);

  // dcache invalidate before halt handled by dcache when exists
  assign dcif.flushed = dcif.halt;

  //singlecycle
  //assign dcif.ihit = (dcif.imemREN) ? ~ccif.iwait[CPUID] : 0;
  //assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~ccif.dwait[CPUID] : 0;
  
  //assign dcif.imemload = ccif.iload[CPUID];
  //assign dcif.dmemload = ccif.dload[CPUID];
  //assign ccif.iREN[CPUID] = dcif.imemREN;
  //assign ccif.dREN[CPUID] = dcif.dmemREN;
  //assign ccif.dWEN[CPUID] = dcif.dmemWEN;

  assign ccif.dstore[CPUID] = dcif.dmemstore;
  assign ccif.iaddr[CPUID] = dcif.imemaddr;
  assign ccif.daddr[CPUID] = dcif.dmemaddr;

  //STATE MACHINE//
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST == 0) begin
      state <= IDLE;
    end
    else begin
      state <= nextstate;
    end
  end

  always_comb begin
    casez(state)
      IDLE: begin
        if(~dcif.halt && (dcif.dmemREN || dcif.dmemWEN)) begin
          nextstate = DACCESS;
        end
        else if (~dcif.halt && dcif.imemREN ) begin
          nextstate = IACCESS;
        end
        else begin
          nextstate = IDLE;
        end
      end
      IACCESS: begin
        if(ccif.iREN[CPUID] == 0) begin
          nextstate = IHIT;
        end
        else begin
          nextstate = IACCESS;
        end
      end
      IHIT: begin
        nextstate = IDLE;
      end
      DACCESS: begin
        if((~ccif.dREN[CPUID] && dcif.dmemREN) || (~ccif.dWEN[CPUID] && dcif.dmemWEN)) begin
          nextstate = DHIT;
        end
        else begin
          nextstate = DACCESS;
        end
      end
      DHIT: begin
        nextstate = IDLE;
      end
      default : nextstate = IDLE;
    endcase
  end

  always_comb begin
    casez(state)
      IDLE: begin
        dcif.dhit = 0;
        dcif.ihit = 0;
      end
      IACCESS: begin
        dcif.dhit = 0;
        dcif.ihit = 0;
      end
      IHIT: begin
        dcif.dhit = 0;
        dcif.ihit = 1;
      end
      DACCESS: begin
        dcif.dhit = 0;
        dcif.ihit = 0;
      end
      DHIT: begin
        dcif.dhit = 1;
        dcif.ihit = 0;
      end
      default: begin
        dcif.dhit = 0;
        dcif.ihit = 0;
      end
    endcase
  end


endmodule
