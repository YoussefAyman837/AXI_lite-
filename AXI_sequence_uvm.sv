package AXI_reset_sequence_pkg;
import uvm_pkg::*;
import AXI_sequence_item_pkg::*;
`include "uvm_macros.svh"

class axi_reset_sequence extends uvm_sequence #(axi_sequence_item);
`uvm_object_utils(axi_reset_sequence)
axi_sequence_item seq_item;
    function new(string name = "axi_reset_sequence" );
        super.new(name);
    endfunction //new()

     task body;
        seq_item=axi_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rstn=0;
        finish_item(seq_item);
    endtask //
endclass //axi_reset_sequence extends superClass
    


endpackage