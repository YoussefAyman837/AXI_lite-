import uvm_pkg::*;
import AXI_config_pkg::*;
import AXI_test_pkg::*;
module AXI_top (
);
bit clk;

initial begin
    clk=0;
    forever begin
        #1 clk= ~clk;
    end
end

AXI_if aif(clk);

AXI_a1 a1(aif);

initial begin
    uvm_config_db #(virtual AXI_if)::set(null , "*" , "AXI_if",aif);
    run_test("AXI_test");
end

endmodule