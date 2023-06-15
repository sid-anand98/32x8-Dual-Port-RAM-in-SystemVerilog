`include "packet.sv"

class generator;
  int no_of_pkts;
  packet ref_pkt,pkt;
  
  mailbox #(packet)mbox;
  
  function new (mailbox #(packet) mbox_in,int gen_pkts_no=1);
    no_of_pkts = gen_pkts_no;
    mbox = mbox_in;
    ref_pkt = new();
  endfunction
  
  task run();
    int pkt_count;
    $display("@%0t [GENERATOR] Run Started \n",$time);
    repeat(no_of_pkts)
      begin
        assert(ref_pkt.randomize());
        pkt=new;
        pkt.copy(ref_pkt);
        mbox.put(pkt);
        pkt_count=pkt_count+1;
        $display("@%0t [GENERATOR] Sent packet %0d to DRIVER \n",$time,pkt_count);
        pkt.print("GENERATOR");
      end
    $display("@%0t [GENERATOR] Run Concluded. Size of mbox=%0d \n",$time,mbox.num());
  endtask
  
endclass
        
