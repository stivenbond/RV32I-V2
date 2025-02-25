module alu (
    //Reset
    input wire rst,

    //Input data
    input wire [31:0] rs1, rs2,
    input wire [20:0] imm,
    input wire [11:0] i_current_pc,
    
    //Control signals
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    input wire [6:0] funct7,
    
    //Size of operation
    output wire o_byte,
    output wire o_half,
    output wire o_word
    
    //Branching Condition
    output reg b,

    //Output data
    output wire [11:0] mem_store_addr,
    output reg [31:0] mem_data,
    output reg [31:0] ac,
);
    always @(*) begin
        
        reg [31:0] current_pc <= i_current_pc;
        
        if (rst) begin
            memory_data <= 0;
            ac <=0;
            b <=0;
            o_byte <=0;
            o_half<=0;
            o_word <=0;
            current_pc <=0;
        end
        case (opcode)
            7'b0110011: begin // R-TYPE Instructions
                case (funct3)
                    3'b000: begin
                        case (funct7)
                            7'b0000000: ac <= rs1 + rs2; // ADD
                            7'b0100000: ac <= rs1 - rs2; // SUB
                            default: ac <= 32'b0;
                        endcase
                    end
                    3'b001: ac <= rs1 << rs2; // SLL
                    3'b010: ac <= ($signed(rs1) < $signed(rs2)) ? 1 : 0; // SLT
                    3'b011: ac <= (rs1 < rs2) ? 1 : 0; // SLTU
                    3'b100: ac <= rs1 ^ rs2; // XOR
                    3'b101: begin
                        case (funct7)
                            7'b0000000: ac <= rs1 >> rs2; // SRL
                            7'b0100000: ac <= $signed(rs1) >>> rs2; // SRA
                            default: ac <= 32'b0;
                        endcase
                    end
                    3'b110: ac <= rs1 | rs2; // OR
                    3'b111: ac <= rs1 & rs2; // AND
                    default: ac <= 32'b0;
                endcase
            end
            
            7'b0010011: begin // I-TYPE Instructions
                case (funct3)
                    3'b000: ac <= rs1 + imm; // ADDI
                    3'b010: ac <= ($signed(rs1) < $signed(imm)) ? 1 : 0; // SLTI
                    3'b011: ac <= (rs1 < imm) ? 1 : 0; // SLTIU
                    3'b100: ac <= rs1 ^ imm; // XORI
                    3'b110: ac <= rs1 | imm; // ORI
                    3'b111: ac <= rs1 & imm; // ANDI
                    3'b001: ac <= rs1 << imm[4:0]; // SLLI
                    3'b101: begin
                        case (funct7)
                            7'b0000000: ac <= rs1 >> imm[4:0]; // SRLI
                            7'b0100000: ac <= $signed(rs1) >>> imm[4:0]; // SRAI
                            default: ac <= 32'b0;
                        endcase
                    end
                    default: ac <= 32'b0;
                endcase
            end
            
            7'b1100011: begin // B-TYPE (Branch) Instructions
                case (funct3)
                    3'b000: b <= (rs1 == rs2) ? 1 : 0; // BEQ
                    3'b001: b <= (rs1 != rs2) ? 1 : 0; // BNE
                    3'b100: b <= ($signed(rs1) < $signed(rs2)) ? 1 : 0; // BLT
                    3'b101: b <= ($signed(rs1) >= $signed(rs2)) ? 1 : 0; // BGE
                    3'b110: b <= (rs1 < rs2) ? 1 : 0; // BLTU
                    3'b111: b <= (rs1 >= rs2) ? 1 : 0; // BGEU
                    default: b <= 1'b0;
                endcase
                if (b) begin
                    ac <= current_pc + imm;
                end
            end
            // TODO the mem_store_addr should be made mem_addr and keep the
            // addresses for store and load operations, and the I_we ahould
            // distinguish between load and store, logic should be implemented
            // in the alu_module and bypass the fsm, so the signal goes
            // directly to the data_mem
            7'b0000011: begin // Load Address Calculation (L-TYPE)
                case (funct3)
                  3'b000: begin
                    ac <= $signed(rs_1) + $signed(imm);
                    o_byte <= 1;
                  end
                  3'b001: begin
                    ac <= $signed(rs_1) + $signed(imm);
                    o_half <= 1;
                  end
                  3'b010: begin
                    ac <= $signed(rs_1) + $signed(imm);
                    o_word <= 1;
                  end
                  3'b100: begin
                    ac <= rs_1 + imm;
                    o_byte <= 1;
                  end
                  3'b101: begin
                    ac <= rs_1 + imm;
                    o_byte <= 1;
                  end
                endcase
            7'b0100011: begin // Store Address Calculation (S-TYPE)
                mem_store_addr <= rs1 + imm;
                mem_data <= rs2
                case(funct3)
                    3'b000: o_byte <= 1;
                    3'b001: o_half <= 1;
                    3'b010: o_word <= 1;
                endcase
            end
            7'b1101111: begin 
                ac <= current_pc + imm;
                b <= 1;
                mem_data <= current_pc + 4;
            end // JAL Address Calculation (J-TYPE)
            7'b1100111:  begin 
                ac <= rs1 + imm;
                b <= 1;
                mem_data <= current_pc + 4;
            end  // JALR Address Calculation (I-TYPE Jumps)
            7'b0110111: ac <= {rs2[19:0], 12'b0}; // LUI (Load Upper Immediate)
            7'b0010111: ac <= {rs2[19:0], 12'b0} + rs1; // AUIPC (Upper Immediate + PC)
            default: ac <= 32'b0;
        endcase
    end
endmodule
