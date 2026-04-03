`timescale 1ns / 1ps

module fetch(                        
    input        clk ,
    input        rst ,
    input        stall_in ,
    input        flush_in ,
    input        b_tkn ,
    input [63:0] b_trgt ,
    
    output reg [63:0] inst_addr_out,  
    output reg [31:0] inst_out ,
    output reg [63:0] PC 
    );   
reg         inst_rd_en;  
wire [31:0] inst;
   
always @(posedge clk) begin
    if (rst) begin
        PC           <= 64'h0;
        inst_rd_en   <= 1'b0;
        inst_addr_out<= 64'h0;end
        
    else if (stall_in) begin
        inst_rd_en <= 1'b0;end
            
    else begin
       inst_rd_en <= 1'b1; 
       inst_addr_out <= PC; 
       
       case (b_tkn)
            1'b0: PC <= PC + 64'd4;
            1'b1: PC <= PC + $signed(b_trgt);
        endcase end
        
end

inst_mem imem(
    .PC(inst_addr_out), 
    .inst(inst), 
    .inst_rd_en(inst_rd_en));  
    
always@(*) begin
if (flush_in) 
    inst_out = 32'h0;
else
    inst_out = inst; 
end

endmodule
