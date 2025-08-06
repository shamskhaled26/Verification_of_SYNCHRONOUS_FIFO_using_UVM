package fifo_coverage_pkg;
import fifo_seq_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

    class fifo_coverage extends uvm_component;
        `uvm_component_utils(fifo_coverage);

        uvm_analysis_export #(fifo_seq_item) cov_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) cov_fifo;
        fifo_seq_item item_cov;
        
    
        covergroup cvr_gp ;

            write_enable    :coverpoint item_cov.wr_en{ 
            bins write_1  = {1};
            bins write_0  = {0};
            }
            read_enable     :coverpoint item_cov.rd_en{
            bins read_1  = {1};
            bins read_0  = {0};
            }
            full_flag       :coverpoint item_cov.full {
            bins full_1  = {1};
            bins full_0  = {0};
            }
            empty_flag      :coverpoint item_cov.empty{
            bins empty_1  = {1};
            bins empty_0  = {0};
            }
            almostfull_flag :coverpoint item_cov.almostfull{
            bins almostfull_1  = {1};
            bins almostfull_0  = {0};
            }
            almostempty_flag:coverpoint item_cov.almostempty {
            bins almostempty_1  = {1};
            bins almostempty_0  = {0};
            }
            overflow_flag   :coverpoint item_cov.overflow    {
            bins overflow_1  = {1};
            bins overflow_0  = {0};
            }
            underflow_flag  :coverpoint item_cov.underflow   {
            bins underflow_1  = {1};
            bins underflow_0  = {0};
            }
            wr_ack_flag     :coverpoint item_cov.wr_ack  {
            bins wr_ack_1  = {1};
            bins wr_ack_0  = {0};
            }

            full:cross write_enable,read_enable,full_flag {
            ignore_bins ignored_1_will_not_happend =binsof (read_enable.read_1) && binsof (full_flag.full_1); 
            }
            empty:cross write_enable,read_enable,empty_flag  {
            ignore_bins ignored_2_will_not_happend =binsof (write_enable.write_1) && binsof (empty_flag.empty_1); 
            }
            almostfull:cross write_enable,read_enable,almostfull_flag ;
            almostempty:cross write_enable,read_enable,almostempty_flag;
            overflow:cross write_enable,read_enable,overflow_flag{
            ignore_bins ignored_3_will_not_happend =binsof (write_enable.write_0) && binsof (overflow_flag.overflow_1); 
            }
            underflow:cross write_enable,read_enable,underflow_flag{
            ignore_bins ignored_4_will_not_happend =binsof (read_enable.read_0) && binsof (underflow_flag.underflow_1); 
            }
            ack:cross write_enable,read_enable,wr_ack_flag   {
            ignore_bins ignored_5_will_not_happend =binsof (write_enable.write_0) && binsof (wr_ack_flag.wr_ack_1); 
            }
        endgroup
        
        function new (string name = "fifo_coverage",uvm_component parent = null);
            super.new(name,parent);
            cvr_gp=new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cov_export = new("cov_export",this);
            cov_fifo = new("cov_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                cov_export.connect(cov_fifo.analysis_export);          
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cov_fifo.get(item_cov);
                cvr_gp.sample();   
            end
        endtask
    endclass
endpackage
