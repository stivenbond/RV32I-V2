module unpipelined_rv32i_core (
    input wire clk,
    input wire rst
);

  // Internal wires
  wire [31:0] instr;           // Instruction from ROM
  wire [11:0] instr_addr;      // Instruction address
  wire [11:0] mem_addr;        // Memory address
  wire [31:0] rs1_data;        // Data from register rs1
  wire [31:0] rs2_data;        // Data from register rs2
  wire [4:0] rs1_addr;         // Register rs1 address
  wire [4:0] rs2_addr;         // Register rs2 address
  wire [19:0] imm;             // Immediate value
  wire branch_condition;       // Condition for branch decision
  wire mem_we;                 // Memory write enable
  wire siye_byte;              // Byte-size store enable
  wire siye_half;              // Half-word size store enable
  wire siye_word;              // Word-size store enable
  wire [11:0] branch_addr;     // Branch address
  wire [6:0] opcode;           // Opcode from control unit
  wire [2:0] funct3;           // Function 3 from instruction
  wire [6:0] funct7;           // Function 7 from instruction

  // Modules instantiation
  
  // ALU (Arithmetic Logic Unit)
  alu ALU (
    .clk(clk),
    .rst(rst),
    .rs1(rs1_data),
    .rs2(rs2_data),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .mem_data(),                  // ALU result to memory
    .ac(),                         // Accumulator output from ALU
    .mem_store_addr(mem_addr),     // Address for storing data
    .b(branch_condition),          // Branch condition
    .o_byte(siye_byte),            // Byte store enable
    .o_half(siye_half),            // Half-word store enable
    .o_word(siye_word),            // Word store enable
    .current_pc(instr_addr)        // Program counter value
  );

  // Control unit (FSM)
  fsm CTRL (
    .clk(clk),
    .pc(instr_addr),
    .ir(instr),
    .ar(mem_addr),
    .imm(imm),
    .ac(),                         // ALU accumulator
    .opcode(opcode),
    .mem_we(mem_we),
    .state()                       // Control states for the FSM
  );

  // Data Memory
  data_memory M (
    .i_start_address(mem_addr),
    .i_we(mem_we),                 // Write enable for memory
    .i_byte(siye_byte),
    .i_half(siye_half),
    .i_word(siye_word),
    .i_data(rs1_data),             // Data to be written into memory
    .o_data(rs2_data)              // Data read from memory
  );

  // Register File
  register_file R (
    .i_clk(clk),
    .i_rs(rs1_addr),               // Register file read address for rs1
    .i_we(mem_we),                 // Register write enable
    .i_rd(rs2_data),               // Data to write to register
    .i_rd_addr(rs2_addr),          // Register write address
    .i_rs1_addr(rs1_addr),         // Register rs1 address
    .i_rs2_addr(rs2_addr),         // Register rs2 address
    .o_rs1(rs1_data),              // Data read from rs1
    .o_rs2(rs2_data)               // Data read from rs2
  );

  // ROM (Instruction memory)
  rom ROM (
    .i_clk(clk),
    .i_addr(instr_addr),           // Instruction address
    .o_inst(instr)                 // Instruction fetched from ROM
  );

endmodule
