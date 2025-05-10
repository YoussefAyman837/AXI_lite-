package AXI_monitor_pkg;
import uvm_pkg::*;
import AXI_sequence_item_pkg::*;
import AXI_driver_pkg::*;
`include "uvm_macros.svh"

class axi_monitor extends uvm_monitor;
`uvm_component_utils(axi_monitor);
uvm_analysis_port #(axi_sequence_item) aport;
virtual AXI_if axi_vif;
    function new(string name ="axi_monitor" , uvm_component parent=null);
    super.new(name,parent);
        
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        aport=new("aport",this);
        
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            axi_sequence_item seq_item;
            @(negedge axi_vif.clk);
            @(negedge axi_vif.clk);
            @(negedge axi_vif.clk);
            seq_item=axi_sequence_item::type_id::create("seq_item");
            seq_item.read_addr=axi_vif.read_addr;
            seq_item.write_addr=axi_vif.write_addr;
            seq_item.write_data=axi_vif.write_data;
            seq_item.read_addr_valid=axi_vif.read_addr_valid;
            seq_item.write_addr_valid=axi_vif.write_addr_valid;
            seq_item.read_addr_ready=axi_vif.read_addr_ready;
            seq_item.write_addr_ready=axi_vif.write_addr_ready;
            seq_item.read_data_ready=axi_vif.read_data_ready;
            seq_item.write_data_ready=axi_vif.write_data_ready;
            seq_item.read_data_ready=axi_vif.read_data_ready;
            seq_item.write_data_ready=axi_vif.write_data_ready;
            aport.write(seq_item);
            `uvm_info("run_phase" , seq_item.convert2string(), UVM_HIGH)
        end
    endtask //


endclass //axi_monitor extends superClass
    
endpackage