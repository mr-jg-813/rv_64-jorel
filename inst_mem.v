`timescale 1ns / 1ps

module inst_mem(
    input             inst_rd_en,
    input wire [63:0] PC, // program counter value
    output reg [31:0] inst // output inst from the inst memory
    );
    

integer i;
reg [7:0] mem1 [0:1024]; // array for inst memory

initial begin
    $readmemh("instr.mem", mem1);
end

always@(*) begin    
    if (inst_rd_en)                    
    inst = {mem1[PC + 3], mem1[PC + 2], mem1[PC + 1],mem1[PC]};
    // assigning 32 bit inst as value in memory with the PC address
    else
    inst = 32'h0;
end

endmodule
