//Main CPU Module
module RV32I_CPU (
    input logic clk, reset,
    // Memory & IO signals (to ESP32)
);
    logic [31:0] pc_next, instr, pc_out, rs1_data, rs2_data, alu_result, mem_data;
    logic branch_taken;

    IF_Stage if_stage (.clk(clk), .reset(reset), .pc_next(pc_next), .instr(instr), .pc_out(pc_out));
    ID_Stage id_stage (.clk(clk), .instr(instr), /* more connections */);
    EX_Stage ex_stage (.rs1_data(rs1_data), .rs2_data(rs2_data), /* more connections */);
    MEM_Stage mem_stage (.clk(clk), /* more connections */);
    WB_Stage wb_stage (.alu_result(alu_result), /* more connections */);

    assign pc_next = branch_taken ? alu_result : pc_out + 4;
endmodule
