module fifo_sva(fifo_if.DUT fifoif);
parameter FIFO_DEPTH = 8;

always_comb begin
	if(!fifoif.rst_n)begin
		assert final (!DUT.count && !DUT.wr_ptr && !DUT.rd_ptr && !fifoif.wr_ack && !fifoif.overflow && !fifoif.underflow);
		end
	assert final (fifoif.full == (DUT.count == FIFO_DEPTH)? 1 : 0);
	assert final (fifoif.empty == (DUT.count == 0)? 1 : 0);
	assert final (fifoif.almostfull == (DUT.count == FIFO_DEPTH-1)? 1 : 0);
	assert final (fifoif.almostempty == (DUT.count == 1)? 1 : 0);

end	
	property write_ack_p;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (fifoif.wr_en && !fifoif.full) |=> (fifoif.wr_ack);
	endproperty 
assert property(write_ack_p); cover property(write_ack_p);
	
	property overflow_p;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (fifoif.wr_en && fifoif.full) |=> (fifoif.overflow);
	endproperty 
assert property(overflow_p); cover property(overflow_p);

	property underflow_p;
		@(posedge fifoif.clk) disable iff(!fifoif.rst_n) (fifoif.rd_en && fifoif.empty) |=> (fifoif.underflow);
	endproperty 
assert property(underflow_p); cover property(underflow_p);

	property wr_ptr_p;
		@(posedge fifoif.clk)  disable iff(!fifoif.rst_n) (fifoif.wr_en && !fifoif.full) |=> (DUT.wr_ptr == (($past(DUT.wr_ptr)+1)%FIFO_DEPTH));
	endproperty 
assert property(wr_ptr_p); cover property(wr_ptr_p);

	property rd_ptr_p;
		@(posedge fifoif.clk)  disable iff(!fifoif.rst_n) (fifoif.rd_en && !fifoif.empty) |=> (DUT.rd_ptr == (($past(DUT.rd_ptr)+1)%FIFO_DEPTH));
	endproperty 
assert property(rd_ptr_p); cover property(rd_ptr_p);




endmodule
