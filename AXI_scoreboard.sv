package AXI_scorebord_pkg;
import uvm_pkg::*;
import AXI_sequence_item_pkg::*;
`include "uvm_macros.svh"

class AXI_scoreboard extends uvm_scoreboard;
`uvm_component_utils(AXI_scoreboard);
uvm_analysis_export #(axi_sequence_item) sb_export;
uvm_tlm_analysis_fifo #(axi_sequence_item) sb_fifo;
axi_sequence_item seq_item;
virtual AXI_if vif;
logic [31:0] read_data_ref;
logic read_addr_ready_ref , read_data_valid_ref , write_addr_ready_ref , write_data_ready_ref;

    function new(string name="AXI_scoreboard" , uvm_component parent=null);
        super.new(name,parent);
    endfunction //new()


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export=new("sb_export",this);
        sb_fifo=new("sb_fifo",this);
        if (!uvm_config_db#(virtual AXI_if)::get(this, "", "AXI_if", vif)) begin
            `uvm_fatal("AXI_SCOREBOARD", "Clock handle not set in scoreboard!")
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        // Wait for reset deassertion
        wait(vif.rstn);
        `uvm_info("AXI_SCOREBOARD", "Reset deasserted, starting transactions", UVM_MEDIUM)
        forever begin
            @(negedge vif.clk);
            @(negedge vif.clk);
            @(negedge vif.clk);

            sb_fifo.get(seq_item);
            ref_model();
            
             // Ensure reference signals are updated before comparison
            //@(negedge vif.clk);
            // Debug messages
            /*
            `uvm_info("run_phase", $sformatf("Reference: write_addr_ready_ref = %0b, write_data_ready_ref = %0b, read_addr_ready_ref = %0b, read_data_valid_ref = %0b, read_data_ref = %0h",
                write_addr_ready_ref, write_data_ready_ref, read_addr_ready_ref, read_data_valid_ref, read_data_ref), UVM_LOW);
            `uvm_info("run_phase", $sformatf("Actual: write_addr_ready = %0b, write_data_ready = %0b, read_addr_ready = %0b, read_data_valid = %0b, read_data = %0h",
                vif.write_addr_ready, vif.write_data_ready, vif.read_addr_ready, vif.read_data_valid, vif.read_data), UVM_LOW);
            */
            // Comparison logic
        
            if (vif.write_addr_ready != write_addr_ready_ref) begin
                `uvm_error("run_phase", $sformatf("Write Addr Ready comparison failed: Expected %0b, Actual %0b", write_addr_ready_ref, vif.write_addr_ready));
            end
            if (vif.write_data_ready != write_data_ready_ref) begin
                `uvm_error("run_phase", $sformatf("Write Data Ready comparison failed: Expected %0b, Actual %0b", write_data_ready_ref, vif.write_data_ready));
            end
            if (vif.read_addr_ready != read_addr_ready_ref) begin
                `uvm_error("run_phase", $sformatf("Read Addr Ready comparison failed: Expected %0b, Actual %0b", read_addr_ready_ref, vif.read_addr_ready));
            end
            if (vif.read_data_valid != read_data_valid_ref) begin
                `uvm_error("run_phase", $sformatf("Read Data Valid comparison failed: Expected %0b, Actual %0b", read_data_valid_ref, vif.read_data_valid));
            end
            if (vif.read_data != read_data_ref) begin
                `uvm_error("run_phase", $sformatf("Read Data comparison failed: Expected %0h, Actual %0h", read_data_ref, vif.read_data));
            end
        end
    endtask
    task ref_model();
        if(!vif.rstn)begin
         write_addr_ready_ref = 0;  
        write_data_ready_ref = 0;
        read_addr_ready_ref = 0;
        read_data_valid_ref = 0;
        read_data_ref = 0;   
        end
        else begin
        if(vif.write_addr_valid)begin
           // @(negedge vif.clk);
            write_addr_ready_ref=1;
        end
        else begin
            write_addr_ready_ref=0;
        end
         if(vif.write_data_valid)begin
            //@(negedge vif.clk);
            write_data_ready_ref=1;
        end
        else begin
            write_data_ready_ref=0;
        end
         if(vif.read_addr_valid)begin
            //@(negedge vif.clk);
            read_addr_ready_ref=1;
        end
        else begin
            read_addr_ready_ref=0;
        end
         if(vif.read_data_ready)begin
            //@(negedge vif.clk);
            read_data_valid_ref=1;
            read_data_ref=vif.read_data;
        end
        else begin
            read_data_valid_ref=0;
        end
        end
    endtask //
endclass //AXI_scoreboard extends superClass
endpackage
