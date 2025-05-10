package AXI_sequencer_pkg;
import uvm_pkg::*;
import AXI_sequence_item_pkg::*;
`include "uvm_macros.svh"
class axi_sequencer extends uvm_sequencer#(axi_sequence_item);
`uvm_component_utils(axi_sequencer)

    function new(string name="axi_sequencer" , uvm_component parent = null);
        super.new(name,parent);
    endfunction //new()
endclass //uvm_sequencer extends superClass
    
endpackage