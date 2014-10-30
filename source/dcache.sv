`include "aww_types_pkg.vh"
`include "cpu_types_pkg.vh"

module dcache
import cpu_types_pkg::*, aww_types_pkg::*;
(
  input logic CLK, nRST,
  datapath_cache_if.dcache dcif,
  cache_control_if.dcache ccif
);

// Associative cache
parameter CPUID = 0;
parameter NSETS = 8;
parameter NWAYS = 2;
parameter NWORDS = 2; // number of words per block

typedef struct packed {
  logic [25:0] tag;
  logic [2:0] indexer; // [log2(NSETS)-1 : 0]
  logic blockoffset;
  logic [1:0] aaa;
} address_t;

typedef struct packed {
  logic valid;
  logic dirty;
  logic [25:0] tag;
} frame_tag_t;

typedef struct packed {
  word_t [NWORDS-1:0] values;
} frame_value_t;

typedef enum bit [3:0]{
  IDLE, WRITEBACK0, WRITEBACK1, FETCH0, FETCH1, FETCH_WRITE,
  FLUSH0, FLUSH1, COUNT_SET, FLUSH_END
} state_t;

state_t state;
state_t n_state;
// { set_tags [ NSETS * set_tag [ NWAYS * frame_tag ] ] }
frame_tag_t [NWAYS-1:0] set_tags [NSETS-1:0];
frame_tag_t [NWAYS-1:0] set_tag;
frame_tag_t frame_tag, n_frame_tag, wframe_tag;
// { set_values [ NSETS * set_value [ NWAYS * frame_value ] ] }
frame_value_t [NWAYS-1:0] set_values [NSETS-1:0];
frame_value_t [NWAYS-1:0] set_value;
frame_value_t frame_value, n_frame_value, wframe_value;
// lru, this method only works for NWAYS = 2
logic lrus [NSETS-1:0]; // ~last used way
logic n_lru;

logic tag_WEN, value_WEN;
logic cache_hit;
logic way_select, way_wselect;
logic dirty_wframe;
address_t address;

logic way_count, n_way_count;
logic [3:0] frame_count;
logic [3:0] n_frame_count;
word_t hit_count, n_hit_count;
logic flush_wait;

assign address = dcif.dmemaddr;
assign set_tag = set_tags[address.indexer];
assign set_value = set_values[address.indexer];
assign frame_tag = set_tag[way_select];
assign frame_value = set_value[way_select];
assign cache_hit = (set_tag[0].valid & (set_tag[0].tag == address.tag)) | (set_tag[1].valid & (set_tag[1].tag == address.tag));
assign way_select = (set_tag[1].valid & (set_tag[1].tag == address.tag)) ? 1'b1 : 1'b0; // if hit this is the way to go
assign dcif.dmemload = frame_value.values[address.blockoffset];
assign dcif.dhit = (cache_hit === 1) & (dcif.dmemWEN | dcif.dmemREN);

assign way_wselect = cache_hit ? way_select : lrus[address.indexer];
assign wframe_tag = set_tag[way_wselect];
assign wframe_value = set_value[way_wselect];
assign dirty_wframe = wframe_tag.dirty & wframe_tag.valid;

integer i, j;
always_ff @(posedge CLK, negedge nRST) begin
  if(nRST == 0) begin
    state <= IDLE;
    frame_count <= '0;
    way_count <= '0;
    hit_count <= '0;
    for(i = 0; i < NSETS; i++) begin
      for(j = 0; j < NWAYS; j++) begin
        set_tags[i][j].valid <= 1'b0;
        set_tags[i][j].dirty <= 1'b0;
      end
      lrus[i] <= 1'b0;
    end
  end
  else begin
    if(value_WEN) begin
      set_values[address.indexer][way_wselect] <= n_frame_value;
    end
    if(tag_WEN) begin
      set_tags[address.indexer][way_wselect] <= n_frame_tag;
    end
    state <= n_state;
    frame_count <= n_frame_count;
    way_count <= n_way_count;
    hit_count <= n_hit_count;
    lrus[address.indexer] <= n_lru;
  end
end

always_comb begin
  casez(state)
    IDLE: begin
      if((dcif.dmemWEN | dcif.dmemREN) & ~cache_hit & dirty_wframe) begin
        n_state = WRITEBACK0;
      end
      else if(dcif.dmemREN & ~cache_hit & ~dirty_wframe) begin
        n_state = FETCH0;
      end
      else if(dcif.dmemWEN & ~cache_hit & ~dirty_wframe) begin
        n_state = FETCH_WRITE;
      end
      else if(dcif.halt) begin
        n_state = FLUSH0;
      end
      else begin
        n_state = IDLE;
      end
    end
    WRITEBACK0: begin
      if(ccif.dwait[CPUID]) begin
        n_state = WRITEBACK0;
      end
      else begin
        n_state = WRITEBACK1;
      end
    end
    WRITEBACK1: begin
      if(ccif.dwait[CPUID]) begin
        n_state = WRITEBACK1;
      end
      else begin
        if(dcif.dmemWEN) begin
          n_state = FETCH_WRITE;
        end
        else begin
          n_state = FETCH0;
        end
      end
    end
    FETCH0: begin
      if(ccif.dwait[CPUID]) begin
        n_state = FETCH0;
      end
      else begin
        n_state = FETCH1;
      end
    end
    FETCH1: begin
      if(ccif.dwait[CPUID]) begin
        n_state = FETCH1;
      end
      else begin
        n_state = IDLE;
      end
    end
    FETCH_WRITE: begin
      if(ccif.dwait[CPUID]) begin
        n_state = FETCH_WRITE;
      end
      else begin
        n_state = IDLE;
      end
    end
    FLUSH0: begin
      if(frame_count >= NSETS) begin
        n_state = COUNT_SET;
      end
      else if(~flush_wait) begin
        n_state = FLUSH1;
      end
      else begin
        n_state = FLUSH0;
      end
    end
    FLUSH1: begin
      if(~flush_wait) begin
        n_state = FLUSH0;
      end
      else begin
        n_state = FLUSH1;
      end
    end
    COUNT_SET: begin
      if(~ccif.dwait[CPUID]) begin
        n_state = FLUSH_END;
      end
      else begin
        n_state = COUNT_SET;
      end
    end
    FLUSH_END: begin
      n_state = FLUSH_END;
    end
    default : n_state = IDLE;
  endcase
end

always_comb begin
  ccif.dstore[CPUID] = word_t'('0);
  dcif.flushed = 0;

  n_frame_value.values[0] = '0;
  n_frame_value.values[1] = '0;
  n_frame_tag.valid = 0;
  n_frame_tag.dirty = 0;
  n_frame_tag.tag = address.tag;

  tag_WEN = 0; value_WEN = 0;
  n_lru = lrus[address.indexer];
  n_frame_count = frame_count;
  n_hit_count = hit_count;
  n_way_count = way_count;
  flush_wait = 1;

  casez(state)
    IDLE: begin
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'('0);
      if(dcif.dmemWEN & cache_hit) begin
        n_frame_value.values[0] = address.blockoffset ? frame_value.values[0] : dcif.dmemstore;
        n_frame_value.values[1] = address.blockoffset ? dcif.dmemstore : frame_value.values[1];
        n_frame_tag.dirty = 1;
        n_frame_tag.valid = 1;
        tag_WEN = 1;
        value_WEN = 1;
      end
      if((dcif.dmemREN | dcif.dmemWEN) & cache_hit) begin
        n_hit_count = hit_count + 1;
        n_lru = ~way_wselect;
      end
    end
    WRITEBACK0: begin
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 1;
      ccif.daddr[CPUID] = word_t'({ wframe_tag.tag, address.indexer, 3'b000 }); // blockoffset = 0
      ccif.dstore[CPUID] = wframe_value.values[0];
    end
    WRITEBACK1: begin
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 1;
      ccif.daddr[CPUID] = word_t'({ wframe_tag.tag, address.indexer, 3'b100 });
      ccif.dstore[CPUID] = wframe_value.values[1];
    end
    FETCH0: begin
      if(~ccif.dwait[CPUID]) begin
        n_hit_count = hit_count - 1;
      end
      ccif.dREN[CPUID] = 1;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'({ address.tag, address.indexer, 3'b000 }); // blockoffset = 0
      n_frame_value.values[0] = ccif.dload[CPUID];
      // n_frame_value.values[1] = '0; will be replaced in next state
      value_WEN = 1;
    end
    FETCH1: begin
      ccif.dREN[CPUID] = 1;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'({ address.tag, address.indexer, 3'b100 });
      n_frame_value.values[0] = wframe_value.values[0];
      n_frame_value.values[1] = ccif.dload[CPUID];
      n_frame_tag.valid = ~ccif.dwait[CPUID];
      n_frame_tag.dirty = 0;
      tag_WEN = 1;
      value_WEN = 1;
    end
    FETCH_WRITE: begin
      if(~ccif.dwait[CPUID]) begin
        n_hit_count = hit_count - 1;
      end
      ccif.dREN[CPUID] = 1;
      ccif.dWEN[CPUID] = 0;
      // set ccif.dload
      ccif.daddr[CPUID] = word_t'({ address.tag, address.indexer, ~address.blockoffset, 2'b00 });
      n_frame_value.values[0] = address.blockoffset ? ccif.dload[CPUID] : dcif.dmemstore;
      n_frame_value.values[1] = address.blockoffset ? dcif.dmemstore : ccif.dload[CPUID];
      n_frame_tag.valid = ~ccif.dwait[CPUID];
      tag_WEN = 1;
      value_WEN = 1;
    end
    FLUSH0: begin
      ccif.dREN[CPUID] = 0;
      if(set_tags[frame_count][way_count].dirty) begin
        flush_wait = ccif.dwait[CPUID];
        ccif.dWEN[CPUID] = 1;
        ccif.daddr[CPUID] = { set_tags[frame_count][way_count].tag, frame_count[2:0], 3'b000 };
        ccif.dstore[CPUID] = set_values[frame_count][way_count].values[0];
      end
      else begin
        ccif.dWEN[CPUID] = 0;
        flush_wait = 0;
        ccif.daddr[CPUID] = word_t'('0);
      end
    end
    FLUSH1: begin
      ccif.dREN[CPUID] = 0;
      if(set_tags[frame_count][way_count].dirty) begin
        flush_wait = ccif.dwait[CPUID];
        ccif.dWEN[CPUID] = 1;
        ccif.daddr[CPUID] = { set_tags[frame_count][way_count].tag, frame_count[2:0], 3'b100 };
        ccif.dstore[CPUID] = set_values[frame_count][way_count].values[1];
        if(~ccif.dwait[CPUID]) begin
          n_frame_count = way_count ? frame_count + 1'b1 : frame_count;
          n_way_count = ~way_count;
        end
      end
      else begin
        ccif.dWEN[CPUID] = 0;
        flush_wait = 0;
        ccif.daddr[CPUID] = word_t'('0);
        n_frame_count = way_count ? frame_count + 1'b1 : frame_count;
        n_way_count = ~way_count;
      end
    end
    COUNT_SET: begin
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 1;
      ccif.daddr[CPUID] = 32'h3100;
      ccif.dstore[CPUID] = hit_count;
    end
    FLUSH_END: begin
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'('0);
      dcif.flushed = 1;
    end
    default: begin
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'('0);
    end
  endcase
end

endmodule
