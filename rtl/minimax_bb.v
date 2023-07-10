(* black_box *) module minimax_tmr (
   input wire clk,
   input wire reset,
   input wire [15:0] inst,
   output wire inst_ce,
   input wire [31:0] rdata,
   output wire[11:0] inst_addr,
   output reg [31:0] addr,
   output reg [31:0] wdata,
   output reg [3:0] wmask,
   output reg rreq,
   input wire rack);

endmodule

(* black_box *) module minimax (
   input wire clk,
   input wire reset,
   input wire [15:0] inst,
   output wire inst_ce,
   input wire [31:0] rdata,
   output wire[11:0] inst_addr,
   output reg [31:0] addr,
   output reg [31:0] wdata,
   output reg [3:0] wmask,
   output reg rreq,
   input wire rack);

endmodule
