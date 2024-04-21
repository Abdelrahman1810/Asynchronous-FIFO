vlib work
vlog FIFO.v FIFO_CO.v register.v testbench.sv
vsim -voptargs=+acc work.testbench
add wave *

# add wave -position insertpoint  \
# sim:/testbench/fifo/w_en \
# sim:/testbench/fifo/r_en


# add wave -position insertpoint  \
# sim:/testbench/fifo/controller/full_ns \
# sim:/testbench/fifo/controller/empty_ns

add wave -position insertpoint  \
sim:/testbench/fifo/rg/memory
#add wave -r /*
run -all
# quit -sim