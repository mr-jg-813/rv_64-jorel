`timescale 1ns / 1ps

module control(
    input       clk,
    input       R,I,L,S,
    input [2:0] func3, 
    input [6:0] func7,
    output reg add, sub, sll, slt, sltu, 
    output reg xor_, srl, sra, or_, and_,
    output reg lb, lh, lw, lbu, lhu,
    output reg sb, sh, sw, M,
    output reg reg_wr_en
    );


reg add_r, sub_r, sll_r, slt_r, sltu_r; // reg type inst
reg xor_r, srl_r, sra_r, or_r, and_r;   // reg type inst

reg add_i, sub_i, sll_i, slt_i, sltu_i; // imm type inst
reg xor_i, srl_i, sra_i, or_i, and_i;   // imm type inst

reg lb_c, lh_c, lw_c, lbu_c, lhu_c;    // ld tpye inst
reg sb_c, sh_c, sw_c, m;               // st type inst

reg wr_en1, wr_en2;
 
always@ (*) begin
{add_r,sub_r,sll_r,slt_r,sltu_r,xor_r,srl_r,sra_r,or_r,and_r} = 10'b0;
{add_i,sll_i,slt_i,sltu_i,xor_i,srl_i,sra_i,or_i,and_i} = 9'b0;
{lb_c, lh_c, lw_c, lbu_c, lhu_c} = 5'b0;
{sb_c, sh_c, sw_c} = 3'b0;
m = 1'b0;
if (R) begin
    case (func3)
        3'b000: begin case(func7)
            7'h0 : add_r = 1;
            7'h20: sub_r = 1;
            endcase end     
        3'b001: sll_r  = 1;
        3'b010: slt_r  = 1;
        3'b011: sltu_r = 1;
        3'b100: xor_r  = 1;
        3'b101:begin case(func7)
            7'h0 : srl_r = 1;
            7'h20: sra_r = 1;
            endcase end
        3'b110: or_r  = 1;
        3'b111: and_r = 1;
              
    endcase
end
// >----------------------------------------------------------------
if (I) begin
    case (func3)
        3'b000: add_i  = 1;
        3'b001: sll_i  = 1;   
        3'b010: slt_i  = 1;
        3'b011: sltu_i = 1;
        3'b100: xor_i  = 1;             
        3'b101:begin case(func7)
            7'h0 : srl_i = 1;
            7'h20: sra_i = 1;
            endcase end
        3'b110: or_i   = 1;
        3'b111: and_i  = 1;
    endcase
end
// >----------------------------------------------------------------    
if (L) begin
    m = 1'b1;
    case (func3)
        3'b000: lb_c  = 1;
        3'b001: lh_c  = 1;   
        3'b010: lw_c  = 1;
        3'b100: lbu_c = 1;
        3'b101: lhu_c  = 1;                    
    endcase
    
end
// >------------------------------------------------------------------
if (S) begin
    m = 1'b1;
    case (func3)
        3'b000: sb_c = 1;
        3'b001: sh_c = 1;   
        3'b010: sw_c = 1;                   
    endcase 
end
end


always@ (*) begin
add  <= add_r | add_i | m;
sub  <= sub_r;
sll  <= sll_r | sll_i;
slt  <= slt_r | slt_i;
sltu <= sltu_r| sltu_i;
xor_ <= xor_r | xor_i;
srl  <= srl_r | srl_i;
sra  <= sra_r | sra_i;
or_  <= or_r  | or_i;
and_ <= and_r | and_i;

end
always@ (posedge clk) begin
M      <= m;
lb     <= lb_c; 
lh     <= lh_c; 
lw     <= lw_c; 
lbu    <= lbu_c; 
lhu    <= lhu_c;
sb     <= sb_c; 
sh     <= sh_c;      
sw     <= sw_c;  
wr_en1 <= R | I | L;
reg_wr_en <= wr_en1;
end

  
endmodule 
          
