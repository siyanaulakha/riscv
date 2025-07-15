`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2025 03:36:32
// Design Name: 
// Module Name: instr_mem
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


module instr_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 512) (
    input       [ADDR_WIDTH-1:0] instr_addr,
    output      [DATA_WIDTH-1:0] instr
);


reg [DATA_WIDTH-1:0] instr_ram [0:MEM_SIZE-1];

initial begin
    //$readmemh("rv32i_book.hex", instr_ram);
$readmemh("rv32i_test.hex", instr_ram);
$display("Instruction[0] = %h", instr_ram[0]);
$display("Instruction[1] = %h", instr_ram[1]);


end


assign instr = instr_ram[instr_addr[31:2]];

endmodule

