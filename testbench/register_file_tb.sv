/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;
<<<<<<< HEAD
=======

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;
>>>>>>> 3f7f4ff63c60e4f842d19b9da798ed96487b6f5e

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
<<<<<<< HEAD
  test #(.PERIOD (PERIOD)) PROG (CLK, nRST, rfif.tb);
=======
  test PROG ();
>>>>>>> 3f7f4ff63c60e4f842d19b9da798ed96487b6f5e
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

endmodule

<<<<<<< HEAD
program test
(
  input logic CLK,
  output logic nRST,
  register_file_if.tb rf
);
  parameter PERIOD = 10;
  integer i;

  initial
  begin
    nRST = 0;
    rf.rsel1 = 10;
    rf.rsel2 = 5;
    #(PERIOD)
    $monitor("@%00g CLK = %b nRST = %b WRITE: %0d:%0d READ: %0d:%0d %0d:%0d", $time, CLK, nRST, rf.wsel, rf.wdat, rf.rsel1, rf.rdat1, rf.rsel2, rf.rdat2);
    #(PERIOD)

    nRST = 1;
    rf.WEN = 1;
    rf.wsel = 7;
    rf.wdat = 'hDEADBEEF;
    rf.rsel1 = 0;
    rf.rsel2 = 0;
    #(PERIOD)
    $monitor("@%00g CLK = %b nRST = %b WRITE: %0d:%0d READ: %0d:%0d %0d:%0d", $time, CLK, nRST, rf.wsel, rf.wdat, rf.rsel1, rf.rdat1, rf.rsel2, rf.rdat2);

    rf.wsel = 5;
    rf.wdat = 123;
    rf.rsel1 = 5;
    rf.rsel2 = 5;
    #(PERIOD)
    $monitor("@%00g CLK = %b nRST = %b WRITE: %0d:%0d READ: %0d:%0d %0d:%0d", $time, CLK, nRST, rf.wsel, rf.wdat, rf.rsel1, rf.rdat1, rf.rsel2, rf.rdat2);

    rf.wsel = 31;
    rf.wdat = 321;
    rf.rsel1 = 5;
    rf.rsel2 = 31;
    #(PERIOD)
    $monitor("@%00g CLK = %b nRST = %b WRITE: %0d:%0d READ: %0d:%0d %0d:%0d", $time, CLK, nRST, rf.wsel, rf.wdat, rf.rsel1, rf.rdat1, rf.rsel2, rf.rdat2);

    $monitor("@FOR WRITE LOOP INCOMING");
    for(i = 0; i < 32; i = i + 1)
    begin
      if(i % 10 == 0)
        rf.WEN = 0;
      else
        rf.WEN = 1;
      rf.wsel = i;
      rf.wdat = (2 ** i) - 1;
      rf.rsel1 = i;
      rf.rsel2 = i;
      #(PERIOD)
      $monitor("@%00g CLK = %b nRST = %b WRITE: %0d:%0d READ: %0d:%0d %0d:%0d", $time, CLK, nRST, rf.wsel, rf.wdat, rf.rsel1, rf.rdat1, rf.rsel2, rf.rdat2);
    end

    $monitor("@FOR READ LOOP INCOMING");
    for(i = 0; i < 32; i = i + 2)
    begin
      rf.rsel1 = i;
      rf.rsel2 = i + 1;
      #(PERIOD)
      $monitor("@%00g CLK = %b nRST = %b WRITE: %0d:%0d READ: %0d:%0d %0d:%0d", $time, CLK, nRST, rf.wsel, rf.wdat, rf.rsel1, rf.rdat1, rf.rsel2, rf.rdat2);
    end

    $finish;
  end
=======
program test;
>>>>>>> 3f7f4ff63c60e4f842d19b9da798ed96487b6f5e
endprogram
