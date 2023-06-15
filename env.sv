//`include "packet.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor_in.sv"
`include "monitor_out.sv"
`include "scoreboard.sv"

class env_ram;
  
  virtual ram_interface.DRV vif_drv;
  virtual ram_interface.IMON vif_imon;
  virtual ram_interface.OMON vif_omon;
  
  int no_of_pkts;
  
  generator gen;
  driver drv;
  monitor_in monin;
  monitor_out monout;
  scoreboard scb;
  
  mailbox #(packet) gen_drv_mbox;
  mailbox #(packet) monin_scb_mbox;
  mailbox #(packet) monout_scb_mbox;
  
  function new(input virtual ram_interface.DRV drv,
               input virtual ram_interface.IMON imon,
               input virtual ram_interface.OMON omon,
               input int no_of_pkts);
    
    vif_drv=drv;
    vif_imon=imon;
    vif_omon=omon;
    this.no_of_pkts=no_of_pkts;
    
  endfunction
  
  task build();
    $display("@%0t [ENV : BUILD ] STARTED",$time);
    gen_drv_mbox=new;
    monin_scb_mbox=new;
    monout_scb_mbox=new;
    
    gen=new(gen_drv_mbox,no_of_pkts);
    drv=new(gen_drv_mbox,vif_drv);
    monin=new(monin_scb_mbox,vif_imon);
    monout=new(monout_scb_mbox,vif_omon);
    scb=new(monin_scb_mbox,monout_scb_mbox);
    $display("@%0t [ENV : BUILD ] CONCULDED",$time);
  endtask
  
  task run();
    $display("@%0t [ENV : RUN ] SIMULATION STARTED",$time);
    //build();
    gen.run();
    
    fork
      drv.run();
      monin.run();
      monout.run();
      scb.run();
      //wait(no_of_pkts==scb.rd_no_of_pkts_recvd);
      wait(this.no_of_pkts==monout.no_of_pkts_recvd);
    join_any
    disable fork;
    
    $display("@%0t [ENV : RUN ] SIMULATION CONCLUDED",$time);
      final_result();
      endtask    
      
      task final_result();
        $display("Total pkts sent to DUT = %0d",no_of_pkts);
        $display("Write pkts sent to DUT = %0d",drv.wr_pkt);
        $display("Read pkts sent to DUT = %0d",drv.rd_pkt);
        $display("Matches (wr_data=rd_data) = %0d",scb.match);
        $display("Mismatches (wr_data!=rd_data) = %0d",scb.mismatch);
        $display("Missed (addr not found) = %0d",scb.missed);
        $display("Failed due to unknown reason = %0d",scb.black_hole);
        
        
        if(scb.mismatch==0)// && drv.rd_pkt==scb.missed+scb.match && scb.black_hole==0)
          
          begin
            $display("################################################");
            $display("PASS");
            $display("################################################");
          end
        else
          begin
            $display("################################################");
            $display("FAIL");
            $display("################################################");
          end
      endtask
      endclass
