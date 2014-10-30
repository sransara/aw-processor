`include "aww_types_pkg.vh"
`include "cpu_types_pkg.vh"

module dcache
import cpu_types_pkg::*, aww_types_pkg::*;
(
  input logic CLK, nRST,
  datapath_cache_if.dcache dcif,
  cache_control_if.dcache ccif
);

typedef struct packed {
  logic [25:0] tag;
  logic [2:0] indexer; // [log2(NFRAMES)-1 : 0]
  logic blockoffset;
  logic [1:0] aaa;
} address_t;

typedef struct packed {
  logic valid;
  logic dirty;
  logic [25:0] tag;
} frame_tag_t;

typedef struct packed {
  word_t value_0;
  word_t value_1;
} frame_value_t;

typedef enum bit [3:0]{
  IDLE, WRITEBACK0, WRITEBACK1, FETCH0, FETCH1, FETCH_WRITE,
  FLUSH0, FLUSH1, COUNT_SET, FLUSH_END
} state_t;

parameter CPUID = 0;
parameter NFRAMES = 8;
parameter NWAYS = 2;

state_t state;
state_t n_state;
logic [NFRAMES-1:0] lru; // least recenctly used
frame_tag_t [NWAYS-1:0] set_tags [NFRAMES-1:0]; // actually are sets
frame_tag_t [NWAYS-1:0] frame_tag;
frame_tag_t n_frame_tag;
frame_value_t [NWAYS-1:0] set_values [NFRAMES-1:0];
frame_value_t [NWAYS-1:0] frame_value;
frame_value_t n_frame_value;
address_t address;
logic tag_WEN, WEN, dirty, waysel, new_way;
logic cache_hit[NWAYS-1:0];
logic n_lru;
logic way_count, n_way_count;
logic [3:0] frame_count;
logic [3:0] n_frame_count;
word_t hit_count;
word_t n_hit_count;
logic flush_wait;

assign address = dcif.dmemaddr;
assign frame_tag = set_tags[address.indexer];
assign frame_value = set_values[address.indexer];
// genvar for NWAYS
  assign cache_hit[0] = (frame_tag[0].valid & (frame_tag[0].tag == address.tag));
  assign cache_hit[1] = (frame_tag[1].valid & (frame_tag[1].tag == address.tag));
//end genvar
assign waysel = cache_hit[0] ? 1'b0 : 1'b1;
always_comb begin
  if(cache_hit[0]) begin
    if(address.blockoffset) begin
      dcif.dmemload = frame_value[0].value_1;
    end
    else begin
      dcif.dmemload = frame_value[0].value_0;
    end
  end
  else begin
    if(address.blockoffset) begin
      dcif.dmemload = frame_value[1].value_1;
    end
    else begin
      dcif.dmemload = frame_value[1].value_0;
    end
  end
end

//assign ccif.daddr[CPUID] = dcif.dmemaddr;
assign n_frame_tag.tag = address.tag;
assign dirty = frame_tag[lru[address.indexer]].dirty && frame_tag[lru[address.indexer]].valid ;
assign dcif.dhit = cache_hit[0] || cache_hit[1];
assign new_way = lru[address.indexer];

integer i, j;
always_ff @(posedge CLK, negedge nRST) begin
  if(nRST == 0) begin
    for(i = 0; i < NFRAMES; i++) begin
      for(j = 0; j < NWAYS; j++) begin
        set_tags[i][j].valid <= 1'b0;
        set_tags[i][j].dirty <= 1'b0;
      end
      lru[i] <= 1'b0;
    end
  end
  else if(WEN) begin
    set_values[address.indexer][new_way] <= n_frame_value;
    set_tags[address.indexer][new_way] <= n_frame_tag;
  end
end

always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    state <= IDLE;
    frame_count <= '0;
    way_count <= '0;
    hit_count <= '0;
  end
  else begin
    state <= n_state;
    lru[address.indexer] <= n_lru;
    frame_count <= n_frame_count;
    way_count <= n_way_count;
    hit_count <= n_hit_count;
  end
end

always_comb begin
  n_frame_count = frame_count;
  casez(state)
    IDLE: begin
      if((dcif.dmemWEN | dcif.dmemREN) & (~cache_hit[0] & ~cache_hit[1]) & dirty) begin
        n_state = WRITEBACK0;
      end
      else if(dcif.dmemREN & (~cache_hit[0] & ~cache_hit[1]) & ~dirty) begin
        n_state = FETCH0;
      end
      else if(dcif.dmemWEN & (~cache_hit[0] & ~cache_hit[1]) & ~dirty) begin
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
      if(~ccif.dwait[CPUID]) begin
        n_state = WRITEBACK1;
      end
      else begin
        n_state = WRITEBACK0;
      end
    end
    WRITEBACK1: begin
      if(~ccif.dwait[CPUID]) begin
        if(dcif.dmemWEN) begin
          n_state = FETCH_WRITE;
        end
        else begin
          n_state = FETCH0;
        end
      end
      else begin
        n_state = WRITEBACK1;
      end
    end
    FETCH0: begin
      if(~ccif.dwait[CPUID]) begin
        n_state = FETCH1;
      end
      else begin
        n_state = FETCH0;
      end
    end
    FETCH1: begin
      if(~ccif.dwait[CPUID]) begin
        n_state = IDLE;
      end
      else begin
        n_state = FETCH1;
      end
    end
    FETCH_WRITE: begin
      if(~ccif.dwait[CPUID]) begin
        n_state = IDLE;
      end
      else begin
        n_state = FETCH_WRITE;
      end
    end
    FLUSH0: begin
      if(frame_count >= NFRAMES) begin
        n_state = COUNT_SET;
        //n_state = FLUSH_END;
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
        n_frame_count = frame_count + 4'b1;
      end
      else begin
        n_state = FLUSH1;
      end
    end
    COUNT_SET: begin
      if(~ccif.dwait[CPUID]) begin
        //n_state = FLUSH_END;
        n_state = IDLE;
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
  ccif.dREN[CPUID] = 0;
  ccif.dWEN[CPUID] = 0;
  ccif.daddr[CPUID] = '0;
  ccif.dstore[CPUID] = '0;
  dcif.flushed = 0;
  n_frame_value.value_0 = '0;
  n_frame_value.value_1 = '0;
  n_frame_tag.valid = 0;
  n_frame_tag.dirty = 0;
  WEN = 0;
  n_lru = lru[address.indexer];
  n_hit_count = hit_count;
  n_way_count = way_count;
  flush_wait = 1;

  casez(state)
    IDLE: begin
      if(dcif.dmemWEN && (cache_hit[0] || cache_hit[1])) begin
        n_frame_value.value_0 = address.blockoffset ? set_values[address.indexer][new_way].value_0 : dcif.dmemstore;
        n_frame_value.value_1 = address.blockoffset ? dcif.dmemstore : set_values[address.indexer][new_way].value_1;
        n_frame_tag.valid = 1;
        n_frame_tag.dirty = 1;
        WEN = 1;
      end
      if(cache_hit[0] || cache_hit[1]) begin
        n_hit_count = hit_count + 1;
      end
      n_lru = (cache_hit[0] | cache_hit[1]) & ~waysel;
    end
    WRITEBACK0: begin
      ccif.dWEN[CPUID] = 1;
      ccif.daddr[CPUID] = { frame_tag[lru[address.indexer]].tag, address.indexer, 3'b000 };
      ccif.dstore[CPUID] = frame_value[lru[address.indexer]].value_0;
    end
    WRITEBACK1: begin
      ccif.dWEN[CPUID] = 1;
      ccif.daddr[CPUID] = { frame_tag[lru[address.indexer]].tag, address.indexer, 3'b100 };
      ccif.dstore[CPUID] = frame_value[lru[address.indexer]].value_1;
    end
    FETCH0: begin
      n_hit_count = hit_count - 1;
      ccif.dREN[CPUID] = 1;
      ccif.daddr[CPUID] = { address.tag, address.indexer, 3'b000 };
      n_frame_value.value_0 = ccif.dload;
      n_frame_value.value_1 = set_values[address.indexer][new_way].value_1;
      n_frame_tag.valid = 0;
      WEN = 1;
    end
    FETCH1: begin
      ccif.dREN[CPUID] = 1;
      ccif.daddr[CPUID] = { address.tag, address.indexer, 3'b100 };
      n_frame_value.value_0 = set_values[address.indexer][new_way].value_0;
      n_frame_value.value_1 = ccif.dload;
      n_frame_tag.valid = ~ccif.dwait[CPUID];
      WEN = 1;
    end
    FETCH_WRITE: begin
      n_hit_count = hit_count - 1;
      ccif.dREN[CPUID] = 1;
      ccif.daddr[CPUID] = { address.tag, address.indexer, ~address.blockoffset, 2'b00 };
      n_frame_value.value_0 = address.blockoffset ? ccif.dload : dcif.dmemstore;
      n_frame_value.value_1 = address.blockoffset ? dcif.dmemstore : ccif.dload;
      n_frame_tag.valid = ~ccif.dwait[CPUID];
      n_frame_tag.dirty = 1;
      WEN = 1;
    end
    FLUSH0: begin
      if(set_tags[frame_count][way_count].dirty) begin
        flush_wait = ccif.dwait[CPUID];
        ccif.dWEN[CPUID] = 1;
        ccif.daddr[CPUID] = { frame_tag[frame_count].tag, frame_count[2:0], 3'b000 };
        ccif.dstore[CPUID] = frame_value[frame_count].value_0;
      end
      else begin
        flush_wait = 0;
      end
    end
    FLUSH1: begin
      if(set_tags[frame_count][way_count].dirty) begin
        flush_wait = ccif.dwait[CPUID];
        ccif.dWEN[CPUID] = 1;
        ccif.daddr[CPUID] = { frame_tag[frame_count].tag, frame_count[2:0], 3'b100 };
        ccif.dstore[CPUID] = frame_value[frame_count].value_1;
      end
      else begin
        flush_wait = 0;
      end
      n_way_count = ~way_count;
    end
    COUNT_SET: begin
      ccif.dWEN[CPUID] = 1;
      ccif.daddr[CPUID] = 32'h3100;
      ccif.dstore[CPUID] = hit_count;
    end
    FLUSH_END: begin
      dcif.flushed = 1;
    end
  endcase
end

endmodule
