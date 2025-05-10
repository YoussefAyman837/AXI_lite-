package AXI_test_pkg;
import uvm_pkg::*;
import AXI_env_pkg::*;
import AXI_config_pkg::*;
import AXI_main_sequence_pkg::*;
import AXI_sequencer_pkg::*;
import AXI_reset_sequence_pkg::*;
import AXI_sequence_item_pkg::*;
`include "uvm_macros.svh"

class AXI_test extends uvm_test;
axi_sequence_item seq_item;
axi_reset_sequence rst_seq;
axi_config cfg;
AXI_environment env;
virtual AXI_if axi_vif;
axi_main_sequence seq;
`uvm_component_utils(AXI_test);
    function new(string name="AXI_test" , uvm_component parent=null);
        super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg=axi_config::type_id::create("cfg");
        env=AXI_environment::type_id::create("env",this);
        seq=axi_main_sequence::type_id::create("seq");
        rst_seq=axi_reset_sequence::type_id::create("rst_seq");
        if(!uvm_config_db #(virtual AXI_if)::get(this,"","AXI_if",axi_vif))
        `uvm_fatal("build_phase", "unable to get virtual interface");
        cfg.axi_vif=axi_vif;

        uvm_config_db #(axi_config)::set(this,"*" , "CFG" , cfg);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        rst_seq.start(env.agt.sqr);
        seq.start(env.agt.sqr);
        phase.drop_objection(this);
    endtask 


endclass //AXI_test extends superClass
endpackage