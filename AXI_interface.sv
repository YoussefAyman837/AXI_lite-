interface AXI_if(clk);

logic [31:0]read_addr , write_addr , write_data;
logic read_addr_valid , write_addr_valid , read_data_ready,write_data_valid ;
logic [31:0] read_data;
logic read_addr_ready , read_data_valid , write_addr_ready , write_data_ready;

logic  rstn;
input logic clk;

modport DUT (
input read_addr,write_addr,write_data,read_addr_valid,write_addr_valid,read_data_ready,write_data_valid,clk,rstn,
output read_data,read_addr_ready,read_data_valid,write_addr_ready,write_data_ready
);

modport TEST (
input read_data,read_addr_ready,read_data_valid,write_addr_ready,write_data_ready,clk,
output read_addr,write_addr,write_data,read_addr_valid,write_addr_valid,read_data_ready,write_data_valid,rstn
);

    
endinterface //AXI_if