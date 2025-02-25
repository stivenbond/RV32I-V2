module rom (
    input wire i_clk,
    input wire [11:0] i_addr,

    output reg [31:0] o_inst
);
    reg [8:0] memory [4095:0];
    
    always @(posedge i_clk) begin
      o_inst[7:0] <= memory[i_addr];
      o_inst[15:8] <= memory[i_addr + 1];
      o_inst[23:16] <= memory[i_addr + 2];
      o_inst[31:24] <= memory[i_addr + 3];
    end 
endmodule
