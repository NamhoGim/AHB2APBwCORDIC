onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider MASTER
add wave -noupdate /tb_ahb_lite/HCLK
add wave -noupdate /tb_ahb_lite/HADDR
add wave -noupdate /tb_ahb_lite/HWRITE
add wave -noupdate /tb_ahb_lite/HRDATA
add wave -noupdate /tb_ahb_lite/HREADYIN
add wave -noupdate /tb_ahb_lite/HWDATA
add wave -noupdate -divider AHB2APB
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/CS
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HSELAPBif
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HWRITE
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HWDATA
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HwirtedataReg
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HwriteReg
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/PwriteReg
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HRDATA
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HADDR
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/HaddrReg
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/PRDATA
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/PWDATA
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/PADDR
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/PaddrReg
add wave -noupdate /tb_ahb_lite/U_ahb2apb_bridge/PENABLE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 313
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
WaveRestoreZoom {29 ps} {55 ps}

