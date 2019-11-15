`timescale 1ns / 1ps
`include "defines.vh"

module inst_rom(
    input wire ce,
    input wire[`InstAddrBus] addr,
    output reg[`InstBus]     inst
);

reg[`InstBus] inst_mem[0: 131071 - 1];

initial $readmemh ("../../../../inst_rom.data", inst_mem);
always @(*) begin
    if(ce == `ChipDisable) begin
        inst <= `ZeroWord;
    end else begin
        inst <= inst_mem[addr[18:2]];
    end
end

endmodule