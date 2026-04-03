`timescale 1ns / 1ps

module ALU(
    input             clk,
    input             add, sub, sll, slt, sltu,  
    input             srl, sra, or_, and_, xor_,
    input      [63:0] OP1, OP2,
    input      [4:0]  rd_in,
    output reg [4:0]  rd_out,
    output reg [63:0] O
    );
    
always@ (posedge clk) begin
case (1'b1) 
add:  O <= OP1 + OP2; //add
sub:  O <= OP1 - OP2; //sub
sll:  O <= OP1 << OP2[5:0]; //sll
slt:  O <= ($signed(OP1) < $signed(OP2)) ? 64'd1 : 64'd0; //slt
sltu: O <= (OP1 < OP2)                   ? 64'd1 : 64'd0; //sltu
srl:  O <= OP1 >> OP2[5:0]; //srl
sra:  O <= $signed(OP1) >>> OP2[5:0]; //sra
or_:  O <= OP1 | OP2; //or
and_: O <= OP1 & OP2; //and
xor_: O <= OP1 ^ OP2; //xor
endcase
rd_out <= rd_in;
end

endmodule
