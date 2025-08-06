package fifo_sequence_pkg;
import uvm_pkg::*;
import fifo_seq_item_pkg::*;
`include "uvm_macros.svh"
    class fifo_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(fifo_sequence)
        fifo_seq_item seq_item;

        function new(string name ="fifo_sequence");
            super.new(name);
        endfunction //new()

        task body;
            seq_item = fifo_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            seq_item.rst_n=0;
            seq_item.data_in=0;
            seq_item.wr_en=0;
            seq_item.rd_en=0;
            finish_item(seq_item);

        repeat(2000)begin 
            seq_item = fifo_seq_item::type_id::create("seq_item");
            start_item(seq_item);
            assert(seq_item.randomize());
            finish_item(seq_item);
            end
        endtask
    endclass 
   
endpackage