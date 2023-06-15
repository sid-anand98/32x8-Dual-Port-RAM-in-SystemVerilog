class scoreboard;
  
  int total_pkts_recvd;
  packet imon_pkt;
  packet omon_pkt;
  mailbox #(packet) mbox_in;
  mailbox #(packet) mbox_out;
  
  bit [15:0] match;
  bit [15:0] mismatch;
  bit [15:0] missed;
  bit [15:0] black_hole;
  
  int wr_no_of_pkts_recvd;
  int rd_no_of_pkts_recvd;
  int i;
  
  function new (input mailbox #(packet) mbox_in,
                input mailbox #(packet) mbox_out);
    this.mbox_in = mbox_in;
    this.mbox_out = mbox_out;
  endfunction
  
  task run;
    $display("@%0t [SCOREBOARD] RUN STARTED \n",$time);
    imon_pkt=new();
    omon_pkt=new();
    
    fork
      begin
        while(1)
          begin
            wr_no_of_pkts_recvd++;
            mbox_in.get(imon_pkt);
            $display("@%0t [SCOREBOARD_in] Addr=%0d monin_data=%0d",$time,imon_pkt.addr, imon_pkt.data_out_monin);
          end
      end
      
      begin
        while(1)
          begin
            mbox_out.get(omon_pkt);
            rd_no_of_pkts_recvd++;
            $display("@%0t [SCOREBOARD_out] Addr=%0d monout_data=%0d",$time,omon_pkt.addr, omon_pkt.data_out);
            if(imon_pkt.data_out_monin==omon_pkt.data_out)
              begin
                $display("@%0t [SCOREBOARD] PASS Addr=%0d \t TB_data=%0d, DUT_data=%0d ",$time,omon_pkt.addr, imon_pkt.data_out_monin, omon_pkt.data_out);
                match = match+1;
              end
            
            else if(imon_pkt.data_out_monin===8'dx && omon_pkt.data_out===8'dx && omon_pkt.addr!==5'dx && imon_pkt.rd_en==1)
              begin
              $display("@%0t [SCOREBOARD] ADDR NOT WRITTEN Addr=%0d TB_data=%0d, DUT_data=%0d rd_en=%0d ",$time,omon_pkt.addr, imon_pkt.data_out_monin, omon_pkt.data_out,imon_pkt.rd_en);
            missed = missed+1;
          end
        
        else if(imon_pkt.data_out_monin!=omon_pkt.data_out)
          begin
            $display("@%0t [SCOREBOARD] FAIL Addr=%0d \t TB_data=%0d, DUT_data=%0d ",$time,omon_pkt.addr, imon_pkt.data_out_monin, omon_pkt.data_out);
              mismatch = mismatch+1;
          end
      end
      end
    join
  endtask
endclass
