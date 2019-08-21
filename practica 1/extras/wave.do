onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /procesador_tb/Clk
add wave -noupdate /procesador_tb/Reset
add wave -noupdate /procesador_tb/I_Addr
add wave -noupdate /procesador_tb/I_DataIn
add wave -noupdate /procesador_tb/D_Addr
add wave -noupdate /procesador_tb/D_WrEn
add wave -noupdate /procesador_tb/D_DataOut
add wave -noupdate /procesador_tb/D_DataIn
add wave -noupdate -divider REGISTROS
add wave -noupdate -color Cyan /procesador_tb/UUT/MiRegistros/Clk
add wave -noupdate -color Cyan /procesador_tb/UUT/MiRegistros/NRst
add wave -noupdate -color Cyan /procesador_tb/UUT/MiRegistros/Wd3
add wave -noupdate -color Cyan /procesador_tb/UUT/MiRegistros/A3
add wave -noupdate -color Cyan /procesador_tb/UUT/MiRegistros/A1
add wave -noupdate -color Cyan /procesador_tb/UUT/MiRegistros/A2
add wave -noupdate -color Cyan /procesador_tb/UUT/MiRegistros/Rd1
add wave -noupdate -color Cyan /procesador_tb/UUT/MiRegistros/Rd2
add wave -noupdate -color Cyan /procesador_tb/UUT/MiRegistros/We3
add wave -noupdate -color Cyan -childformat {{/procesador_tb/UUT/MiRegistros/regs(0) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(1) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(2) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(3) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(4) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(5) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(6) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(7) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(8) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(9) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(10) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(11) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(12) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(13) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(14) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(15) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(16) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(17) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(18) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(19) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(20) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(21) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(22) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(23) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(24) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(25) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(26) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(27) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(28) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(29) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(30) -radix decimal} {/procesador_tb/UUT/MiRegistros/regs(31) -radix decimal}} -expand -subitemconfig {/procesador_tb/UUT/MiRegistros/regs(0) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(1) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(2) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(3) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(4) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(5) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(6) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(7) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(8) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(9) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(10) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(11) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(12) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(13) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(14) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(15) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(16) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(17) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(18) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(19) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(20) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(21) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(22) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(23) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(24) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(25) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(26) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(27) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(28) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(29) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(30) {-color Cyan -radix decimal} /procesador_tb/UUT/MiRegistros/regs(31) {-color Cyan -radix decimal}} /procesador_tb/UUT/MiRegistros/regs
add wave -noupdate -divider BJLU
add wave -noupdate /procesador_tb/UUT/MiBJLU/clk
add wave -noupdate /procesador_tb/UUT/MiBJLU/I_DataIn
add wave -noupdate /procesador_tb/UUT/MiBJLU/nextPC
add wave -noupdate /procesador_tb/UUT/MiBJLU/reg1
add wave -noupdate /procesador_tb/UUT/MiBJLU/reg2
add wave -noupdate /procesador_tb/UUT/MiBJLU/JumpTo
add wave -noupdate /procesador_tb/UUT/MiBJLU/PCSrc
add wave -noupdate /procesador_tb/UUT/MiBJLU/signo
add wave -noupdate /procesador_tb/UUT/MiBJLU/condition
add wave -noupdate -divider CONTROL
add wave -noupdate -color Cyan /procesador_tb/UUT/MiControl/OPCode
add wave -noupdate -color Cyan /procesador_tb/UUT/MiControl/Funct
add wave -noupdate -color Cyan /procesador_tb/UUT/MiControl/MemToReg
add wave -noupdate -color Cyan /procesador_tb/UUT/MiControl/MemWrite
add wave -noupdate -color Cyan /procesador_tb/UUT/MiControl/ALUControl
add wave -noupdate -color Cyan /procesador_tb/UUT/MiControl/ALUSrc
add wave -noupdate -color Cyan /procesador_tb/UUT/MiControl/RegDest
add wave -noupdate -color Cyan /procesador_tb/UUT/MiControl/RegWrite
add wave -noupdate -color Cyan /procesador_tb/UUT/MiControl/ExtCero
add wave -noupdate -divider ALU
add wave -noupdate /procesador_tb/UUT/MiALU/Op1
add wave -noupdate /procesador_tb/UUT/MiALU/Op2
add wave -noupdate /procesador_tb/UUT/MiALU/ALUControl
add wave -noupdate /procesador_tb/UUT/MiALU/Res
add wave -noupdate /procesador_tb/UUT/MiALU/slt
add wave -noupdate /procesador_tb/UUT/MiALU/resaux
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9102505 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 256
configure wave -valuecolwidth 177
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {403622 ps} {1251046 ps}
