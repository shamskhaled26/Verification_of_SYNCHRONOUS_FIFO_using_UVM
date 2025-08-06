package fifo_agent_pkg;

import uvm_pkg::*;
import fifo_driver_pkg::*;
import fifo_config_pkg::*;
import fifo_monitor_pkg::*;
import fifo_sequencer_pkg::*;
import fifo_seq_item_pkg::*;

`include "uvm_macros.svh"
    
    class fifo_agent extends uvm_agent;
        `uvm_component_utils(fifo_agent)
        fifo_sequencer sqr;
        fifo_monitor mon;
        fifo_driver fifo_driv;
        fifo_config fifo_config_cfg;

        uvm_analysis_port #(fifo_seq_item) agt_ap;

        function new(string name = "fifo_agent", uvm_component parent =null);
            super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if(!uvm_config_db#(fifo_config)::get(this, "","CFG" , fifo_config_cfg))begin
            `uvm_fatal("build_phase" , "Unable to get configuration object");
            end

            fifo_driv=fifo_driver::type_id::create("fifo_driv",this);
            sqr = fifo_sequencer::type_id::create("driver",this);
            mon=fifo_monitor::type_id::create("mon",this);
            agt_ap = new("agt_ap",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            fifo_driv.fifo_vif= fifo_config_cfg.fifo_config_vif;
            mon.fifo_mon_vif = fifo_config_cfg.fifo_config_vif;
            fifo_driv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap);              
        endfunction
    endclass
endpackage