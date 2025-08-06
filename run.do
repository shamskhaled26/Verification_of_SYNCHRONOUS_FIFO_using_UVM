vlib work
vlog -f src_files.list +cover 
vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

add wave -position insertpoint  \
sim:/top/DUT/FIFO_WIDTH \
sim:/top/DUT/FIFO_DEPTH \
sim:/top/DUT/max_fifo_addr \
sim:/top/DUT/mem \
sim:/top/DUT/wr_ptr \
sim:/top/DUT/rd_ptr \
sim:/top/DUT/count

add wave -position insertpoint  \
sim:/top/fifoif/almostempty \
sim:/top/fifoif/almostfull \
sim:/top/fifoif/clk \
sim:/top/fifoif/data_in \
sim:/top/fifoif/data_out \
sim:/top/fifoif/empty \
sim:/top/fifoif/FIFO_DEPTH \
sim:/top/fifoif/FIFO_WIDTH \
sim:/top/fifoif/full \
sim:/top/fifoif/overflow \
sim:/top/fifoif/rd_en \
sim:/top/fifoif/rst_n \
sim:/top/fifoif/underflow \
sim:/top/fifoif/wr_ack \
sim:/top/fifoif/wr_en
coverage save top.ucdb -onexit
run -all
vcover report top.ucdb -details -annotate -all -output coverage_report.txt