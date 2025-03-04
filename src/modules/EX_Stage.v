// Module for Stage 3 of the CPU
module EX_Stage (
    input logic [31:0] rs1_data, rs2_data, imm,
    input logic [4:0] rd,
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic [31:0] alu_result,
    output logic branch_taken
);
    always_comb begin
        case (funct3)
            3'b000: alu_result = rs1_data + (opcode == 7'b0010011 ? imm : rs2_data); // ADDI/ADD
            3'b100: alu_result = rs1_data ^ rs2_data; // XOR
            3'b110: alu_result = rs1_data | rs2_data; // OR
            3'b111: alu_result = rs1_data & rs2_data; // AND
            default: alu_result = 0;
        endcase
        
        branch_taken = (opcode == 7'b1100011) && (rs1_data == rs2_data); // Simple BEQ
    end
endmodule
