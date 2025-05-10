package AXI_agent_pkg;
import uvm_pkg::*;
import AXI_driver_pkg::*;
import AXI_monitor_pkg::*;
import AXI_sequencer_pkg::*;
import AXI_sequence_item_pkg::*;
import AXI_config_pkg::*;
`include "uvm_macros.svh"

class axi_agent extends uvm_agent;
axi_driver drv;
axi_monitor mon;
axi_sequencer sqr;
axi_config cfg;
virtual AXI_if axi_vif;
uvm_analysis_port #(axi_sequence_item) aport;
`uvm_component_utils(axi_agent)

    function new(string name="axi_agent" , uvm_component parent=null);
    super.new(name,parent);
        
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(axi_config)::get(this,"" , "CFG" , cfg))
        `uvm_fatal("build_phase" , "unable to get config object " )
        drv=axi_driver::type_id::create("drv",this);
        mon=axi_monitor::type_id::create("mon",this);
        sqr=axi_sequencer::type_id::create("sqr",this);
        aport=new("aport",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.axi_vif=cfg.axi_vif;
        mon.axi_vif=cfg.axi_vif;
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.aport.connect(aport);
        
    endfunction
endclass //axi_agent extends superClass
    
endpackage