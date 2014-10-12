`include "branch_predictor_if.vh"

// lazy way to implement just 4 entry branch target buffer
// TODO make this parameterizable
module branch_predictor
(
  input logic CLK, nRST,
  branch_predictor_if.bi bpif
);

// { active, tag, target }
logic [58:0] entry_0;
logic [58:0] entry_1;
logic [58:0] entry_2;
logic [58:0] entry_3;

always_comb begin
  casez(bpif.hash_sel)
    2'b00: begin
      bpif.hit = entry_0[57:30] == bpif.tag_sel & entry_0[58];
      bpif.target = entry_0[29:0];
    end
    2'b01: begin
      bpif.hit = entry_1[57:30] == bpif.tag_sel & entry_1[58];
      bpif.target = entry_1[29:0];
    end
    2'b10: begin
      bpif.hit = entry_2[57:30] == bpif.tag_sel & entry_2[58];
      bpif.target = entry_2[29:0];
    end
    2'b11: begin
      bpif.hit = entry_3[57:30] == bpif.tag_sel & entry_3[58];
      bpif.target = entry_3[29:0];
    end
    default: begin
      bpif.hit = 0;
      bpif.target = '0;
    end
  endcase
end

always_ff @(negedge CLK, negedge nRST) begin
  if(~nRST) begin
    entry_0 <= '0;
    entry_1 <= '0;
    entry_2 <= '0;
    entry_3 <= '0;
  end
  else if(bpif.WEN) begin
    casez(bpif.hash_wsel)
      2'b00: begin
        entry_0[29:0] <= bpif.target_n;
        entry_0[57:30] <= bpif.tag_n;
        entry_0[58] <= bpif.active_n;
      end
      2'b01: begin
        entry_1[29:0] <= bpif.target_n;
        entry_1[57:30] <= bpif.tag_n;
        entry_1[58] <= bpif.active_n;
      end
      2'b10: begin
        entry_2[29:0] <= bpif.target_n;
        entry_2[57:30] <= bpif.tag_n;
        entry_2[58] <= bpif.active_n;
      end
      2'b11: begin
        entry_3[29:0] <= bpif.target_n;
        entry_3[57:30] <= bpif.tag_n;
        entry_3[58] <= bpif.active_n;
      end
    endcase
  end
end

endmodule
