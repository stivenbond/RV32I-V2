// Module for stage 1 of CPU
module IF_Stage (
    input logic clk, reset,
    input logic [31:0] pc_next,  // Next PC from branch unit or sequential execution
    output logic [31:0] instr,   // Fetched instruction
    output logic [31:0] pc_out   // Current PC (to be forwarded)
);
    logic [31:0] pc;
    
    // Instruction Memory (Replace with real memory later)
    logic [31:0] instr_mem [0:255];  // Placeholder instruction memory
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            pc <= 0;
        else
            pc <= pc_next;
    end
    
    assign instr = instr_mem[pc >> 2];  // Fetch instruction
    assign pc_out = pc;
endmodule
