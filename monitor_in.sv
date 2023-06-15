class monitor_in;
  int no_of_pkts_recvd;
  logic [DATA_WIDTH:0]ass_a[*];
  packet pkt;
  virtual ram_interface.IMON vif;
  mailbox #(packet) mbox;
  
  int wr_no_of_pkts_recvd;
  int rd_no_of_pkts_recvd;
  
  function new(input mailbox #(packet) mbox_in,
               input virtual ram_interface.IMON vif_in);
    mbox=mbox_in;
    vif = vif_in;
    if(this.vif==null)
      $display("[INPUT-MONITOR] Interface handle not set");
  endfunction
  
  task run();
    $display("@%0t [INPUT-MONITOR] RUN STARTED\n",$time);
    
    while(1)
      begin
        @(vif.imon_cb);
        pkt=new;
        pkt.addr = vif.imon_cb.addr;
        pkt.data_in = vif.imon_cb.data_in;
        pkt.wr_en = vif.imon_cb.wr_en;
        pkt.rd_en = vif.imon_cb.rd_en;
        if(vif.imon_cb.wr_en==1 && vif.imon_cb.wr_en==0)
          begin
            ass_a[pkt.addr] = vif.imon_cb.data_in;
            wr_no_of_pkts_recvd++;
            $display("@%0t [INPUT-MONITOR - WRITE OPERATION] Packet_no=%0d to SCB with addr=%0d, data=%0d",$time,no_of_pkts_recvd,vif.imon_cb.addr,ass_a[pkt.addr]);
            $display("#########################################################");
          end
        
        else if(vif.imon_cb.rd_en==1 && vif.imon_cb.wr_en==0)
          begin
            rd_no_of_pkts_recvd++;
            $display("@%0t [INPUT-MONITOR - READ OPERATION] Packet_no=%0d to SCB with addr=%0d",$time,no_of_pkts_recvd,vif.imon_cb.addr);
            $display("#########################################################");
            if(ass_a.exists(pkt.addr))
              begin
                pkt.data_out_monin = ass_a[pkt.addr];
              end
          end
        
        mbox.put(pkt);
        no_of_pkts_recvd++;
      end
    $display("@%0t [INPUT-MONITOR] RUN CONCLUDED",$time);
  endtask
endclass    
