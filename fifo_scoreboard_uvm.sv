package fifo_scoreboard_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"
    class fifo_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(fifo_scoreboard)
        uvm_analysis_port #(fifo_seq_item) sb_export;
        uvm_tlm_analysis_fifo #(fifo_seq_item) sb_fifo;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
        fifo_seq_item item_sb;
        logic [FIFO_WIDTH-1:0]  data_out_ref;
        logic full_ref, wr_ack_ref, overflow_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
        localparam max_fifo_addr = $clog2(FIFO_DEPTH);//----------
        logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;//----------
        logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
        logic [max_fifo_addr:0] count;//----------
        int error_count,correct_count= 0;

        function new(string name = "fifo_scoreboard", uvm_component parent =null);
            super.new(name,parent);
        endfunction
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sb_export = new("sb_export",this);
            sb_fifo = new("sb_fifo",this);
        endfunction
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            sb_export.connect(sb_fifo.analysis_export);          
        endfunction
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                sb_fifo.get(item_sb);
                ref_model(item_sb);
                 if((item_sb.rd_en &&(data_out_ref !== item_sb.data_out)) || (full_ref !== item_sb.full) ||(wr_ack_ref !== item_sb.wr_ack)|| (overflow_ref!==item_sb.overflow) || 
                 (empty_ref!==item_sb.empty)|| (almostfull_ref!==item_sb.almostfull)|| (almostempty_ref!==item_sb.almostempty)|| (underflow_ref!==item_sb.underflow))begin
                    `uvm_error("run_phase", $sformatf("comparison failed, transaction received by the dut:  %s while the reference out :  data_out_ref=%0b, wr_ack_ref=%0b,overflow_ref=%0b, underflow_ref=%0b, full_ref=%0b, empty_ref=%0b,almostfull_ref=%0b, almostempty_ref=%0b , overflow_ref=%0b,underflow_ref=%0b "
                    ,item_sb.convert2string(),data_out_ref, wr_ack_ref, overflow_ref, underflow_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref,overflow_ref,underflow_ref));
                    error_count++;
                end
                else correct_count++;
            end   
        endtask
        task ref_model(fifo_seq_item item_chk);
            if (!item_chk.rst_n) begin
                rd_ptr = 0;
                wr_ptr = 0;
                count = 0;

                wr_ack_ref = 0;
                underflow_ref = 0;
                overflow_ref = 0;

                full_ref = 0;
                empty_ref = 1;
                almostfull_ref = 0;
                almostempty_ref = 0;
            end 
            else begin
                // Sread and write
                if(item_chk.wr_en && !full_ref)begin //write
                    mem[wr_ptr] = item_chk.data_in;
                    wr_ack_ref = 1;
                    wr_ptr ++;
                    count++;
                    overflow_ref=0;
                end
                else if(item_chk.wr_en && full_ref) begin
                        overflow_ref=1;
                        wr_ack_ref = 0;
                end
                else begin
                        wr_ack_ref = 0;
                        overflow_ref=0;  
                end

                if(item_chk.rd_en && !empty_ref)begin //read
                        data_out_ref = mem[rd_ptr];
                        rd_ptr++;
                        underflow_ref = 0;
                        count--;
                end 
                else if(item_chk.rd_en && empty_ref) underflow_ref=1;   
                else underflow_ref=0;

            full_ref = (count == FIFO_DEPTH)? 1 : 0;
            empty_ref = (count == 0)? 1 : 0;    
            almostfull_ref = (count == FIFO_DEPTH-1)? 1 : 0;
            almostempty_ref = (count == 1)? 1 : 0;
            end  
        endtask

        function void report_phase(uvm_phase phase);
            super.report_phase(phase);
            `uvm_info("report_phase",$sformatf("correct count = %0d",correct_count),UVM_MEDIUM);
            `uvm_info("report_phase",$sformatf("error count = %0d",error_count),UVM_MEDIUM);

        endfunction
    endclass
endpackage