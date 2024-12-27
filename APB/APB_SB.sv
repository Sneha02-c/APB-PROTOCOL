`include "APB_COVERAGE.sv"
class apb_sb extends uvm_scoreboard;
`uvm_component_utils(apb_sb)

apb_seq_item pkt1,pkt2;
coverage covg;

uvm_tlm_analysis_fifo #(apb_seq_item)ip_fifo; //used for holding input transactions.
uvm_tlm_analysis_fifo #(apb_seq_item)op_fifo;// holds output transactions.

function new(string name="apb_sb",uvm_component parent);
super.new(name,parent);
ip_fifo=new("ip_fifo",this);//creating memory for the ip_fifo
op_fifo=new("op_fifo",this);
endfunction

virtual function void build_phase(uvm_phase phase);
super.build_phase(phase);
pkt1=apb_seq_item::type_id::create("pkt1",this);//creates a new instance of apb_seq_item called pkt1.
pkt2=apb_seq_item::type_id::create("pkt2",this);//creates a new instance of apb_seq_item called pkt2.

covg=coverage::type_id::create("covg",this);//creates a new instance of coverage called covg.

endfunction

task run_phase(uvm_phase phase);
forever
begin
fork
ip_fifo.get(pkt1);//This process retrieves a transaction from the ip_fifo and stores it in pkt1.
op_fifo.get(pkt2);//This process retrieves a transaction from the op_fifo and stores it in pkt2.
join
if(pkt2.prdata==pkt1.prdata)//input monitor prdata is compared with output monitor's prdata.
begin
`uvm_info("SB MATCHED",$sformatf("pkt1.prdata=%p,pkt2.prdata=%p",pkt1.prdata,pkt2.prdata),UVM_NONE);
end
else
begin
`uvm_info("SB MISMATCHED",$sformatf("pkt1.prdata=%p,pkt2.prdata=%p",pkt1.prdata,pkt2.prdata),UVM_NONE);
end

covg.p1=pkt1;
covg.cvg.sample();
end
endtask
endclass


