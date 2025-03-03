module data_memory (
    input wire i_clk,
    input wire [11:0] i_start_address,
    input wire i_we,
    input wire i_byte,
    input wire i_half,
    input wire i_word,
    input reg [31:0] i_data,
    output reg [31:0] o_data 
);
    reg [8:0] memory [4095:0];

    always @(posedge i_clk) begin
      if (i_we) begin
        if (i_byte) begin
          memory[i_start_address] = i_data[7:0];
        end
        if (i_half) begin
          memory[i_start_address] = i_data[7:0];
          memory[i_start_address + 1] = i_data[15:8];
        end
        if (i_word) begin
          memory[i_start_address] = i_data[7:0];
          memory[i_start_address + 1] = i_data[15:8];
          memory[i_start_address + 2] = i_data[23:16];
          memory[i_start_address + 3] = i_data[31:24];
        end
      end
      else begin
        if (i_byte) begin
          o_data[7:0] = memory[i_start_address];
        end
        if (i_half) begin
          o_data[7:0] = memory[i_start_address];
          o_data[15:8] = memory[i_start_address + 1];
        end
        if (i_word) begin
          o_data[7:0] = memory[i_start_address];
          o_data[15:8] = memory[i_start_address + 1];
          o_data[23:16] = memory[i_start_address + 2];
          o_data[31:24] = memory[i_start_address + 3];
        end
      end
    end
endmodule
