`include "defines.vh"

module pc_reg(input	wire clk,
              input wire rst,
              input wire[5:0] stall,
              input wire branch_flag_i,
              input wire[`RegBus] branch_target_address_i,
              output reg[`InstAddrBus] pc,
              output reg ce);

always @ (posedge clk) begin
    if (ce == `ChipDisable) begin
        pc <= `ZeroAddr;
        end else if (stall[0] == `NoStop) begin
        if (branch_flag_i == `Branch) pc <= branch_target_address_i;
		else pc <= pc + 4'h4;
    end
end

always @ (posedge clk) begin
    if (rst == `RstEnable) ce <= `ChipDisable;
	else ce <= `ChipEnable;
end

endmodule
