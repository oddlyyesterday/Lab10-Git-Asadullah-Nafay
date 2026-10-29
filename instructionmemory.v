`timescale 1ns / 1ps
// Lab 10 - Task 3: Instruction memory
// Byte-addressable 256-byte ROM; returns the 32-bit instruction at the PC.
// RISC-V is little-endian: the byte at the lowest address is bits [7:0].
module instructionMemory #(
    parameter OPERAND_LENGTH = 31
)(
    input      [OPERAND_LENGTH:0] instAddress,   // PC
    output reg [31:0]             instruction
);
    reg [7:0] memory [0:255];

    // Load machine code (one byte per line, address 0 first)
    initial begin
        $readmemh("instructions.mem", memory);
    end

    always @(*) begin
        instruction = { memory[instAddress[7:0] + 3],
                        memory[instAddress[7:0] + 2],
                        memory[instAddress[7:0] + 1],
                        memory[instAddress[7:0]    ] };
    end
endmodule