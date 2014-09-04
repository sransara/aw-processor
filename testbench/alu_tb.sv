`include "alu_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;
  alu_if aluif ();
  // test program
  test PROG (aluif.at);
  // DUT
`ifndef MAPPED
  alu DUT(aluif);
`else
  alu DUT(
    .\aluif.aluop (aluif.aluop),
    .\aluif.port_a (aluif.port_a),
    .\aluif.port_b (aluif.port_b),
    .\aluif.out (aluif.out),
    .\aluif.negative (aluif.negative),
    .\aluif.overflow (aluif.overflow),
    .\aluif.zero (aluif.zero)
  );
`endif
endmodule

program test
import cpu_types_pkg::*;
(
  alu_if.at aluif
);
  parameter DELAY = 100;
  initial
  begin
    print_info();

    aluif.aluop = ALU_SLL;
    aluif.port_a = 1;
    aluif.port_b = 2;
    print_info();

    aluif.aluop = ALU_SRL;
    aluif.port_a = 8;
    aluif.port_b = 1;
    print_info();

    aluif.aluop = ALU_ADD;
    aluif.port_a = -4;
    aluif.port_b = 2;
    print_info();

    aluif.aluop = ALU_SUB;
    aluif.port_a = 1;
    aluif.port_b = 2;
    print_info();

    aluif.aluop = ALU_OR;
    aluif.port_a = 5;
    aluif.port_b = 2;
    print_info();

    aluif.aluop = ALU_XOR;
    aluif.port_a = 1;
    aluif.port_b = 1;
    print_info();

    aluif.aluop = ALU_NOR;
    aluif.port_a = 0;
    aluif.port_b = 1;
    print_info();

    aluif.aluop = ALU_SLT;
    aluif.port_a = -1;
    aluif.port_b = 2;
    print_info();

    aluif.aluop = ALU_SLTU;
    aluif.port_a = -1;
    aluif.port_b = 2;
    print_info();

    $display("\nDONE WITH BABY TESTS\n------------------\n");
    aluif.aluop = ALU_ADD;
    aluif.port_a = 2**31;
    aluif.port_b = 2**31;
    print_info();

    aluif.aluop = ALU_AND;
    aluif.port_a = 2**32 - 1;
    aluif.port_b = 2**32 - 1;
    print_info();

    aluif.aluop = ALU_SUB;
    aluif.port_a = -2**31;
    aluif.port_b = -2**31;
    print_info();

    aluif.aluop = ALU_ADD;
    aluif.port_a = 2**31;
    aluif.port_b = 1000;
    print_info();

    $finish;
  end

  task print_info();
    #(DELAY);
    $display("aluop: %b aluop: %0s", aluif.aluop, what_op(aluif.aluop));
    $display("port_a: %0d port_b: %0d", aluif.port_a, aluif.port_b);
    $display("sort_a: %0d sort_b: %0d", $signed(aluif.port_a), $signed(aluif.port_b));
    $display("out: %0d sout: %0d", aluif.out, $signed(aluif.out));
    $display("NEG: %b ZER: %b", aluif.negative, aluif.zero);
    $display("OVR: %b", aluif.overflow);
    $display("---");
  endtask

  function [96:0] what_op;
    input aluop_t o;
    case(o)
      ALU_SLL: what_op = "LEFT SHIFT";
      ALU_SRL: what_op = "RIGHT SHIFT";
      ALU_ADD: what_op = "ADD";
      ALU_SUB: what_op = "SUB";
      ALU_AND: what_op = "AND";
      ALU_OR: what_op = "OR";
      ALU_XOR: what_op = "XOR";
      ALU_NOR: what_op = "NOR";
      ALU_SLT: what_op = "SIGNED LT";
      ALU_SLTU: what_op = "UNSIGNED LT";
      default: what_op = "xxx";
    endcase
  endfunction
endprogram
