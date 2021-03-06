`include "defines.vh"

// A BootROM, loading 64 KB from flash into mem

module bootrom_controller(
    wb_rst_i,
    wb_adr_i,
    wb_cyc_i,
    wb_stb_i,

    // Outputs
    wb_dat_o,
    wb_ack_o
);

// clk signals
input    wb_rst_i;

// WB slave if
output reg[31:0]wb_dat_o;
input[31:0]     wb_adr_i;
input           wb_cyc_i;
input           wb_stb_i;
output          wb_ack_o;

wire wb_acc = wb_cyc_i & wb_stb_i & ~wb_rst_i;
assign wb_ack_o = `True;

always @(*) begin
    if(wb_acc == `True) begin
        case(wb_adr_i[7:0])
            8'h00: wb_dat_o <= 32'h3c08bc00; // lui $t0, 0xbc00 # flash
            8'h04: wb_dat_o <= 32'h3c098000; // lui $t1, 0x8000 # baseRAM
            8'h08: wb_dat_o <= 32'h3c0abc01; // lui $t2, 0xbc01 # 64 kB
            8'h0c: wb_dat_o <= 32'h8d0b0000; // lw  $t3,0($t0)
            8'h10: wb_dat_o <= 32'had2b0000; // sw  $t3,0($t1)
            8'h14: wb_dat_o <= 32'h25080004; // addiu $t0,$t0,4
            8'h18: wb_dat_o <= 32'h25290004; // addiu $t1,$t1,4
            8'h1c: wb_dat_o <= 32'h150afffb; // bne $t0,$t2,loop
            8'h20: wb_dat_o <= 32'h3c0bb100; // lui $t3, 0xb100 # GPIO base addr
            8'h24: wb_dat_o <= 32'h3c0c00ff; // lui $t4, 0x00ff
            8'h28: wb_dat_o <= 32'h358cffff; // ori $t4, 0xffff
            8'h2c: wb_dat_o <= 32'had6c0008; // sw $t4, 0x8($t3) # enable GPIO output
            8'h30: wb_dat_o <= 32'h358c000f; // ori $t4, 0x000f
            8'h34: wb_dat_o <= 32'had6c000c; // sw $t4, 0xc($t3) # enable interrupt
            8'h38: wb_dat_o <= 32'h3c018000; // lui $1, 0x8000  # jump to entry
            8'h3c: wb_dat_o <= 32'h00200008; // j $1
            default: wb_dat_o <= `ZeroWord;
        endcase
    end else
        wb_dat_o <= `ZeroWord;
end

endmodule
