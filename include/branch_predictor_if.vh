`ifndef BRANCH_PREDICTOR_IF_VH
`define BRANCH_PREDICTOR_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface branch_predictor_if;
  // import types
  import cpu_types_pkg::*;

  logic [1:0] hash_sel;
  logic [27:0] tag_sel;
  logic [27:0] tag_n;
  logic [1:0] hash_wsel;
  logic WEN;
  logic hit;
  logic [29:0] target;
  logic [29:0] target_n;
  logic active_n;

  // alu ports
  modport bi (
    input   hash_sel, tag_sel,
    input   WEN, active_n,
    input   hash_wsel, tag_n, target_n,
    output  target, hit
  );
endinterface

`endif //ALU_IF
