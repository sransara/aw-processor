`include "cpu_ram_if.vh"
`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;
  parameter PERIOD = 20;
  logic CLK = 0, nRST;
  always #(PERIOD/2) CLK++;

  cache_control_if #(.CPUS(1)) ccif ();
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
  initial
  begin
    nRST = 0;
    @(posedge CLK);
    nRST = 1;
    ccif.iREN = 1;
    ccif.dREN = 0;
    ccif.dWEN = 0;
    ccif.dstore = 'h0xBAD1BAD1;
    ccif.iaddr = 0;
    ccif.daddr =  'h0xFFFFFFF8;
    while(ccif.iwait) begin
      @(posedge CLK);
    end
    $display("%0dns %h", $time, ccif.iload);

    ccif.dREN = 0;
    ccif.dWEN = 1;
    ccif.dstore = 'h0xDEADBEEF;
    ccif.iaddr = 0;
    ccif.daddr =  'h0x00000004;
    while(ccif.dwait) begin
      @(posedge CLK);
    end
    @(posedge CLK);

    ccif.dREN = 1;
    ccif.dWEN = 0;
    ccif.dstore = 'h0xBAD1BAD1;
    ccif.iaddr = 0;
    ccif.daddr =  'h0x00000004;
    while(ccif.dwait) begin
      @(posedge CLK);
    end
    $display("%0dns %h", $time, ccif.dload);

    @(posedge CLK);
    ccif.dREN = 1;
    ccif.dWEN = 0;
    ccif.dstore = 'h0xBAD1BAD1;
    ccif.iaddr = 0;
    ccif.daddr = 0;
    while(ccif.dwait) begin
      @(posedge CLK);
    end
    $display("%0dns %h", $time, ccif.dload);

    @(posedge CLK);
    ccif.dREN = 0;
    while(ccif.iwait) begin
      @(posedge CLK);
    end
    $display("%0dns %h", $time, ccif.iload);

    @(posedge CLK);
    ccif.dREN = 0;
    ccif.dWEN = 0;
    ccif.dstore = 'h0xBAD1BAD1;
    ccif.iaddr = 0;
    ccif.daddr = 0;

    dump_memory();
    $finish;
  end

  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    ccif.dREN = 0;
    ccif.dWEN = 0;
    ccif.dstore = 'h0xBAD1BAD1;
    ccif.iaddr = 0;
    ccif.daddr = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      ccif.daddr = i << 2;
      ccif.dREN = 1;
      repeat (2) @(posedge CLK);
      if (ccif.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,ccif.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),ccif.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      ccif.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask
endprogram
