`timescale 1ns / 1ps

module memory(
    input        clk,
    input [4:0]  rd_in,
    input [63:0] data_in, 
    input        mem_en,
    input        lb, lh, lw, lbu, lhu,
    input        sb, sh, sw,
    input [63:0] addr,
    
    output reg [63:0] data_out,
    output reg [4:0]  rd_out
    );
reg [7:0] mem [0:1024];
reg [7:0] b1, b2, b3, b4, b5, b6, b7, b8;
integer i;
initial begin
for (i = 0; i < 1024; i = i+1)
mem[i] = 8'h0;
end 
always@ (posedge clk) begin
b1     <= data_in [7:0];
b2     <= data_in [15:8];
b3     <= data_in [23:16];
b4     <= data_in [31:24];

b5     <= data_in [39:32];// dw
b6     <= data_in [47:40];// dw
b7     <= data_in [55:48];// dw
b8     <= data_in [63:56];// dw

rd_out <= rd_in;

if (mem_en) begin 
    case (1'b1)
    lb:  data_out <= {{56{mem[addr][7]}}, mem[addr]};
    lh:  data_out <= {{48{mem[addr + 1][7]}}, mem[addr + 1], mem[addr]};
    lw:  data_out <= {{32{mem[addr + 3][7]}},mem[addr + 3], mem[addr + 2], mem[addr + 1], mem[addr]};
    lbu: data_out <= {56'b0, mem[addr]};
    lhu: data_out <= {48'b0, mem[addr + 1], mem[addr]};
    sb: mem[addr] <= b1;
    sh: begin  mem[addr] <= b1; mem[addr + 1] <= b2; end
    sw: begin  mem[addr] <= b1; mem[addr + 1] <= b2; mem[addr + 2] <= b3; mem[addr + 3] <= b4; end
    endcase
end

else begin
    data_out <= addr; end
end

endmodule
