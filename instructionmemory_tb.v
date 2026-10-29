`timescale 1ns / 1ps
module instructionMemory_tb;
    reg  [31:0] pc;
    wire [31:0] instr;
    integer i;

    instructionMemory uut (.instAddress(pc), .instruction(instr));

    initial begin
        // Step through the 25-instruction program, 4 bytes at a time
        for (i = 0; i < 25; i = i + 1) begin
            pc = i * 4;
            #10;
            $display("PC=0x%02h  instr=0x%08h", pc[7:0], instr);
        end
        $finish;
    end
endmodule