`timescale 1ns / 1ps

module rv64_main(
    input clk,rst    
    );    
wire        stall_in1;
wire        flush_in1;
wire        stall_in2;
wire        flush_in2;
wire        b_tkn;
wire [63:0] b_trgt;

wire [63:0] inst_addr_out;
wire [31:0] inst;
wire [63:0] PC;

assign stall_in1 = 1'b0;
assign flush_in1 = 1'b0;
assign stall_in2 = 1'b0;
assign flush_in2 = 1'b0;
assign b_tkn    = 1'b0;
assign b_trgt   = 64'h0;

fetch stage1(
    .clk          (clk),
    .rst          (rst),
    .stall_in     (stall_in1),
    .flush_in     (flush_in1),
    .b_tkn        (b_tkn),
    .b_trgt       (b_trgt),
    .inst_addr_out(inst_addr_out),
    .inst_out     (inst),
    .PC       (PC)
);

wire [63:0] reg_data1, reg_data2;
wire        R, I, L, S;      
wire [2:0]  func3;  
wire [6:0]  func7;             
wire [63:0] OP1, OP2;
wire        reg_rd_en;
wire [4:0]   rs1, rs2, rd1, rd2, rd3;
wire [63:0] rs2_data;
  

//assign stall_in2 = 1'b0;
//assign flush_in2 = 1'b0;
decode stage2( 
    .clk(clk),            
    .inst_addr(inst_addr_out),   
    .inst(inst),
    .reg_data1(reg_data1), 
    .reg_data2(reg_data2),         
    .R(R), .I(I), .L(L), .S(S),      
    .func3(func3),  
    .func7(func7),        
    .OP1(OP1), 
    .OP2(OP2),
    .reg_rd_en(reg_rd_en),
    .rd(rd1), 
    .rs1(rs1), 
    .rs2(rs2),
    .rs2_data(rs2_data)
    );
  
wire        reg_wr_en; 
wire [63:0] mem_data;

registers stage5(
   .clk(clk),
   .reg_rd_en(reg_rd_en),
   .reg_wr_en(reg_wr_en),
   .reg_addr1(rs1),
   .reg_addr2(rs2),
   .reg_data1(reg_data1),
   .reg_data2(reg_data2),
   
   .reg_data3(mem_data),
   .reg_addr3(rd3) );  
   
   
wire add, sub, sll, slt, sltu;  
wire srl, sra, or_, and_, xor_;
wire lb, lh, lw, lbu, lhu;
wire sb, sh, sw;   
 

control cont(
    .clk(clk),
    .R(R), .I(I), .L(L), .S(S),
    .func3(func3), 
    .func7(func7),
    
    .add(add),
    .sub(sub),
    .sll(sll), 
    .slt(slt), 
    .sltu(sltu), 
    .xor_(xor_), 
    .srl(srl), 
    .sra(sra), 
    .or_(or_), 
    .and_(and_), 
    
    .lb(lb), .lh(lh), .lw(lw), .lbu(lbu), .lhu(lhu),
    .sb(sb), .sh(sh), .sw(sw), .M(M),
    .reg_wr_en(reg_wr_en) );

wire [63:0] O;
ALU stage3(
    .clk(clk),
    .OP1(OP1),
    .OP2(OP2),
    .O(O),
    .rd_in(rd1),
    
    .rd_out(rd2),
    .add(add),
    .sub(sub),
    .sll(sll), 
    .slt(slt), 
    .sltu(sltu), 
    .xor_(xor_), 
    .srl(srl), 
    .sra(sra), 
    .or_(or_), 
    .and_(and_) );

 
memory stage4(
    .clk(clk), 
    .rd_in(rd2),
    .rd_out(rd3),
    .data_in(rs2_data), 
    .mem_en(M),
    .addr(O),
    
    .data_out(mem_data),    
    .lb(lb), 
    .lh(lh), 
    .lw(lw), 
    .lbu(lbu), 
    .lhu(lhu),
    .sb(sb), 
    .sh(sh), 
    .sw(sw) );
    
endmodule
