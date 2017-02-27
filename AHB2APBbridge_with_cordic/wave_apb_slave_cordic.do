onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider MASTER
add wave -noupdate /tb_ahb_lite/HCLK
add wave -noupdate -radix hexadecimal /tb_ahb_lite/HADDR
add wave -noupdate /tb_ahb_lite/HWRITE
add wave -noupdate /tb_ahb_lite/HRDATA
add wave -noupdate /tb_ahb_lite/HREADYIN
add wave -noupdate /tb_ahb_lite/HWDATA
add wave -noupdate -divider AHB2APB
add wave -noupdate -radix unsigned /tb_ahb_lite/U_ahb2apb_bridge/CS
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HSELAPBif
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HWRITE
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HWDATA
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HwirtedataReg
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HwriteReg
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/PwriteReg
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HRDATA
add wave -noupdate -radix hexadecimal /tb_ahb_lite/U_ahb2apb_bridge/HADDR
add wave -noupdate -radix hexadecimal /tb_ahb_lite/U_ahb2apb_bridge/HaddrReg
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HREADYout
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HreadyReg
add wave -noupdate -divider apb_slave_interface
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/iy_0Reg
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/ix_0Reg
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/PWDATA
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/PWRITE
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/PSEL
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/PRDATA
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/PREADY
add wave -noupdate /tb_ahb_lite/U_apb/PENABLE
add wave -noupdate -divider cordic_signal
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/iCLK
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/ix_0
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/iy_0
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/CS
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/x_i
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/rx_i
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/y_i
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/ry_i
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/rad
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/r_rad
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/oangle
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/nRST
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/i
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/d
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/cntrl
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/atan
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/WEN
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/START
add wave -noupdate /tb_ahb_lite/U_apb/U_apb_cordic_slave_0/U_cordic_ip/OP_DONE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {125 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 426
configure wave -valuecolwidth 100
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
WaveRestoreZoom {99 ps} {158 ps}
