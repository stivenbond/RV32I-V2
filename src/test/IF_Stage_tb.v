`timescale 1ns/1ps
module IF_Stage_tb;
    reg clk, reset;
    reg [31:0] pc_next;
    wire [31:0] instr, pc_out;

    // Instantiate the IF Stage
    IF_Stage uut (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .instr(instr),
        .pc_out(pc_out)
    );

    // Generate Clock (50MHz)
    always #10 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0;
        reset = 1;
        pc_next = 0;
        #20 reset = 0;  // Deassert reset
        
        // Test 1: Check first instruction fetch
        #20 pc_next = 4;
        #20 pc_next = 8;
        #20 pc_next = 12;
        
        // End Simulation
        #50 $stop;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time=%0t, PC=%h, Instr=%h", $time, pc_out, instr);
    end
endmodule
