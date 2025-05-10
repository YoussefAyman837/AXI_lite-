package AXI_env_pkg;
import uvm_pkg::*;
import AXI_agent_pkg::*;
import AXI_scorebord_pkg::*;
`include "uvm_macros.svh"

class AXI_environment extends uvm_env;
AXI_scoreboard sb;
axi_agent agt;
`uvm_component_utils(AXI_environment);
    function new(string name="AXI_environment" , uvm_component parent=null);
        super.new(name,parent);
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt=axi_agent::type_id::create("agt" , this);
        sb=AXI_scoreboard::type_id::create("sb" , this);
    endfunction

    function void connect_phase(uvm_phase phase);
        agt.aport.connect(sb.sb_export);
    endfunction
endclass //AXI_enviroment extends superClass
endpackage