//Module for stage 5 of the CPU
module WB_Stage (
    input logic [31:0] mem_data, alu_result,
    input logic mem_to_reg,
    output logic [31:0] write_data
);
    assign write_data = mem_to_reg ? mem_data : alu_result;
endmodule
