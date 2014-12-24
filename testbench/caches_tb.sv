`include "cpu_ram_if.vh"
`include "cache_control_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module caches_tb;
  parameter PERIOD = 20;
  logic CLK = 0, nRST;
  always #(PERIOD/2) CLK++;

  parameter CLKDIV = 2;
  logic CPUCLK;
  logic [3:0] count;
  //logic CPUnRST;

  always_ff @(posedge CLK, negedge nRST)
  begin
    if (!nRST)
    begin
      count <= 0;
      CPUCLK <= 0;
    end
    else if (count == CLKDIV-2)
    begin
      count <= 0;
      CPUCLK <= ~CPUCLK;
    end
    else
    begin
      count <= count + 1;
    end
  end

  cache_control_if #(.CPUS(1)) ccif ();
  datapath_cache_if dcif ();
  cpu_ram_if ramif ();

  assign ramif.ramaddr = ccif.ramaddr;
  assign ramif.ramstore = ccif.ramstore;
  assign ramif.ramREN = ccif.ramREN;
  assign ramif.ramWEN = ccif.ramWEN;
  assign ccif.ramload = ramif.ramload;
  assign ccif.ramstate = ramif.ramstate;

  // test program
  test PROG (CLK, nRST, dcif, ccif);
  // DUT
  ram RAM (CLK, nRST, ramif);
  memory_control MC (CPUCLK, nRST, ccif);
  caches CC (CPUCLK, nRST, dcif, ccif);
endmodule

program test
import cpu_types_pkg::*;
(
  input logic CLK,
  output logic nRST,
  datapath_cache_if dcif,
  cache_control_if ccif
);
  initial
  begin
    nRST = 0;
    @(posedge CLK);
    nRST = 1;
    @(posedge CLK);
    dcif.imemREN = 1;
    dcif.dmemREN = 1;
    dcif.dmemWEN = 0;
    dcif.dmemaddr = 32'h4;
    dcif.dmemstore = 'h1337;
    while (!dcif.dhit)
    begin
      @(posedge CLK);
    end
    @(posedge CLK);
    @(posedge CLK);
    @(posedge CLK);
    @(posedge CLK);
    dcif.dmemREN = 0;
    dcif.dmemWEN = 1;
    dcif.dmemaddr = 32'h4;
    dcif.dmemstore = 'h1337;
    while (!dcif.dhit)
    begin
      @(posedge CLK);
    end
    @(posedge CLK);
    @(posedge CLK);
    @(posedge CLK);
    @(posedge CLK);
    $finish;
  end
endprogram
