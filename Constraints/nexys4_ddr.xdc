
## Nexys 4 DDR - FPGA Hardware Packet Router

## 100 MHz System Clock
set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports {CLK}]

create_clock -add -name sys_clk_pin \
    -period 10.00 \
    -waveform {0 5} \
    [get_ports {CLK}]


## CPU Reset Button
## Active-low
set_property -dict { PACKAGE_PIN C12 IOSTANDARD LVCMOS33 } [get_ports {CPU_RESETN}]


## USB-UART RX
## PC -> Nexys 4 DDR -> FPGA
set_property -dict { PACKAGE_PIN C4 IOSTANDARD LVCMOS33 } [get_ports {UART_RX}]


## USB-UART TX
## FPGA -> Nexys 4 DDR -> PC
set_property -dict { PACKAGE_PIN D4 IOSTANDARD LVCMOS33 } [get_ports {UART_TX}]