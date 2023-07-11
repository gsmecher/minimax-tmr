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

(* black_box *) module minimax_tmr (
   input wire clk,

   input wire reset_TMR_0,
   input wire reset_TMR_1,
   input wire reset_TMR_2,

   input wire [15:0] inst_TMR_0,
   input wire [15:0] inst_TMR_1,
   input wire [15:0] inst_TMR_2,

   output wire inst_ce_TMR_0,
   output wire inst_ce_TMR_1,
   output wire inst_ce_TMR_2,

   output wire[11:0] inst_addr_TMR_0,
   output wire[11:0] inst_addr_TMR_1,
   output wire[11:0] inst_addr_TMR_2,

   input wire [31:0] rdata_TMR_0,
   input wire [31:0] rdata_TMR_1,
   input wire [31:0] rdata_TMR_2,

   output reg [31:0] addr_TMR_0,
   output reg [31:0] addr_TMR_1,
   output reg [31:0] addr_TMR_2,

   output reg [31:0] wdata_TMR_0,
   output reg [31:0] wdata_TMR_1,
   output reg [31:0] wdata_TMR_2,

   output reg [3:0] wmask_TMR_0,
   output reg [3:0] wmask_TMR_1,
   output reg [3:0] wmask_TMR_2,

   output reg rreq_TMR_0,
   output reg rreq_TMR_1,
   output reg rreq_TMR_2,

   input wire rack_TMR_0,
   input wire rack_TMR_1,
   input wire rack_TMR_2);

endmodule
