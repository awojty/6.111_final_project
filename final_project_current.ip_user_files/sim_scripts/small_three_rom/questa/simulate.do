onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib small_three_rom_opt

do {wave.do}

view wave
view structure
view signals

do {small_three_rom.udo}

run -all

quit -force
