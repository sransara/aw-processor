/*
  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;
  // parameter CPUID = 0;
  typedef enum bit [3:0] {
    IDLE,
    INVALID_1, SEND_1, READ_1, SNOOP_1,
    INVALID_0, SEND_0, READ_0, SNOOP_0,
    FLUSH_0, FLUSH_1, INSTR_0, INSTR_1
  } state_t;

  state_t state;
  state_t nstate;
  //logic [1:0] pep_0;
  //logic [1:0] pep_1;
  //logic priority_bit, n_priority_bit;
  //logic [4:0] master_priority;
//  assign pep_0 = { ccif.dREN[0] || ccif.dWEN[0], ccif.iREN[0] };
//  assign pep_1 = { ccif.dREN[1] || ccif.dWEN[1], ccif.iREN[1] };
//  assign master_priority = { priority_bit, pep_0, pep_1};

  always_ff@(posedge CLK, negedge nRST) begin
    if(~nRST) begin
  //    priority_bit <= 0;
      state <= IDLE;
    end
    else begin
    //  priority_bit <= n_priority_bit;
      state <= nstate;
    end
  end


  always_comb begin
    casez(state)
      IDLE: begin
        if(ccif.cctrans[0] && ccif.ccwrite[0]) begin
          nstate = INVALID_1;
        end
        else if(ccif.cctrans[0] && ~ccif.ccwrite[0]) begin
          nstate = SNOOP_1;
        end
        else if(ccif.cctrans[1] && ccif.ccwrite[1]) begin
          nstate = INVALID_0;
        end
        else if(ccif.cctrans[1] && ~ccif.ccwrite[1]) begin
          nstate = SNOOP_0;
        end
        else if(~ccif.cctrans[0] && ccif.dWEN[0]) begin
          nstate = FLUSH_0;
        end
        else if(~ccif.cctrans[1] && ccif.dWEN[1]) begin
          nstate = FLUSH_1;
        end
        else if(~ccif.cctrans[0] && ccif.iREN[0]) begin
          nstate = INSTR_0;
        end
        else begin
          nstate = IDLE;
        end
      end
      INVALID_1: begin // servicing cahce 0, invalidate 1
        if(ccif.cctrans[1] && ccif.ccwrite[1]) begin
          nstate = SEND_1;
        end
        else if(~ccif.ccwrite[1]) begin
          nstate = READ_1;
        end
        else begin
          nstate = INVALID_1;
        end
      end
      SEND_1: begin
        if(ccif.dWEN[1]) begin
          nstate = SEND_1;
        end
        else begin
          nstate = IDLE;
        end
      end
      READ_1: begin
        if(ccif.dREN[0]) begin
          nstate = READ_1;
        end
        else begin
          nstate = IDLE;
        end
      end
      SNOOP_1: begin
        if(ccif.cctrans[1]) begin
          nstate = SEND_1;
        end
        else begin
          nstate = READ_1;
        end
      end
      INVALID_0: begin
        if(ccif.cctrans[0] && ccif.ccwrite[0]) begin
          nstate = SEND_0;
        end
        else if(ccif.cctrans[0] && ~ccif.ccwrite[0]) begin
          nstate = READ_0;
        end
        else begin
          nstate = INVALID_0;
        end
      end
      SEND_0: begin
        if(ccif.dWEN[1]) begin
          nstate = SEND_0;
        end
        else begin
          nstate = IDLE;
        end
      end
      READ_0: begin
        if(ccif.dREN[1]) begin
          nstate = READ_0;
        end
        else begin
          nstate = IDLE;
        end
      end
      SNOOP_0: begin
        if(ccif.cctrans[0]) begin
          nstate = SEND_0;
        end
        else begin
          nstate = READ_0;
        end
      end
      FLUSH_0: begin
        if(ccif.dWEN[0]) begin
          nstate = FLUSH_0;
        end
        else begin
          nstate = IDLE;
        end
      end
      FLUSH_1: begin
        if(ccif.dWEN[1]) begin
          nstate = FLUSH_1;
        end
        else begin
          nstate = IDLE;
        end
      end
      INSTR_0: begin
        if(ccif.ramstate == ACCESS) begin
          if(~ccif.dWEN[1] && ~ccif.dREN[1] && ccif.iREN[1]) begin
            nstate = INSTR_1;
          end
          else begin
            nstate = IDLE;
          end
        end
        else begin
          nstate = INSTR_0;
        end
      end
      INSTR_1: begin
        if(ccif.iREN[1]) begin
          nstate = IDLE;
        end
        else begin
          nstate = INSTR_1;
        end
      end
      default: begin
        nstate = IDLE;
      end
    endcase
  end
  always_comb begin
    ccif.ccwait[0] = 0;
    ccif.ccwait[1] = 0;
    ccif.ramstore = 0;
    ccif.ramaddr = 0;
    ccif.ramWEN = 0;
    ccif.ramREN = 0;
    ccif.dload[0] = 0;
    ccif.dload[1] = 0;
    ccif.iload[0] = 0;
    ccif.iload[1] = 0;
    ccif.dwait[0] = 1;
    ccif.dwait[1] = 1;
    ccif.iwait[0] = 1;
    ccif.iwait[1] = 1;
    ccif.ccinv[0] = 0;
    ccif.ccinv[1] = 0;
    ccif.ccsnoopaddr[0] = 0;
    ccif.ccsnoopaddr[1] = 0;

    casez(state)
      IDLE: begin
        ccif.iwait[0] = 1;
        ccif.iwait[1] = 1;
      end
      INVALID_1: begin
        ccif.ccwait[1] = 1;
        ccif.ccinv[1] = 1;
        ccif.ccsnoopaddr[1] = ccif.daddr[0];
      end
      SEND_1: begin
        ccif.ccwait[1] = 1;
        ccif.ramstore = ccif.dstore[1];
        ccif.ramaddr = ccif.daddr[1];
        ccif.ramWEN = 1;
        ccif.dload[0] = ccif.dstore[1];
        ccif.dwait[0] = ~(ccif.ramstate == ACCESS);
      end
      READ_1: begin
        ccif.ramREN = 1;
        ccif.ramaddr = ccif.daddr[0];
        ccif.dload[0] = ccif.ramload;
        ccif.dwait[0] = ~(ccif.ramstate == ACCESS);
      end
      SNOOP_1: begin
        ccif.ccsnoopaddr[1] = ccif.daddr[0];
        ccif.ccwait[1] = 1;
      end
      INVALID_0: begin
        ccif.ccwait[0] = 1;
        ccif.ccinv[0] = 1;
        ccif.ccsnoopaddr[0] = ccif.daddr[1];
      end
      SEND_0: begin
        ccif.ccwait[0] = 1;
        ccif.ramstore = ccif.dstore[0];
        ccif.ramaddr = ccif.daddr[0];
        ccif.ramWEN = 1;
        ccif.dload[1] = ccif.dstore[0];
        ccif.dwait[1] = ~(ccif.ramstate == ACCESS);
      end
      READ_0: begin
        ccif.ramREN = 1;
        ccif.ramaddr = ccif.daddr[1];
        ccif.dload[1] = ccif.ramload;
        ccif.dwait[1] = ~(ccif.ramstate == ACCESS);
      end
      SNOOP_0: begin
        ccif.ccsnoopaddr[0] = ccif.daddr[1];
        ccif.ccwait[0] = 1;
      end
      FLUSH_0: begin
        ccif.ramWEN = 1;
        ccif.ramaddr = ccif.daddr[0];
        ccif.ramstore = ccif.dstore[0];
        ccif.dwait[0] = ~(ccif.ramstate == ACCESS);
      end
      FLUSH_1: begin
        ccif.ramWEN = 1;
        ccif.ramaddr = ccif.daddr[1];
        ccif.ramstore = ccif.dstore[1];
        ccif.dwait[1] = ~(ccif.ramstate == ACCESS);
      end
      INSTR_0: begin
        ccif.ramREN = 1;
        ccif.ramaddr = ccif.iaddr[0];
        ccif.iwait[0] = ~(ccif.ramstate == ACCESS);
        ccif.iload[0] = ccif.ramload;
      end
      INSTR_1: begin
        ccif.ramREN = 1;
        ccif.ramaddr = ccif.iaddr[1];
        ccif.iwait[1] = ~(ccif.ramstate == ACCESS);
        ccif.iload[1] = ccif.ramload;
      end
    endcase
  end
endmodule
