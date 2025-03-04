// Module for Stage 2 of CPU
module ID_Stage (
    input logic clk,
    input logic [31:0] instr,
    output logic [4:0] rs1, rs2, rd,
    output logic [31:0] imm,      // Immediate value
    output logic [6:0] opcode,    // Opcode
    output logic [2:0] funct3,
    output logic [6:0] funct7
);
    always_comb begin
        opcode = instr[6:0];
        rs1 = instr[19:15];
        rs2 = instr[24:20];
        rd = instr[11:7];
        funct3 = instr[14:12];
        funct7 = instr[31:25];

        case (opcode)
            7'b0000011: imm = {{20{instr[31]}}, instr[31:20]}; // Load
            7'b0100011: imm = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // Store
            default: imm = 0;
        endcase
    end
endmodule
