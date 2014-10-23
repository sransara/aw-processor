`include "aww_types_pkg.vh"
`include "cpu_types_pkg.vh"

module icache
import cpu_types_pkg::*, aww_types_pkg::*;
(
  input logic CLK, nRST,
  datapath_cache_if.icache dcif,
  cache_control_if.icache ccif
);

typedef struct packed {
  logic [25:0] tag;
  logic [3:0] indexer; // [log2(NFRAMES)-1 : 0]
  logic [1:0] blockoffset;
} address_t;

typedef struct packed {
  logic valid;
  logic [25:0] tag;
} frame_tag_t;

typedef struct packed {
  word_t value;
} frame_value_t;

typedef enum bit {
  IDLE, FETCH
} state_t;

parameter CPUID = 0;
parameter NFRAMES = 16;

state_t state;
state_t n_state;
frame_tag_t frame_tags [NFRAMES-1:0];
frame_tag_t frame_tag, n_frame_tag;
frame_value_t frame_values [NFRAMES-1:0];
frame_value_t frame_value, n_frame_value;
address_t address;
logic WEN, cache_hit;

assign address = dcif.imemaddr;
assign frame_tag = frame_tags[address.indexer];
assign frame_value = frame_values[address.indexer];
assign cache_hit = (frame_tag.valid & (frame_tag.tag == address.tag));
assign dcif.ihit = cache_hit;
assign dcif.imemload = frame_value.value;
assign ccif.iaddr = dcif.imemaddr;
assign n_frame_tag.valid = 1;
assign n_frame_tag.tag = address.tag;
assign n_frame_value.value = ccif.iload;


always_ff @(posedge CLK, negedge nRST) begin
  if(nRST == 0) begin
    integer i;
    for(i = 0; i < NFRAMES; i++) begin
      frame_tags[i].valid = 1'b0;
    end
  end
  else if(WEN) begin
    frame_values[address.indexer] = n_frame_value;
    frame_tags[address.indexer] = n_frame_tag;
  end
end

always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    state <= IDLE;
  end
  else begin
    state <= n_state;
  end
end

always_comb begin
  casez(state)
    IDLE: begin
      if(dcif.imemREN & ~cache_hit) begin
        n_state = FETCH;
      end
      else begin
        n_state = IDLE;
      end
    end
    FETCH: begin
      if(ccif.iwait) begin
        n_state = FETCH;
      end
      else begin
        n_state = IDLE;
      end
    end
    default : n_state = IDLE;
  endcase
end

always_comb begin
  casez(state)
    IDLE: begin
      ccif.iREN = 0;
      WEN = 0;
    end
    FETCH: begin
      ccif.iREN = 1;
      WEN = 1;
    end
    default: begin
      ccif.iREN = 0;
      WEN = 0;
    end
  endcase
end

endmodule
