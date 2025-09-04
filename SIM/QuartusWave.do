onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /quartus_tb/Q_PORTS/FIRCLK_w
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/CLK_IN
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/Clk
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/rst_tb
add wave -noupdate -color Gold -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/data_IO
add wave -noupdate -color Gold -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/address_i
add wave -noupdate -expand -group {IO PORTS} /quartus_tb/Q_PORTS/KEY0
add wave -noupdate -expand -group {IO PORTS} /quartus_tb/Q_PORTS/KEY1
add wave -noupdate -expand -group {IO PORTS} /quartus_tb/Q_PORTS/KEY2
add wave -noupdate -expand -group {IO PORTS} /quartus_tb/Q_PORTS/KEY3
add wave -noupdate -expand -group {IO PORTS} /quartus_tb/Q_PORTS/LEDS
add wave -noupdate -expand -group {IO PORTS} -radix hexadecimal /quartus_tb/Q_PORTS/HEX0
add wave -noupdate -expand -group {IO PORTS} -radix hexadecimal /quartus_tb/Q_PORTS/HEX1
add wave -noupdate -expand -group {IO PORTS} -radix hexadecimal /quartus_tb/Q_PORTS/HEX2
add wave -noupdate -expand -group {IO PORTS} -radix hexadecimal /quartus_tb/Q_PORTS/HEX3
add wave -noupdate -expand -group {IO PORTS} -radix hexadecimal /quartus_tb/Q_PORTS/HEX4
add wave -noupdate -expand -group {IO PORTS} -radix hexadecimal /quartus_tb/Q_PORTS/HEX5
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/div_cnt
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/IFpc_o
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/IDpc_o
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/EXpc_o
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/DMpc_o
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/WBpc_o
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/IFpc_o
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/IDpc_o
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/EXpc_o
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/DMpc_o
add wave -noupdate -group PC_o -radix hexadecimal /quartus_tb/Q_PORTS/WBpc_o
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal -childformat {{/quartus_tb/Q_PORTS/HEX0_decoded(6) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(5) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(4) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(3) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(2) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(1) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(0) -radix hexadecimal}} -subitemconfig {/quartus_tb/Q_PORTS/HEX0_decoded(6) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(5) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(4) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(3) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(2) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(1) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(0) {-height 15 -radix hexadecimal}} /quartus_tb/Q_PORTS/HEX0_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX1_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX2_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX0_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX1_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX2_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX3_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX4_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX5_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX3_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX4_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX5_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal -childformat {{/quartus_tb/Q_PORTS/HEX0_decoded(6) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(5) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(4) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(3) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(2) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(1) -radix hexadecimal} {/quartus_tb/Q_PORTS/HEX0_decoded(0) -radix hexadecimal}} -subitemconfig {/quartus_tb/Q_PORTS/HEX0_decoded(6) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(5) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(4) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(3) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(2) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(1) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/HEX0_decoded(0) {-height 15 -radix hexadecimal}} /quartus_tb/Q_PORTS/HEX0_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX1_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX2_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX0_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX1_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX2_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX3_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX4_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX5_decoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX3_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX4_undecoded
add wave -noupdate -group {HEX decoded and undecoded} -radix hexadecimal /quartus_tb/Q_PORTS/HEX5_undecoded
add wave -noupdate -group MIPS -color Cyan -radix hexadecimal -childformat {{/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(0) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(1) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(2) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(3) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(4) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(5) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(6) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(7) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8) -radix hexadecimal -childformat {{/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(31) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(30) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(29) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(28) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(27) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(26) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(25) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(24) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(23) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(22) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(21) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(20) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(19) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(18) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(17) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(16) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(15) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(14) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(13) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(12) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(11) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(10) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(9) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(8) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(7) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(6) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(5) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(4) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(3) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(2) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(1) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(0) -radix hexadecimal}}} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(9) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(10) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(11) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(12) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(13) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(14) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(15) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(16) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(17) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(18) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(19) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(20) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(21) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(22) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(23) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(24) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(25) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(26) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(27) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(28) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(29) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(30) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(31) -radix hexadecimal}} -subitemconfig {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(0) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(1) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(2) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(3) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(4) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(5) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(6) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(7) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8) {-color Cyan -height 15 -radix hexadecimal -childformat {{/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(31) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(30) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(29) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(28) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(27) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(26) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(25) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(24) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(23) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(22) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(21) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(20) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(19) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(18) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(17) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(16) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(15) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(14) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(13) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(12) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(11) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(10) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(9) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(8) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(7) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(6) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(5) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(4) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(3) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(2) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(1) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(0) -radix hexadecimal}}} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(31) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(30) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(29) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(28) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(27) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(26) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(25) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(24) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(23) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(22) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(21) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(20) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(19) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(18) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(17) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(16) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(15) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(14) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(13) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(12) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(11) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(10) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(9) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(8) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(7) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(6) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(5) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(4) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(3) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(2) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(1) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(8)(0) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(9) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(10) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(11) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(12) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(13) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(14) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(15) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(16) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(17) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(18) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(19) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(20) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(21) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(22) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(23) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(24) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(25) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(26) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(27) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(28) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(29) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(30) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q(31) {-color Cyan -height 15 -radix hexadecimal}} /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q
add wave -noupdate -group MIPS -expand -group IR_mips -color Pink -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IR_IF
add wave -noupdate -group MIPS -expand -group IR_mips -color {Medium Violet Red} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IR_ID_i
add wave -noupdate -group MIPS -expand -group IR_mips -color Pink -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IR_EX
add wave -noupdate -group MIPS -expand -group IR_mips -color Pink -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IR_MEM
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/clk_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/rst_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/stall_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/add_result_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/JUMP_addr_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/PCSrc_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/type_en
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/type_address
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/pc_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/pc_plus4_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/instruction_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/inst_cnt_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/pc_q
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/pc_plus4_r
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/itcm_addr_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/next_pc_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/branch_addr
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/jump_addr
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/rst_flag_q
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/inst_cnt_q
add wave -noupdate -group MIPS -expand -group IR_mips -group IFETCH -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IFE/pc_prev_q
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/clk_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/rst_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/instruction_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/dtcm_data_rd_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/ALU_Result_DM_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/RegWrite_ctrl_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/MemtoReg_ctrl_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/JAL_ctrl_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/pc_plus4_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/pc_plus4_WB_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/stall_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/ForwardA_ID
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/ForwardB_ID
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/Branch_FW_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/write_reg_addr_i
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/read_data1_MUXdata_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/read_data2_MUXdata_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/sign_extend_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/Jump_addr_select_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/addr_res_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/PCSrc_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/instruction_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/int_req_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/write_data_o
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/RF_q
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/write_reg_addr_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/write_reg_data_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/rs_register_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/rt_register_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/rd_register_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/imm_value_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/Sign_extend_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/read_data1_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/read_data2_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/Opcode_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/Jump_addr_w
add wave -noupdate -group MIPS -expand -group IR_mips -group IDECODE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/ID/PCBranch_addr_w
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/clk_i
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/reset_tb
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/opcode_i
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/instruction_i
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/RegDst_ctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/ALUSrc_ctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/MemtoReg_ctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/RegWrite_ctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/MemRead_ctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/MemWrite_ctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/Branch_ctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/BNEctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/BEQctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/jumpctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/ALUOp_ctrl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/INTA
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/GIE
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/EPC_ctl_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/flush_intr_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/int_req_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/INTR
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/type_address
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/type_en
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/Key_reset_o
add wave -noupdate -group MIPS -expand -group IR_mips -group CONTROL -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/CTL/i_opc
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/read_data1_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/read_data2_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/funct_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/ALUOp_ctrl_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/Alusrc_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/pc_plus4_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/instruction_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/RegDst_ctrl_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/ReadData1_MUX_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/ReadData2_MUX_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/alu_res_DM_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/RF_WriteData_WB_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/sign_extend_i
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/zero_o
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/alu_res_o
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/WriteDataEx_o
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/write_reg_addr_o
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/srcA_w
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/srcB_w
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/srcB_fwd_w
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/alu_code_r_w
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/alu_code_i_w
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/alu_code_w
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/shift_result_w
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/do_shift
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/alu_out_w
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/rd_w
add wave -noupdate -group MIPS -expand -group IR_mips -group EXE -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/EXE/rt_w
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/Rs_Reg_ID_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/Rt_Reg_ID_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/Rs_Reg_EX_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/Rt_Reg_EX_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/write_reg_addr_EX_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/write_reg_addr_DM_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/write_reg_addr_WB_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/RegWrite_EX_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/RegWrite_DM_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/RegWrite_WB_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/ALU_A_MUX_o
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/ALU_B_MUX_o
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/MemtoReg_EX_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/MemtoReg_DM_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/BEQ_ID_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/BNE_ID_i
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/Stall_IF
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/Stall_ID
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/Flush_EX
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/ForwardA_Branch
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/ForwardB_Branch
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/LwStall
add wave -noupdate -group MIPS -expand -group IR_mips -group HAZARD -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/HAZ/BranchStall
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/clk_i
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/rst_i
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/dtcm_addr_i
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/dtcm_data_wr_i
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/MemRead_ctrl_i
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/MemWrite_ctrl_i
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/ALU_Result_i
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/dtcm_data_rd_o
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/ALU_Result_o
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/TYPE_addr_i
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/DATA_IO
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/type_en
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/wrclk_w
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/WR_en
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/address_mux
add wave -noupdate -group MIPS -expand -group IR_mips -group MEM -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/G1/MEM/read_data_mem
add wave -noupdate -group MIPS -expand -group IR_mips -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/CORE/IR_WB
add wave -noupdate -group MIPS /quartus_tb/Q_PORTS/MICRO/clk_i
add wave -noupdate -group MIPS /quartus_tb/Q_PORTS/MICRO/FIRCLK_i
add wave -noupdate -group MIPS /quartus_tb/Q_PORTS/MICRO/rst_i
add wave -noupdate -group MIPS /quartus_tb/Q_PORTS/MICRO/rst_KEY0
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/LEDS
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/HEX0
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/HEX1
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/HEX2
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/HEX3
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/HEX4
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/HEX5
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/KEY3_INTR
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/KEY2_INTR
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/KEY1_INTR
add wave -noupdate -group MIPS -group MIPS_IO /quartus_tb/Q_PORTS/MICRO/LEDS
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/GIE_i
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/address_i
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/clk
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/MemWrite_DM_i
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/rst_KEY0
add wave -noupdate -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/MemRead_DM_i
add wave -noupdate -expand -group {register config} -group {register config Tristate} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/data_IO
add wave -noupdate -expand -group {register config} -group {register config Tristate} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/address_i
add wave -noupdate -expand -group {register config} -group {register config Tristate} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/DataIO_read
add wave -noupdate -expand -group {register config} -group {register config Tristate} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/DataBus_en_read
add wave -noupdate -expand -group {register config} -group {register config Tristate} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/data_IO
add wave -noupdate -expand -group {register config} -group {register config Tristate} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/address_i
add wave -noupdate -expand -group {register config} -group {register config Tristate} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/DataIO_read
add wave -noupdate -expand -group {register config} -group {register config Tristate} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/DataBus_en_read
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCTL_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCCR1_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTIPx_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCLR_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTSSELx_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTHOLD_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTOUTEN_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTOUTMD_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCCR0_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCTL_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCCR1_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTIPx_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCLR_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTSSELx_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTHOLD_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTOUTEN_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTOUTMD_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -group BT_r -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCCR0_r
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTIFG
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCCR0
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCCR1
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCTL
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCNT_i
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCNT_read
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTIP
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCLR
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTSSEL
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTHOLD
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTOUTEN
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTOUTMD
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/PWM_out
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/Counter_write_w
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/Counter_write
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTIFG
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCCR0
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCCR1
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCTL
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCNT_i
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCNT_read
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTIP
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTCLR
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTSSEL
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTHOLD
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTOUTEN
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/BTOUTMD
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/PWM_out
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/Counter_write_w
add wave -noupdate -expand -group {register config} -group {Basic Timer} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/Reg_config/Counter_write
add wave -noupdate -expand -group {IO decoder} -group {tristate data} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IO_port/data_IO
add wave -noupdate -expand -group {IO decoder} -group {tristate data} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IO_port/data_IO
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} /quartus_tb/Q_PORTS/MICRO/IO_port/rst_w
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} -expand -group IOs /quartus_tb/Q_PORTS/MICRO/IO_port/SW7to0
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} -expand -group IOs -color Cyan /quartus_tb/Q_PORTS/MICRO/IO_port/HEX5
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} -expand -group IOs -color Cyan /quartus_tb/Q_PORTS/MICRO/IO_port/HEX4
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} -expand -group IOs -color Cyan /quartus_tb/Q_PORTS/MICRO/IO_port/HEX3
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} -expand -group IOs -color Cyan /quartus_tb/Q_PORTS/MICRO/IO_port/HEX2
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} -expand -group IOs -color Cyan /quartus_tb/Q_PORTS/MICRO/IO_port/HEX1
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} -expand -group IOs -color Cyan /quartus_tb/Q_PORTS/MICRO/IO_port/HEX0
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} -expand -group IOs -color Cyan /quartus_tb/Q_PORTS/MICRO/IO_port/LEDS
add wave -noupdate -expand -group {IO decoder} -expand -group {IO value} /quartus_tb/Q_PORTS/MICRO/IO_port/rst_w
add wave -noupdate -expand -group {IO decoder} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IO_port/MemRead_DM_i
add wave -noupdate -expand -group {IO decoder} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IO_port/MemWrite_DM_i
add wave -noupdate -expand -group {IO decoder} /quartus_tb/Q_PORTS/MICRO/IO_port/MSCLK
add wave -noupdate -expand -group {IO decoder} /quartus_tb/Q_PORTS/MICRO/IO_port/rst_KEY0
add wave -noupdate -expand -group {IO decoder} /quartus_tb/Q_PORTS/MICRO/IO_port/rst_tb
add wave -noupdate -expand -group {IO decoder} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IO_port/address_i
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/FIFORST
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/FIFOWEN
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/FIFOREN
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/FIFOIN
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/DATAOUT
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/FIFOFULL
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Orange Red} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/FIFOEMPTY
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color Cyan -radix hexadecimal -childformat {{/quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(0) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(1) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(2) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(3) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(4) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(5) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(6) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(7) -radix hexadecimal}} -subitemconfig {/quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(0) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(1) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(2) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(3) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(4) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(5) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(6) {-color Cyan -height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem(7) {-color Cyan -height 15 -radix hexadecimal}} /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/mem
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/dout_reg
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/wr_ptr
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/rd_ptr
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/count
add wave -noupdate -group {FIR unit} -expand -group {synchronus fifo} -color {Cornflower Blue} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/synchronus_FIFO/rst_w
add wave -noupdate -group {FIR unit} -group tristate -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/data_IO
add wave -noupdate -group {FIR unit} -group tristate -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/Dout
add wave -noupdate -group {FIR unit} -group tristate -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/Din
add wave -noupdate -group {FIR unit} -color Gold -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIFOCLK
add wave -noupdate -group {FIR unit} -color Gold -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIRCLK
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIRENA
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIRRST
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/rst_w
add wave -noupdate -group {FIR unit} -color Red -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIFOEMPTY_IFG
add wave -noupdate -group {FIR unit} -color Red -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIRIFG
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/address_i
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/MemWrite_DM_i
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/MemRead_DM_i
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIFOREN
add wave -noupdate -group {FIR unit} -color Magenta -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIRIN
add wave -noupdate -group {FIR unit} -color Magenta -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIROUT
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIFOFULL
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIFORST
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIFOWEN
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/FIRCTL
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/DATAOUT
add wave -noupdate -group {FIR unit} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/COEFs
add wave -noupdate -group {FIR unit} -expand -group {DFF calc} -radix hexadecimal -childformat {{/quartus_tb/Q_PORTS/MICRO/FIR/xn(7) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/xn(6) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/xn(5) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/xn(4) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/xn(3) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/xn(2) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/xn(1) -radix hexadecimal} {/quartus_tb/Q_PORTS/MICRO/FIR/xn(0) -radix hexadecimal}} -expand -subitemconfig {/quartus_tb/Q_PORTS/MICRO/FIR/xn(7) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/xn(6) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/xn(5) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/xn(4) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/xn(3) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/xn(2) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/xn(1) {-height 15 -radix hexadecimal} /quartus_tb/Q_PORTS/MICRO/FIR/xn(0) {-height 15 -radix hexadecimal}} /quartus_tb/Q_PORTS/MICRO/FIR/xn
add wave -noupdate -group {FIR unit} -expand -group {DFF calc} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/c_mul
add wave -noupdate -group {FIR unit} -expand -group {DFF calc} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/c_add
add wave -noupdate -group {FIR unit} -expand -group {DFF calc} -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/FIR/yn
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/MSCLK
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/rst_tb
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/rst_KEY0
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/MemWrite_DM_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/MemRead_DM_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/GIE_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/address_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/DataBus_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIR_IRQ_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY3_IRQ_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY2_IRQ_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY1_IRQ_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/BT_IRQ_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIFO_status_IRQ_i
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/RX_IRQ
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/TX_IRQ
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/UART_status_error_irq
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/INTA
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/INTR
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/DataBus_i_en
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/Din
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/Dout
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/zero_vec
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/HighZ_vec
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/CS
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/reset_IFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/reset_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/clr_reset
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/Intrrupt_req_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/Type_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/Type_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/clr_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/IE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/IE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/IFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/IFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIFO_status_IFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/UART_status_error_IFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/RXIFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/TXIFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/BTIFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY1IFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY2IFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY3IFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIRIFG_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIFO_status_IFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/UART_status_error_IFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/RXIFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/TXIFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/BTIFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY1IFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY2IFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY3IFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIRIFG_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIFO_status_IE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/UART_status_error_IE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/RXIE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/TXIE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/BTIE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY1IE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY2IE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY3IE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIRIE_o
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIFO_status_IE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/UART_status_error_IE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/RXIE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/TXIE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/BTIE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY1IE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY2IE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY3IE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIRIE_r
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIFO_status_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/UART_status_error_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/RX_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/TX_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/BT_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY1_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY2_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY3_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIR_irq_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIFO_status_clr_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/UART_status_error_clr_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/RX_clr_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/TX_clr_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/BT_clr_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY1_clr_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY2_clr_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/KEY3_clr_w
add wave -noupdate -expand -group IC -radix hexadecimal /quartus_tb/Q_PORTS/MICRO/IC/FIR_clr_w
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 8} {195524580 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 518
configure wave -valuecolwidth 89
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
configure wave -timelineunits ps
update
WaveRestoreZoom {195149190 ps} {200255306 ps}
bookmark add wave bookmark0 {{1287712 ps} {2897360 ps}} 6
bookmark add wave bookmark1 {{36 ps} {116 ps}} 0
bookmark add wave bookmark2 {{0 ps} {1 ns}} 0
