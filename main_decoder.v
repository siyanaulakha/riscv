`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2025 04:02:32
// Design Name: 
// Module Name: main_decoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// main_decoder.v - logic for main decoder

module main_decoder (
    input  [6:0] op,
    input  [2:0] funct3,
    input        Zero, ALUR31,        // Zero: result from SUB, ALUR31: sign bit of result
    output [1:0] ResultSrc,
    output       MemWrite, Branch, ALUSrc,
    output       RegWrite, Jump, Jalr,
    output [1:0] ImmSrc,
    output [1:0] ALUOp
);

reg [10:0] controls;
reg TakeBranch;
reg ALUUnsigned;  // Additional signal for unsigned comparisons

always @(*) begin
    TakeBranch = 0;
    ALUUnsigned = 0;  // Reset ALUUnsigned for signed comparisons by default
    casez (op)
        // RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_ALUOp_Jump_Jalr
        7'b0000011: controls = 11'b1_00_1_0_01_00_0_0; // lw
        7'b0100011: controls = 11'b0_01_1_1_00_00_0_0; // sw
        7'b0110011: controls = 11'b1_xx_0_0_00_10_0_0; // R-type
        7'b1100011: begin // Branch instructions
            controls = 11'b0_10_0_0_00_01_0_0;
            case (funct3)
                3'b000: TakeBranch =  Zero;       // beq
                3'b001: TakeBranch = !Zero;       // bne
                3'b100: TakeBranch =  ALUR31;     // blt (signed)
                3'b101: TakeBranch = !ALUR31;     // bge (signed)
                3'b110: begin                     // bltu (unsigned)
                    ALUUnsigned = 1;
                    TakeBranch = ALUR31;          // If result is negative, a < b (unsigned)
                end
                3'b111: begin                     // bgeu (unsigned)
                    ALUUnsigned = 1;
                    TakeBranch = !ALUR31;         // If result is non-negative, a >= b (unsigned)
                end
            endcase
        end
        7'b0010011: controls = 11'b1_00_1_0_00_10_0_0; // I-type ALU
        7'b1101111: controls = 11'b1_11_0_0_10_00_1_0; // jal
        7'b1100111: controls = 11'b1_00_1_0_10_00_0_1; // jalr
        7'b0?10111: controls = 11'b1_xx_x_0_11_xx_0_0; // lui or auipc
        default:    controls = 11'bx_xx_x_x_xx_xx_x_x;  // ???
    endcase
end

assign Branch = TakeBranch;
assign {RegWrite, ImmSrc, ALUSrc, MemWrite, ResultSrc, ALUOp, Jump, Jalr} = controls;

endmodule

