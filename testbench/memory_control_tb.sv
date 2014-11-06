`include "cpu_ram_if.vh"
`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;
  parameter PERIOD = 20;
  logic CLK = 0, nRST;
  always #(PERIOD/2) CLK++;

  cache_control_if #(.CPUS(2)) ccif ();
  cpu_ram_if ramif ();

  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ccif.ramload = ramif.ramload;
  assign ccif.ramstate = ramif.ramstate;

  // test program
  test PROG (CLK, nRST, ccif);
  // DUT
  ram RAM (CLK, nRST, ramif);
  memory_control CC (CLK, nRST, ccif);
endmodule

program test
import cpu_types_pkg::*;
(
  input logic CLK,
  output logic nRST,
  cache_control_if.cc ccif
);
  parameter PERIOD = 20;
  initial
  begin
    nRST = 0;
    @(posedge CLK);
    nRST = 1;
    ccif.iREN[0] = 1;
    ccif.dWEN[0] = 0;
    ccif.dREN[0] = 0;
    ccif.dstore[0] = 0;
    ccif.daddr[0] = 0;
    ccif.iaddr[0] = 0;
    ccif.cctrans[0] = 0;
    ccif.ccwrite[0] = 0;
    ccif.iREN[1] = 1;
    ccif.dWEN[1] = 0;
    ccif.dREN[1] = 0;
    ccif.dstore[1] = 0;
    ccif.daddr[1] = 0;
    ccif.iaddr[1] = 0;
    ccif.cctrans[1] = 0;
    ccif.ccwrite[1] = 0;
    @(posedge CLK);
    wait(ccif.ramstate == ACCESS);
    @(posedge CLK);
    @(posedge CLK);
    ccif.iREN[0] = 0;
    ccif.dWEN[0] = 1;
    ccif.dWEN[1] = 1;
    ccif.dstore[0] = 4'b1110;
    ccif.dstore[1] = 4'b1010;
    ccif.daddr[0] = 32'b100;
    ccif.daddr[1] = 32'b1000;
    wait(ccif.ramstate == ACCESS);
    ccif.dWEN[0] = 0;
    @(posedge CLK);
    @(posedge CLK);
    // C0 I->M C1 I->I
    display("C0 I->M C1 I->I %gns",$time);
    ccif.dWEN[0] = 0;
    ccif.dWEN[1] = 0;
    ccif.dREN[0] = 1;
    ccif.cctrans[0] = 1;
    ccif.ccwrite[0] = 1;
    wait(ccif.ccinv[1]);
    wait(ccif.ramstate == ACCESS);
    @(posedge CLK);
    ccif.dREN[0] = 0;
    @(posedge CLK);
    // C0 I->S C1 M->S
    display("C0 I->S C1 M-> S %gns",$time);
    ccif.dREN[0] = 1;
    ccif.cctrans[0] = 1;
    ccif.ccwrite[0] = 0;
    wait(ccif.ccinv[1]);
    wait(ccif.ramstate == ACCESS);
    @(posedge CLK);
    @(posedge CLK);
    ccif.dWEN[1] = 0;
    ccif.dWEN[1] = 0;
  end

endprogram
