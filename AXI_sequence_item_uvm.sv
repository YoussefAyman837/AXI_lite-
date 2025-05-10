package AXI_sequence_item_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class axi_sequence_item extends uvm_sequence_item;

rand logic [31:0]read_addr , write_addr , write_data;
rand logic read_addr_valid , write_addr_valid , read_data_ready,write_data_valid ;
logic [31:0] read_data;
logic read_addr_ready , read_data_valid , write_addr_ready , write_data_ready;

logic rstn;
    constraint write_read_conflict{
        write_data_valid == !read_data_ready;
    }
    constraint read_conflict{
        read_addr_valid == ~read_data_ready;
    }
    constraint c1{
        write_addr_valid == !read_addr_valid;
    }

`uvm_object_utils(axi_sequence_item)
    function new(string name="axi_sequence_item");
        super.new(name);
    endfunction //new()

    function string convert2string();
        return $sformatf ("%s reset =0%0b , read addr=0%0b , write addr=0%0b , write data = 0%0b , read addr valid=0%0b , write addr valid = 0%0b , read data ready =0%0b 
        , write data valid=0%0b , read data =0%0b , read addr ready =0%0b , read data valid =0%0b , write addr ready =0%0b ,write data ready=0%0b" ,super.convert2string(), rstn , read_addr , write_addr 
        ,write_data , read_addr_valid,write_addr_valid , read_data_ready , write_data_valid , read_data , read_addr_ready , read_data_valid,write_addr_ready,write_data_ready);
        
    endfunction
endclass //axi_sequence_item extends superClass
    
endpackage