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
  IDLE, WRITEBACK_READ1, WRITEBACK_READ2, FETCH_READ1, FETCH_READ2,
  ALLOCATE, WRITEBACK_WRITE1, WRITEBACK_WRITE2, FETCH_WRITE
} state_t;

parameter CPUID = 0;
parameter NFRAMES = 8;
parameter NWAYS = 2;

state_t state;
state_t n_state;
logic [NFRAMES-1:0] lru; // least recenctly used
frame_tag_t [NWAYS-1:0] frame_tags [NFRAMES-1:0]; // actually are sets
frame_tag_t [NWAYS-1:0] frame_tag;
frame_tag_t n_frame_tag;
frame_value_t [NWAYS-1:0] frame_values [NFRAMES-1:0];
frame_value_t [NWAYS-1:0] frame_value;
frame_value_t n_frame_value;
address_t address;
logic tag_WEN, WEN, dirty, waysel, new_way;
logic cache_hit[NWAYS-1:0];
word_t pikachu;
logic n_lru;

assign dcif.flushed = dcif.halt;
assign address = dcif.dmemaddr;
assign frame_tag = frame_tags[address.indexer];
assign frame_value = frame_values[address.indexer];
// genvar for NWAYS
  assign cache_hit[0] = (frame_tag[0].valid & (frame_tag[0].tag == address.tag));
  assign cache_hit[1] = (frame_tag[1].valid & (frame_tag[1].tag == address.tag));
//end genvar
assign waysel = cache_hit[0] ? 0 : 1;
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
always_comb begin
casez(address.blockoffset)
  0: begin
    pikachu = frame_value[waysel].value_0;
  end
  1: begin
    pikachu = frame_value[waysel].value_1;
  end
endcase
end

//assign ccif.daddr = dcif.dmemaddr;
assign n_frame_tag.tag = address.tag;
assign dirty = frame_tag[lru[address.indexer]].dirty && frame_tag[lru[address.indexer]].valid ;
assign dcif.dhit = (dcif.dmemREN && (cache_hit[0] || cache_hit[1])) || (dcif.dmemWEN && ((state == ALLOCATE) && dcif.dmemstore == pikachu) || (state != ALLOCATE && (cache_hit[0] || cache_hit[1])));
integer i, j;
always_ff @(posedge CLK, negedge nRST) begin
  if(nRST == 0) begin
    for(i = 0; i < NFRAMES; i++) begin
      for(j = 0; j < NWAYS; j++) begin
        frame_tags[i][j].valid = 1'b0;
        frame_tags[i][j].dirty = 1'b0;
      end
    end
  end
  else if(WEN) begin
    frame_values[address.indexer][new_way] = n_frame_value;
    frame_tags[address.indexer][new_way] = n_frame_tag;
  end
end

always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0) begin
    state <= IDLE;
  end
  else begin
    state <= n_state;
    lru[address.indexer] <= n_lru;
  end
end

always_comb begin
  casez(state)
    IDLE: begin
      if(dcif.dmemREN && (!cache_hit[0] && !cache_hit[1]) && dirty) begin
        n_state = WRITEBACK_READ1;
      end
      else if(dcif.dmemREN && (!cache_hit[0] && !cache_hit[1]) && !dirty) begin
        n_state = FETCH_READ1;
      end
      else if(dcif.dmemWEN && (cache_hit[0] || cache_hit[1])) begin
        n_state = ALLOCATE;
      end
      else if(dcif.dmemWEN && (!cache_hit[0] && !cache_hit[1]) && dirty) begin
        n_state = WRITEBACK_WRITE1;
      end
      else if(dcif.dmemWEN && (!cache_hit[0] && !cache_hit[1]) && !dirty) begin
        n_state = FETCH_WRITE;
      end
      else begin
        n_state = IDLE;
      end
    end
    WRITEBACK_READ1: begin
      if(!ccif.dwait) begin
        n_state = WRITEBACK_READ2;
      end
      else begin
        n_state = WRITEBACK_READ1;
      end
    end
    WRITEBACK_READ2: begin
      if(!ccif.dwait) begin
        n_state = FETCH_READ1;
      end
      else begin
        n_state = WRITEBACK_READ2;
      end
    end
    FETCH_READ1: begin
      if(!ccif.dwait) begin
        n_state = FETCH_READ2;
      end
      else begin
        n_state = FETCH_READ1;
      end
    end
    FETCH_READ2: begin
      if(!ccif.dwait) begin
        n_state = IDLE;
      end
      else begin
        n_state = FETCH_READ2;
      end
    end
    ALLOCATE: begin
      n_state = IDLE;
    end
    WRITEBACK_WRITE1: begin
      if(!ccif.dwait) begin
        n_state = WRITEBACK_WRITE2;
      end
      else begin
        n_state = WRITEBACK_WRITE1;
      end
    end
    WRITEBACK_WRITE2: begin
      if(!ccif.dwait) begin
        n_state = FETCH_WRITE;
      end
      else begin
        n_state = WRITEBACK_WRITE2;
      end
    end
    FETCH_WRITE: begin
      if(!ccif.dwait) begin
        n_state = ALLOCATE;
      end
      else begin
        n_state = FETCH_WRITE;
      end
    end
    default : n_state = IDLE;
  endcase
end

always_comb begin
  ccif.dREN = 0;
  ccif.dWEN = 0;
  ccif.daddr = '0;
  new_way = 0;
  n_frame_value.value_0 = '0;
  n_frame_value.value_1 = '0;
  n_frame_tag.valid = 0;
  n_frame_tag.dirty = 0;
  ccif.dstore = 0;
  WEN = 0;
  n_lru = lru[address.indexer];
  casez(state)
    IDLE: begin
      n_lru = (cache_hit[0] | cache_hit[1]) & ~waysel;
    end
    WRITEBACK_READ1: begin
      ccif.dWEN = 1;
      ccif.daddr = { frame_tag[lru[address.indexer]].tag, address.indexer, 3'b000 };
      ccif.dstore = frame_value[lru[address.indexer]].value_0;
    end
    WRITEBACK_READ2: begin
      ccif.dWEN = 1;
      ccif.daddr = { frame_tag[lru[address.indexer]].tag, address.indexer, 3'b100 };
      ccif.dstore = frame_value[lru[address.indexer]].value_1;
    end
    FETCH_READ1: begin
      ccif.dREN = 1;
      ccif.daddr = { address.tag, address.indexer, 3'b000 };
      new_way = lru[address.indexer];
      n_frame_value.value_0 = ccif.dload;
      n_frame_value.value_1 = frame_values[address.indexer][new_way].value_1;
      n_frame_tag.valid = 0;
      WEN = 1;
    end
    FETCH_READ2: begin
      ccif.dREN = 1;
      ccif.daddr = { address.tag, address.indexer, 3'b100 };
      new_way = lru[address.indexer];
      n_frame_value.value_0 = frame_values[address.indexer][new_way].value_0;
      n_frame_value.value_1 = ccif.dload;
      n_frame_tag.valid = 1;
      WEN = 1;
    end
    ALLOCATE: begin
      n_frame_value.value_0 = address.blockoffset ? frame_values[address.indexer][new_way].value_0 : dcif.dmemstore;
      n_frame_value.value_1 = address.blockoffset ? dcif.dmemstore : frame_values[address.indexer][new_way].value_1;
      n_frame_tag.valid = 1;
      n_frame_tag.dirty = 1;
      WEN = 1;
    end
    WRITEBACK_WRITE1: begin
      ccif.dWEN = 1;
      ccif.daddr = { frame_tag[lru[address.indexer]].tag, address.indexer, 3'b000 };
      ccif.dstore = frame_value[lru[address.indexer]].value_0;
    end
    WRITEBACK_WRITE2: begin
      ccif.dWEN = 1;
      ccif.daddr = { frame_tag[lru[address.indexer]].tag, address.indexer, 3'b100 };
      ccif.dstore = frame_value[lru[address.indexer]].value_1;
    end
    FETCH_WRITE: begin
      ccif.dREN = 1;
      ccif.daddr = { address.tag, address.indexer, ~address.blockoffset, 2'b00 };
      new_way = lru[address.indexer];
      n_frame_value.value_0 = address.blockoffset ? ccif.dload : dcif.dmemstore;
      n_frame_value.value_1 = address.blockoffset ? dcif.dmemstore : ccif.dload;
      n_frame_tag.valid = 1;
      n_frame_tag.dirty = 1;
      WEN = 1;
    end
  endcase
end

endmodule
