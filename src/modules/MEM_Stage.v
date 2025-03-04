// Module for Stage 4 of the CPU
module MEM_Stage (
    input logic clk,
    input logic [31:0] alu_result, rs2_data,
    input logic mem_write, mem_read,
    output logic [31:0] mem_data
);
    logic [31:0] data_mem [0:255]; // Placeholder memory

    always_ff @(posedge clk) begin
        if (mem_write)
            data_mem[alu_result >> 2] <= rs2_data;
    end

    assign mem_data = mem_read ? data_mem[alu_result >> 2] : 0;
endmodule
