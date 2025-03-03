module register_file (

    //Control Signals
    input wire clk,
    input wire rst,
    input wire write_enable,
    
    //Input data
    input wire [4:0] i_rd_addr,
    input wire [4:0] i_rs1_addr,
    input wire [4:0] i_rs2_addr,
    input wire [31:0] i_rd,

    //Output data
    output reg [31:0] o_rs1,
    output reg [31:0] o_rs2
);
  reg [31:0] registers [31:0];

  always @(*) begin
    o_rs1 = (i_rs1_addr == 0) ? 32'b0 : registers[i_rs1_addr];
    o_rs2 = (i_rs2_addr == 0) ? 32'b0 : registers[i_rs2_addr];

    if (i_rst) begin
      integer i;
      for (i = 0; i < 32; i = i + 1) begin
        registers[i] <= 32'b0;
      end
    end 
    else if (i_we && i_rd_addr != 0) begin
      registers[i_rd_addr] <= i_rd;
    end
  end
endmodule
