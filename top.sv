////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
import uvm_pkg::*;
import fifo_test_pkg::*;
import fifo_env_pkg::*;
`include "uvm_macros.svh"
module top();
  bit clk;
  initial begin
    forever begin
      #1 clk=!clk;  // Clock generation
    end
  end

fifo_if fifoif (clk);
FIFO DUT(fifoif);
bind FIFO fifo_sva fifo_sva_inst(fifoif);
initial begin
  uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top","fifo_If", fifoif);
  run_test("fifo_test");
end

endmodule