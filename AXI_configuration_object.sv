package AXI_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_config extends uvm_object;
`uvm_object_utils(axi_config)
virtual AXI_if axi_vif;
    function new(string name="axi_config");
        super.new(name);
    endfunction //new()
endclass //axi_config extends superClass
    
endpackage