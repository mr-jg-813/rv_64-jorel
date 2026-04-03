`timescale 1ns / 1ps

module decode(
    input        clk,  // clock input signal
    input [63:0] inst_addr,   // Program counter value
    input [31:0] inst, // instruction,
    input stall_in,flush_in,

    input [63:0] reg_data1, reg_data2,
   
    output reg        R,I,L,S,
    output reg [2:0]  func3,
    output reg [6:0]  func7,
    
    output reg [63:0] OP1, OP2,
    output reg        reg_rd_en,
    output reg [4:0]  rd, rs1, rs2,
    output reg [63:0] rs2_data
    );
    
reg [6:0] opc;

reg [63:0] imm, imm_s, imm_b, imm_u, imm_j;

always@ (posedge clk) begin
opc   <= inst[6:0];
func3 <= inst[14:12];
func7 <= inst[31:25];

reg_rd_en <= 1'b0;
rd  <= inst[11:7];
rs1 <= inst[19:15];
rs2 <= inst[24:20];
R   <= 0;I <= 0;L <= 0;S <= 0;

imm   <= { {52{inst[31]}}, inst[31:20]};
imm_s <= { {52{inst[31]}}, inst[31:25], inst[11:7]};
imm_b <= { {51{inst[31]}}, inst[7], inst[30:25], inst[11:8],1'b0};
imm_u <= { {32{inst[31]}}, inst[31:12], 12'b0 };
imm_j <= {{43{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};

case(inst[6:0]) 
7'b0110011: begin R <= 1'b1; 
            reg_rd_en <= 1'b1; end
7'b0010011: begin I <= 1'b1; 
            reg_rd_en <= 1'b1; end 
7'b0100011: begin S <= 1'b1;
            reg_rd_en <= 1'b1;end
7'b0000011: begin L <= 1'b1;
            reg_rd_en <= 1'b1;end
endcase
end


always@ (*) begin
case(1'b1) 
R: begin OP1 <= reg_data1; OP2 = reg_data2;                   end
I: begin OP1 <= reg_data1; OP2 = imm;                         end
L: begin OP1 <= reg_data1; OP2 = imm;                         end
S: begin OP1 <= reg_data1; OP2 = imm_s; rs2_data = reg_data2; end
endcase
end

endmodule
