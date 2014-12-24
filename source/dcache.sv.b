`include "aww_types_pkg.vh"
`include "cpu_types_pkg.vh"

module dcache
import cpu_types_pkg::*, aww_types_pkg::*;
(
  input logic CLK, nRST,
  datapath_cache_if.dcache dcif,
  cache_control_if ccif
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

typedef enum bit [3:0] {
  IDLE, WRITEBACK0, WRITEBACK1, FETCH0, FETCH1, FETCH_WRITE,
  FLUSH0, FLUSH1, FLUSH_END, SEND_READDATA0, SEND_READDATA1, INVALIDATE
} state_t;

state_t state;
state_t n_state;
// { set_tags [ NSETS * set_tag [ NWAYS * frame_tag ] ] }
frame_tag_t [NWAYS-1:0] set_tags [NSETS-1:0];
frame_tag_t [NWAYS-1:0] set_tag;
frame_tag_t frame_tag, n_frame_tag, w_frame_tag;
// { set_values [ NSETS * set_value [ NWAYS * frame_value ] ] }
frame_value_t [NWAYS-1:0] set_values [NSETS-1:0];
frame_value_t [NWAYS-1:0] set_value;
frame_value_t frame_value, n_frame_value, w_frame_value;
// lru, this method only works for NWAYS = 2
logic success;
word_t rmwstate, return_value;
logic doDataWrite;
logic lrus [NSETS-1:0]; // ~last used way
logic n_lru;

logic tag_WEN, value_WEN;
logic cache_hit;
logic way_select, w_way_select;
logic w_dirty_frame;
address_t address, saddress;

logic way_count, n_way_count;
logic [3:0] set_count;
logic [3:0] n_set_count;
logic flush_wait;

assign address = ccif.ccwait[CPUID] ? ccif.ccsnoopaddr[CPUID] : dcif.dmemaddr;
assign set_tag = set_tags[address.indexer];
assign set_value = set_values[address.indexer];
assign frame_tag = set_tag[way_select];
assign frame_value = set_value[way_select];
assign cache_hit = (set_tag[0].valid & (set_tag[0].tag == address.tag)) | (set_tag[1].valid & (set_tag[1].tag == address.tag));
assign way_select = (set_tag[1].valid & (set_tag[1].tag == address.tag)) ? 1'b1 : 1'b0; // if hit this is the way to go
assign dcif.dmemload = (dcif.datomic && dcif.dmemWEN) ? return_value : frame_value.values[address.blockoffset];
//assign dcif.dhit = ((cache_hit === 1) & (doDataWrite | dcif.dmemREN) & ~ccif.ccwait[CPUID]) | (dcif.datomic && dcif.dmemWEN && (~(rmwstate == dcif.dmemaddr) | ((rmwstate == dcif.dmemaddr) && ~success)));
assign dcif.dhit = ~ccif.ccwait[CPUID] & ~ccif.ccinv[CPUID] & (((cache_hit === 1) & (doDataWrite & frame_tag.dirty | dcif.dmemREN)) | (dcif.datomic && dcif.dmemWEN && (~(rmwstate == dcif.dmemaddr) | ((rmwstate == dcif.dmemaddr) && ~success))));
//assign dcif.dhit = ~ccif.ccwait[CPUID] & (((cache_hit === 1) & (doDataWrite | dcif.dmemREN)) | (dcif.datomic & dcif.dmemWEN & ~(rmwstate == dcif.dmemaddr) && ~success));

assign w_way_select = cache_hit ? way_select : lrus[address.indexer];
assign w_frame_tag = set_tag[w_way_select];
assign w_frame_value = set_value[w_way_select];
assign w_dirty_frame = w_frame_tag.dirty & w_frame_tag.valid;

assign doDataWrite = ~dcif.datomic ? dcif.dmemWEN : (dcif.datomic && dcif.dmemWEN && (rmwstate == dcif.dmemaddr) && success);
always_ff @ (posedge CLK, negedge nRST) begin
  if(~nRST) begin
    rmwstate <= '0;
    success <= 0;
  end
  //else if (dcif.datomic && dcif.dmemREN) begin
  else if (dcif.datomic && dcif.dmemREN & ~ccif.ccwait[CPUID]) begin
    rmwstate <= dcif.dmemaddr;
    success <= 1;
  end
  //else if (dcif.datomic && dcif.dmemWEN) begin
  else if (dcif.datomic && dcif.dmemWEN & ~ccif.ccwait[CPUID]) begin
    if ((rmwstate == dcif.dmemaddr) && success & frame_tag.dirty & ~ccif.ccinv[CPUID]) begin
      success <= 0;
      rmwstate <= 0;
    end
  end
  else if(~dcif.datomic & dcif.dmemWEN & ~ccif.ccwait[CPUID]) begin
      success <= 0;
      rmwstate <= 0;
  end
  //else if (address == rmwstate) begin
  else if ((ccif.ccsnoopaddr[CPUID] == rmwstate) & ccif.ccwait[CPUID]) begin
      success <= 0;
      rmwstate <= 0;
  end
end

assign return_value = (dcif.datomic && dcif.dmemWEN && success && (rmwstate == dcif.dmemaddr));

always_ff @(posedge CLK, negedge nRST) begin
  if(nRST == 0) begin
    saddress <= address_t'(0);
  end
  else begin
    saddress <= address;
  end
end

integer i, j;
always_ff @(posedge CLK, negedge nRST) begin
  if(nRST == 0) begin
    state <= IDLE;
    set_count <= '0;
    way_count <= '0;
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
      set_values[address.indexer][w_way_select] <= n_frame_value;
    end
    if(tag_WEN) begin
      set_tags[address.indexer][w_way_select] <= n_frame_tag;
    end
    state <= n_state;
    set_count <= n_set_count;
    way_count <= n_way_count;
    lrus[address.indexer] <= n_lru;
  end
end

always_comb begin
  casez(state)
    IDLE: begin
      if(ccif.ccwait[CPUID] & ccif.ccinv[CPUID] & cache_hit) begin
        n_state = INVALIDATE;
      end
      else if(ccif.ccwait[CPUID] & ~ccif.ccinv[CPUID] & cache_hit) begin
        n_state = SEND_READDATA0;
      end
      else if((doDataWrite | dcif.dmemREN) & ~cache_hit & w_dirty_frame & ~ccif.ccwait[CPUID]) begin
        n_state = WRITEBACK0;
      end
      else if(dcif.dmemREN & ~cache_hit & ~w_dirty_frame & ~ccif.ccwait[CPUID]) begin
        n_state = FETCH0;
      end
      else if(doDataWrite & ~cache_hit & ~w_dirty_frame & ~ccif.ccwait[CPUID]) begin
        n_state = FETCH_WRITE;
      end
      else if(dcif.halt) begin
        n_state = FLUSH0;
      end
      else begin
        n_state = IDLE;
      end
    end
    INVALIDATE: begin
      if(~ccif.dwait[CPUID] | ~frame_tag.dirty) begin
        n_state = IDLE;
      end
      else begin
        n_state = INVALIDATE;
      end
    end
    SEND_READDATA0: begin
      if(~ccif.dwait[CPUID]) begin
        n_state = SEND_READDATA1;
      end
      else begin
        n_state = SEND_READDATA0;
      end
    end
    SEND_READDATA1: begin
      if(~ccif.dwait[CPUID]) begin
        n_state = IDLE;
      end
      else begin
        n_state = SEND_READDATA1;
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
        if(doDataWrite) begin
          n_state = FETCH_WRITE;
        end
        else begin
          n_state = FETCH0;
        end
      end
    end
    FETCH0: begin
      if(ccif.ccwait[CPUID] & ~ccif.ccinv[CPUID] & cache_hit) begin
        n_state = SEND_READDATA0;
      end
      else if(ccif.ccwait[CPUID] & ~ccif.ccinv[CPUID] & ~cache_hit) begin
        n_state = IDLE;
      end
      else if(ccif.dwait[CPUID]) begin
        n_state = FETCH0;
      end
      else begin
        n_state = FETCH1;
      end
    end
    FETCH1: begin
      if(ccif.ccwait[CPUID] & ~ccif.ccinv[CPUID] & cache_hit) begin
        n_state = SEND_READDATA0;
      end
      else if(ccif.ccwait[CPUID] & ~ccif.ccinv[CPUID] & ~cache_hit) begin
        n_state = IDLE;
      end
      else if(ccif.dwait[CPUID]) begin
        n_state = FETCH1;
      end
      else begin
        n_state = IDLE;
      end
    end
    FETCH_WRITE: begin
      if(ccif.ccwait[CPUID] & ccif.ccinv[CPUID] & cache_hit) begin
        n_state = INVALIDATE;
      end
      else if(ccif.ccwait[CPUID] & ccif.ccinv[CPUID] & ~cache_hit) begin
        n_state = IDLE;
      end
      else if(ccif.ccwait[CPUID] & ~ccif.ccinv[CPUID] & cache_hit) begin
        n_state = SEND_READDATA0;
      end
      else if(ccif.dwait[CPUID]) begin
        n_state = FETCH_WRITE;
      end
      else begin
        n_state = IDLE;
      end
    end
    FLUSH0: begin
      if(ccif.ccwait[CPUID] & ccif.ccinv[CPUID] & cache_hit) begin
        n_state = INVALIDATE;
      end
      else if(ccif.ccwait[CPUID] & ccif.ccinv[CPUID] & ~cache_hit) begin
        n_state = IDLE;
      end
      else if(ccif.ccwait[CPUID] & ~ccif.ccinv[CPUID] & cache_hit) begin
        n_state = SEND_READDATA0;
      end
      else if(set_count >= NSETS) begin
        n_state = FLUSH_END;
      end
      else if(~flush_wait) begin
        n_state = FLUSH1;
      end
      else begin
        n_state = FLUSH0;
      end
    end
    FLUSH1: begin
      if(ccif.ccwait[CPUID] & ccif.ccinv[CPUID] & cache_hit) begin
        n_state = INVALIDATE;
      end
      else if(ccif.ccwait[CPUID] & ccif.ccinv[CPUID] & ~cache_hit) begin
        n_state = IDLE;
      end
      else if(ccif.ccwait[CPUID] & ~ccif.ccinv[CPUID] & cache_hit) begin
        n_state = SEND_READDATA0;
      end
      else if(~flush_wait) begin
        n_state = FLUSH0;
      end
      else begin
        n_state = FLUSH1;
      end
    end
    FLUSH_END: begin
      n_state = FLUSH_END;
    end
    default : n_state = IDLE;
  endcase
end

always @(*) begin
  ccif.dstore[CPUID] = word_t'('0);
  dcif.flushed = 0;

  n_frame_value.values[0] = '0;
  n_frame_value.values[1] = '0;
  n_frame_tag.valid = 0;
  n_frame_tag.dirty = 0;
  n_frame_tag.tag = address.tag;

  tag_WEN = 0; value_WEN = 0;
  n_lru = lrus[address.indexer];
  n_set_count = set_count;
  n_way_count = way_count;
  flush_wait = 1;

  casez(state)
    IDLE: begin
      ccif.ccwrite[CPUID] = 0;
      ccif.cctrans[CPUID] = 0;
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = dcif.dmemaddr;
      if(doDataWrite & cache_hit & ~ccif.ccwait[CPUID]) begin
        n_frame_value.values[0] = address.blockoffset ? frame_value.values[0] : dcif.dmemstore;
        n_frame_value.values[1] = address.blockoffset ? dcif.dmemstore : frame_value.values[1];
        n_frame_tag.dirty = 1;
        n_frame_tag.valid = 1;
        tag_WEN = 1;
        value_WEN = 1;
        ccif.cctrans[CPUID] = ~frame_tag.dirty;
        ccif.ccwrite[CPUID] = ~frame_tag.dirty;
      end
      if((dcif.dmemREN | doDataWrite) & cache_hit) begin
        n_lru = ~w_way_select;
      end
    end
    INVALIDATE: begin
      n_frame_tag.dirty = 0;
      n_frame_tag.valid = 0;
      tag_WEN = ~ccif.dwait[CPUID] | ~frame_tag.dirty;
      ccif.cctrans[CPUID] = 1;
      ccif.ccwrite[CPUID] = frame_tag.dirty;
      ccif.dstore[CPUID] = frame_value.values[saddress.blockoffset];
      ccif.daddr[CPUID] = saddress;
      ccif.dWEN[CPUID] = frame_tag.dirty;
      ccif.dREN[CPUID] = 0;
    end
    SEND_READDATA0: begin
      n_frame_tag.dirty = 0;
      n_frame_tag.valid = 1;
      tag_WEN = 1;
      ccif.cctrans[CPUID] = 1;
      ccif.ccwrite[CPUID] = 0;
      ccif.dstore[CPUID] = frame_value.values[0];
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 1;
      ccif.daddr[CPUID] = word_t'({ saddress.tag, saddress.indexer, 3'b000 }); // blockoffset = 0
    end
    SEND_READDATA1: begin
      n_frame_tag.dirty = 0;
      n_frame_tag.valid = 1;
      tag_WEN = 1;
      ccif.cctrans[CPUID] = 1;
      ccif.ccwrite[CPUID] = 0;
      ccif.dstore[CPUID] = frame_value.values[1];
      ccif.dWEN[CPUID] = 1;
      ccif.dREN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'({ saddress.tag, saddress.indexer, 3'b100 }); // blockoffset = 1
    end
    WRITEBACK0: begin
      ccif.ccwrite[CPUID] = 0;
      ccif.cctrans[CPUID] = 0;
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 1;
      ccif.daddr[CPUID] = word_t'({ w_frame_tag.tag, saddress.indexer, 3'b000 }); // blockoffset = 0
      ccif.dstore[CPUID] = w_frame_value.values[0];
    end
    WRITEBACK1: begin
      ccif.ccwrite[CPUID] = 0;
      ccif.cctrans[CPUID] = 0;
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 1;
      ccif.daddr[CPUID] = word_t'({ w_frame_tag.tag, saddress.indexer, 3'b100 });
      ccif.dstore[CPUID] = w_frame_value.values[1];
    end
    FETCH0: begin
      ccif.cctrans[CPUID] = 1;
      ccif.ccwrite[CPUID] = 0;
      ccif.dREN[CPUID] = 1;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'({ saddress.tag, saddress.indexer, 3'b000 }); // blockoffset = 0
      n_frame_value.values[0] = ccif.dload[CPUID];
      // n_frame_value.values[1] = '0; will be replaced in next state
      value_WEN = ~ccif.ccwait[CPUID];
    end
    FETCH1: begin
      ccif.dREN[CPUID] = 1;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'({ saddress.tag, saddress.indexer, 3'b100 });
      n_frame_value.values[0] = w_frame_value.values[0];
      n_frame_value.values[1] = ccif.dload[CPUID];
      n_frame_tag.valid = ~ccif.dwait[CPUID];
      n_frame_tag.dirty = 0;
      tag_WEN = ~ccif.ccwait[CPUID];
      value_WEN = ~ccif.ccwait[CPUID];
      ccif.cctrans[CPUID] = 1;
      ccif.ccwrite[CPUID] = 0;
    end
    FETCH_WRITE: begin
      ccif.dREN[CPUID] = 1;
      ccif.dWEN[CPUID] = 0;
      // set ccif.dload
      ccif.daddr[CPUID] = word_t'({ saddress.tag, saddress.indexer, ~saddress.blockoffset, 2'b00 });
      n_frame_value.values[0] = saddress.blockoffset ? ccif.dload[CPUID] : dcif.dmemstore;
      n_frame_value.values[1] = saddress.blockoffset ? dcif.dmemstore : ccif.dload[CPUID];
      n_frame_tag.valid = ~ccif.dwait[CPUID];
      tag_WEN = ~ccif.ccwait[CPUID];
      value_WEN = ~ccif.ccwait[CPUID];
      ccif.cctrans[CPUID] = 1;
      ccif.ccwrite[CPUID] = 1;
    end
    FLUSH0: begin
      ccif.dREN[CPUID] = 0;
      ccif.ccwrite[CPUID] = 0;
      ccif.cctrans[CPUID] = 0;
      if(set_tags[set_count][way_count].dirty) begin
        flush_wait = ccif.dwait[CPUID];
        ccif.dWEN[CPUID] = 1;
        ccif.daddr[CPUID] = { set_tags[set_count][way_count].tag, set_count[2:0], 3'b000 };
        ccif.dstore[CPUID] = set_values[set_count][way_count].values[0];
      end
      else begin
        ccif.dWEN[CPUID] = 0;
        flush_wait = 0;
        ccif.daddr[CPUID] = word_t'('0);
      end
    end
    FLUSH1: begin
      ccif.dREN[CPUID] = 0;
      ccif.ccwrite[CPUID] = 0;
      ccif.cctrans[CPUID] = 0;
      if(set_tags[set_count][way_count].dirty) begin
        flush_wait = ccif.dwait[CPUID];
        ccif.dWEN[CPUID] = 1;
        ccif.daddr[CPUID] = { set_tags[set_count][way_count].tag, set_count[2:0], 3'b100 };
        ccif.dstore[CPUID] = set_values[set_count][way_count].values[1];
        if(~ccif.dwait[CPUID]) begin
          n_set_count = way_count ? set_count + 1'b1 : set_count;
          n_way_count = ~way_count;
        end
      end
      else begin
        ccif.dWEN[CPUID] = 0;
        flush_wait = 0;
        ccif.daddr[CPUID] = word_t'('0);
        n_set_count = way_count ? set_count + 1'b1 : set_count;
        n_way_count = ~way_count;
      end
    end
    FLUSH_END: begin
      ccif.ccwrite[CPUID] = 0;
      ccif.cctrans[CPUID] = 0;
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'('0);
      dcif.flushed = 1;
    end
    default: begin
      ccif.ccwrite[CPUID] = 0;
      ccif.cctrans[CPUID] = 0;
      ccif.dREN[CPUID] = 0;
      ccif.dWEN[CPUID] = 0;
      ccif.daddr[CPUID] = word_t'('0);
    end
  endcase
end

endmodule
