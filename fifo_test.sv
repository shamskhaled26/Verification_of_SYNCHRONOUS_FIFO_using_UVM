////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package fifo_test_pkg;
import fifo_config_pkg::*;
import fifo_sequence_pkg::*;
import fifo_env_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_test extends uvm_test;
    `uvm_component_utils(fifo_test)
    fifo_env env;
    virtual fifo_if fifo_vif;
    fifo_config fifo_config_cfg;
    fifo_sequence fifo_sequence_obj;

    function new (string name = "fifo_test",uvm_component parent = null);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env=fifo_env::type_id::create("env",this);  
        fifo_config_cfg = fifo_config::type_id::create("fifo_config_cfg");
        fifo_sequence_obj = fifo_sequence::type_id::create("fifo_sequence_obj",this);//////////////////
    
        if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_If" , fifo_config_cfg.fifo_config_vif))
            `uvm_fatal("build_phase" , "test : Unable to get the virtual interface of the fifo from the uvm_config_db");
        uvm_config_db#(fifo_config)::set(this,"*","CFG" , fifo_config_cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        `uvm_info("run_phase", "stimulus Generation started",UVM_LOW);
        fifo_sequence_obj.start(env.agent.sqr);
         `uvm_info("run_phase", "stimulus Generation ended",UVM_LOW);
        phase.drop_objection(this);
    endtask
 
endclass
endpackage