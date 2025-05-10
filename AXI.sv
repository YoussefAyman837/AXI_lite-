
module AXI_a1(AXI_if.DUT aif);

//write address channel parameters
parameter WA_IDLE =2'b00 ;
parameter WA_BEGIN=2'b01 ;           
parameter WA_DONE =2'b10 ;

reg [1:0]WA_ns , WA_cs;
//read address channel parameters

parameter RA_IDLE =2'b00 ;
parameter RA_BEGIN=2'b01 ;           
parameter RA_DONE =2'b10 ;

logic [1:0]RA_ns , RA_cs;


//write data channel parameters 
parameter WD_IDLE =2'b00 ;
parameter WD_BEGIN=2'b01 ;           
parameter WD_DONE =2'b10 ;

logic [1:0]WD_ns , WD_cs;

 
//read data channel parameters 
parameter RD_IDLE =2'b00 ;
parameter RD_BEGIN=2'b01 ;           
parameter RD_DONE =2'b10 ;

logic [1:0]RD_ns , RD_cs;



logic [31:0] slave_mem[255:0];
logic [31:0] AWADDR_reg;
logic [31:0] ARADDR_reg=32'h00000000;


integer i;

initial begin
    for (int i = 0; i < 256; i++) 
        slave_mem[i] = 32'h00000000;  // Initialize all memory locations to zero
end




//write address state transition
always @(posedge aif.clk) begin
    if(!aif.rstn)
        WA_cs<=WA_IDLE;
    else 
        WA_cs<=WA_ns;
end

//next state write address logic
always @(*) begin
    case (WA_cs)
        WA_IDLE:begin
             if(aif.write_addr_valid ) begin
                WA_ns=WA_BEGIN;
       end 
       else 
       WA_ns=WA_IDLE;
        end
       WA_BEGIN: WA_ns=WA_DONE;

       WA_DONE:  WA_ns=WA_IDLE;

    endcase
end


//output write address logic 
always @(posedge aif.clk) begin
    if(!aif.rstn)begin
        aif.write_addr_ready<=0;
    end
    else begin
        case (WA_cs)
            WA_IDLE:aif.write_addr_ready<=0;
            WA_BEGIN:begin 
                aif.write_addr_ready<=1;
                AWADDR_reg<=aif.write_addr;
            end
            WA_DONE: aif.write_addr_ready<=0;
        endcase        
    end
end




//read address state transition
always @(posedge aif.clk) begin
    if(!aif.rstn)
        RA_cs<=RA_IDLE;
    else 
        RA_cs<=RA_ns;
end

//next state read address logic
always @(*) begin
    case (RA_cs)
        RA_IDLE: begin 
            if(aif.read_addr_valid ) begin
                RA_ns=RA_BEGIN;
       end 
       else 
       RA_ns=RA_IDLE;
        end
       RA_BEGIN: RA_ns=RA_DONE;

       RA_DONE:  RA_ns=RA_IDLE;

    endcase
end


//output write address logic 
always @(posedge aif.clk) begin
    if(!aif.rstn)begin
        aif.read_addr_ready<=0;
    end
    else begin
        case (RA_cs)
            RA_IDLE:aif.read_addr_ready<=0;
            RA_BEGIN:begin 
                aif.read_addr_ready<=1;
                ARADDR_reg<=aif.read_addr;
            end
            RA_DONE: aif.read_addr_ready<=0; 
 
        endcase        
    end
end


//state transition write data channel 

always @(posedge aif.clk) begin
    if(!aif.rstn)
        WD_cs<=WD_IDLE;
    else
        WD_cs<=WD_ns;
end


//next state logic write data channel 

always @(*) begin
    case (WD_cs)
        WD_IDLE:begin
            if(aif.write_data_valid) begin
                WD_ns=WD_BEGIN;
            end
            else
            WD_ns=WD_IDLE;
        end 
        WD_BEGIN: WD_ns=WD_DONE;

        WD_DONE: WD_ns=WD_IDLE;
        
    endcase
end


//output logic for write data channel 

always @(posedge aif.clk) begin
    if(!aif.rstn)begin
        aif.write_data_ready<=0;
    end
    else begin
        case (WD_cs)
            WD_IDLE: aif.write_data_ready<=0;

            WD_BEGIN:begin
                aif.write_data_ready<=1;
                slave_mem[AWADDR_reg ]<=aif.write_data;
            end
            WD_DONE: aif.write_data_ready<=0;
                            
            
        endcase
    end
end


//read data state transition
always @(posedge aif.clk) begin
    if(!aif.rstn)
        RD_cs<=RD_IDLE;
    else 
        RD_cs<=RD_ns;
end

//read data next state logic
always @(*) begin
    case (RD_cs)
        RD_IDLE:begin
            if(aif.read_data_ready ) begin
                RD_ns=RD_BEGIN;
            end
            else
             RD_ns=RD_IDLE;
        end 
        RD_BEGIN: RD_ns=RD_DONE;

        RD_DONE: RD_ns=RD_IDLE;
        
    endcase
end


//output logic for read data channel 

always @(posedge aif.clk) begin
    if(!aif.rstn)begin
        aif.read_data_valid<=0;
    end
    else begin
        case (RD_cs)
            RD_IDLE: aif.read_data_valid<=0;

            RD_BEGIN:begin
                aif.read_data_valid<=1;
                aif.read_data<=slave_mem[ARADDR_reg];
            end
            RD_DONE:aif.read_data_valid<=0;
                        
        endcase
    end
end

assert property(@(posedge aif.clk) disable iff(!aif.rstn) (aif.write_addr_valid && WA_cs==WA_DONE |->aif.write_addr_ready));
assert property(@(posedge aif.clk) disable iff(!aif.rstn) (aif.write_data_valid && WD_cs==WD_DONE |-> aif.write_data_ready));
assert property(@(posedge aif.clk) disable iff(!aif.rstn) (aif.read_addr_valid && RA_cs==RA_DONE |-> aif.read_addr_ready ));
assert property(@(posedge aif.clk) disable iff(!aif.rstn) (aif.read_data_ready && RD_cs==RD_DONE |-> aif.read_data_valid ));
assert property (@(posedge aif.clk) disable iff(!aif.rstn)(aif.read_data_valid |->  aif.read_data==slave_mem[ARADDR_reg]));
assert property(@(posedge aif.clk)disable iff(!aif.rstn) (aif.write_data_ready |->  slave_mem[AWADDR_reg]==aif.write_data));


endmodule