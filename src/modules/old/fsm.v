module fsm (
  input wire clk,

  input wire [11:0] b_addr,
  output reg [11:0] pc,
  
  input wire [31:0] ac,

  input wire [31:0] i_instr,

  output reg [19:0] imm,
  output reg [6:0] opcode,
  output reg [2:0] funct3,
  output reg [6:0] funct7,

  output wire mem_we
);
  reg [2:0] state;

  initial begin
    state <= 3'b000;
  end

  always @(posedge clk) begin
    case (state)
        3'b000: begin
            pc <= pc + 4;
            state <= 3'b001;
        end
        3'b001: begin
            funct3<=i_instr[9:7];
            funct<=i_instr[]
            opcode <= i_instr[6:0];
            case (opcode) // imm calculation
                7'b0110011: imm <= 20'b0;
                7'b0010011: imm <= i_instr[31:20];
                7'b1100011: imm <= {i_instr[31], i_instr[7], i_instr[30:26], i_instr[12:8]};
                7'b0000011: imm <= i_instr[31:20]; 
                7'b0100011: imm <= {i_instr[31:25], i_instr[11:7]};
                7'b1101111: imm <= {i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:21]};
                7'b1100111: imm <= i_instr[31:20];
                7'b0110111: imm <= i_instr[31:12];
                7'b0010111: imm <= i_instr[31:12];
                default: 20'b0;
            endcase

            state <= 3'b010;
        end
        3'010: begin
            
            state <= 3'b011
          end
        3'b011: begin
            case(opcode)
               7'b0100011: mem_we <=1;
               default: mem_we <=0;
            endcase
            state <= 3'b100;
        end
        3'b100: begin
            rd <= ac;
          if ( b == 1 ) begin
              pc <= ac; 
            end
            else begin
              pc <= pc + 4;
            end 
            state <= 3'b000;
        end
    endcase
  end


endmodule
