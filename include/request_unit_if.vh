/*
  request unit interface
*/
`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;

  logic DataRead, DataWrite;
  logic ihit, dhit, halt;
  logic req_iREN, req_dREN, req_dWEN;

  // register file ports
  modport r (
    input  DataRead, DataWrite,
    input  ihit, dhit, halt,
    output  req_iREN, req_dREN, req_dWEN
  );
endinterface

`endif //REQUEST_UNIT
