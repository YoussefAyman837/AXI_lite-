package AXI_driver_pkg;
import uvm_pkg::*;
import AXI_sequence_item_pkg::*;
`include "uvm_macros.svh"

class axi_driver extends uvm_driver #(axi_sequence_item);
`uvm_component_utils(axi_driver);
axi_sequence_item seq_item;
virtual AXI_if axi_vif;
    function new(string name="axi_driver" , uvm_component parent =null);
        super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item=axi_sequence_item::type_id::create("seq_item");
            seq_item_port.get_next_item(seq_item);
            axi_vif.rstn=seq_item.rstn;
            axi_vif.read_addr=seq_item.read_addr;
            axi_vif.write_addr=seq_item.write_addr;
            axi_vif.write_data=seq_item.write_data;
            axi_vif.read_addr_valid=seq_item.read_addr_valid;
            axi_vif.write_addr_valid=seq_item.write_addr_valid;
            axi_vif.read_data_ready=seq_item.read_data_ready;
            axi_vif.write_data_valid=seq_item.write_data_valid;
            @(posedge axi_vif.clk);
            @(posedge axi_vif.clk);
            @(posedge axi_vif.clk);
            seq_item_port.item_done();
            `uvm_info("run phase" , seq_item.convert2string(), UVM_HIGH)

        end
    endtask //
endclass //axi_driver extends superClass
    
endpackage