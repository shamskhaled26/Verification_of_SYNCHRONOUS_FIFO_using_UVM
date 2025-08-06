package fifo_seq_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class fifo_seq_item extends uvm_sequence_item;
`uvm_object_utils(fifo_seq_item)
  rand logic rst_n, wr_en, rd_en;
  rand logic [15:0] data_in;
  logic [15:0] data_out;//
  bit wr_ack, overflow, full, empty, almostfull, almostempty, underflow;

    function new(string name ="fifo_seq_item");
        super.new(name);
    endfunction 

    function string convert2string();
        return $sformatf ("%s rst_n = %0b ,wr_en= %0b, rd_en= %0b, data_in=%0b , data_out=%0b, wr_ack = %0b ,full= %0b, empty= %0b, almostfull=%0b almostempty = %0b ,overflow= %0b, underflow= %0b"
        ,super.convert2string(),rst_n,wr_en, rd_en, data_in,data_out,wr_ack,full,empty,almostfull,almostempty,overflow,underflow);
    endfunction

    function string convert2string_stimulus();
        return $sformatf ("rst_n = %0b ,wr_en= %0b, rd_en= %0b, data_in=%0b , data_out=%0b, wr_ack = %0b ,full= %0b, empty= %0b, almostfull=%0b almostempty = %0b ,overflow= %0b, underflow= %0b"
        ,rst_n,wr_en, rd_en, data_in,data_out,wr_ack,full,empty,almostfull,almostempty,overflow,underflow);
    endfunction

////////////////////////////////////////////////
    int RD_EN_ON_DIST =30;
    int WR_EN_ON_DIST =70;

    constraint reset_enable{
        rst_n dist{0:/ 5 , 1:/95};
    }
    constraint write_enable{
        wr_en dist{1:/ WR_EN_ON_DIST , 0:/(100-WR_EN_ON_DIST)};
    }
    constraint read_enable{
        rd_en dist{1:/ RD_EN_ON_DIST , 0:/(100-RD_EN_ON_DIST)};
    } 

endclass 
    
endpackage