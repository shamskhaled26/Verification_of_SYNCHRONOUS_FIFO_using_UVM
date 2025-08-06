package fifo_monitor_pkg;

import uvm_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"
    
    class fifo_monitor extends uvm_monitor;
        `uvm_component_utils(fifo_monitor)
        virtual fifo_if fifo_mon_vif;
        fifo_seq_item fifo_mon_item;
        uvm_analysis_port #(fifo_seq_item) mon_ap;

        function  new(string name = "fifo_monitor", uvm_component parent= null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            mon_ap = new("mon_ap",this);
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin            
                fifo_mon_item = fifo_seq_item::type_id::create("fifo_mon_item");
                @(negedge fifo_mon_vif.clk);
                fifo_mon_item.data_in = fifo_mon_vif.data_in;
                fifo_mon_item.wr_en = fifo_mon_vif.wr_en;
                fifo_mon_item.rst_n = fifo_mon_vif.rst_n;
                fifo_mon_item.rd_en = fifo_mon_vif.rd_en;

                fifo_mon_item.data_out = fifo_mon_vif.data_out;
                fifo_mon_item.wr_ack = fifo_mon_vif.wr_ack;
                fifo_mon_item.full = fifo_mon_vif.full;
                fifo_mon_item.almostfull = fifo_mon_vif.almostfull;

                fifo_mon_item.empty = fifo_mon_vif.empty;
                fifo_mon_item.almostempty = fifo_mon_vif.almostempty;
                fifo_mon_item.overflow = fifo_mon_vif.overflow;
                fifo_mon_item.underflow = fifo_mon_vif.underflow;
                
                mon_ap.write(fifo_mon_item);
                `uvm_info("run_phase",fifo_mon_item.convert2string(), UVM_HIGH)
            end
        endtask
    endclass
endpackage