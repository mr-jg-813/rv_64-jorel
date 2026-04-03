`timescale 1ns / 1ps

module registers(
    input             clk,
    input             reg_rd_en,reg_wr_en,
    input      [4:0]  reg_addr1, reg_addr2, reg_addr3, 
    input      [63:0] reg_data3, 
    output reg [63:0] reg_data1, reg_data2 
    );
reg [63:0] reg_mem [0:31];
integer i;   

initial begin
    for (i = 0; i < 32; i = i + 1) begin // initialising values in inst memory
        reg_mem[i] = i & 64'hffffffffffffffff;
    end
end
always@ (*) begin
reg_data1 = reg_mem[reg_addr1];
reg_data2 = reg_mem[reg_addr2];
end

always@ (posedge clk) begin
if (reg_wr_en) 
    reg_mem[reg_addr3] <= reg_data3; 
end

endmodule
