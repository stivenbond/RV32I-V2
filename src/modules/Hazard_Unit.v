// Module for a Hazard Detection Unit
module Hazard_Unit (
    input logic [4:0] rs1, rs2, ex_rd, mem_rd,
    input logic ex_mem_read,
    output logic stall
);
    always_comb begin
        stall = (ex_mem_read && (ex_rd == rs1 || ex_rd == rs2));
    end
endmodule
