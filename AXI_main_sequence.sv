package AXI_main_sequence_pkg;
import uvm_pkg::*;
import AXI_sequence_item_pkg::*;
`include "uvm_macros.svh"

class axi_main_sequence extends uvm_sequence #(axi_sequence_item);
`uvm_object_utils(axi_main_sequence)
axi_sequence_item seq_item;
logic [7:0] counter=1;
    function new(string name = "axi_main_sequence" );
        super.new(name);
    endfunction //new()

    task body;
    repeat(100)begin
        seq_item=axi_sequence_item::type_id::create("seq_item");
        counter=counter+1;
        start_item(seq_item);
        assert (seq_item.randomize()); 
        seq_item.write_addr=counter;
        seq_item.read_addr=counter-1;
        seq_item.rstn=1;
        finish_item(seq_item);
    end
        
    endtask 
endclass //axi_main_sequence extends superClass
    
    
endpackage