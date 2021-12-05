onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib small_six_red_rom_opt

do {wave.do}

view wave
view structure
view signals

do {small_six_red_rom.udo}

run -all

quit -force
