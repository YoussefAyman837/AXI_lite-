module AXI_tb (
);
logic [31:0]read_addr , write_addr , write_data;
logic read_addr_valid , write_addr_valid , read_data_ready,write_data_valid ;
logic [31:0] read_data;
logic read_addr_ready , read_data_valid , write_addr_ready , write_data_ready;

logic clk , rstn;
    
AXI a1(.*);
initial begin
    clk=0;
    forever begin
       #1 clk= ~clk;
    end
end

initial begin
    rstn=0;
    read_addr_valid=0;
    write_addr_valid=0;
    read_data_ready=0;
    write_data_valid=0;
    @(negedge clk);
    rstn=1;

   write_addr=15;
   write_data=100;
   @(negedge clk);
    write_addr_valid=1;
    write_data_valid=1;
    @(negedge clk);
    read_addr=15;
    @(negedge clk);
    read_addr_valid=1;
    read_data_ready=1;
end

endmodule
