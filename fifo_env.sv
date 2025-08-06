////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package fifo_env_pkg;
import fifo_agent_pkg::*;
import fifo_scoreboard_pkg::*;
import fifo_coverage_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class fifo_env extends uvm_env;

      `uvm_component_utils(fifo_env)


      fifo_scoreboard fifo_sb;
      fifo_coverage fifo_cvrg;
      fifo_agent agent;

        function new (string name = "fifo_env",uvm_component parent = null);
          super.new(name,parent);
        endfunction

        function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          fifo_sb=fifo_scoreboard::type_id::create("fifo_sb",this);
          agent = fifo_agent::type_id::create("agent",this);
          fifo_cvrg = fifo_coverage::type_id::create("fifo_cvrg",this);
        endfunction

        function void connect_phase(uvm_phase phase);
          super.connect_phase(phase);
          agent.agt_ap.connect(fifo_sb.sb_export);
          agent.agt_ap.connect(fifo_cvrg.cov_export);
          
        endfunction
    endclass
endpackage