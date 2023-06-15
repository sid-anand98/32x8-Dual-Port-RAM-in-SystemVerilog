`include "ram_interface.sv"
`include "ram_program.sv"

module top;
  bit clk,rst;
  
  initial
    begin
      clk=0;
      forever #5 clk=~clk; //setting up clk pulse
    end
  
  initial
    begin
      $display("########## - RESETTING RAM ############");
      @(posedge clk) rst<=1;
      @(posedge clk) rst<=0;
    end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  //wiring 
  
  ram_interface ramif(clk,rst);
  ram duv(.clk(clk),.rst(rst),.data_in(ramif.data_in),.wr_en(ramif.wr_en),.rd_en(ramif.rd_en),.addr(ramif.addr),.data_out(ramif.data_out));
  
  program_ram pgb(ramif);
endmodule
