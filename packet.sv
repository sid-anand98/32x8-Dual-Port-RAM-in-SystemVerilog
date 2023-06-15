//`include "parameters.sv"
class packet;
  
  //inputs that are randomized
  rand bit					rd_en,wr_en,rst;
  rand bit 	 [DATA_WIDTH:0]	data_in;
  rand logic [ADDR_WIDTH:0]	addr;
  
  //outputs that should NOT be randomized
  logic [DATA_WIDTH:0]data_out,data_out_monin;
  
  //constraints
  constraint valid {
    data_in inside {[0:((2**(DATA_WIDTH+1))-1)]};
    addr inside {[0:((2**(ADDR_WIDTH+1))-1)]};
    if(wr_en==0) rd_en!=0;
    if(wr_en==1) rd_en!=1;
  }
  
  /*
  constraint wr_rd{wr_en dist {0:/30,1:/70};
                   rd_en dist {0:/70,1:/30};
                  }
  */
  
  virtual function void print (string s="packet");
    $display("@%0t [%s] ADDR=%0d......DATA=%0d......WRITE=%0d......READ=%0d \n",$time,s,addr,data_in,wr_en,rd_en);
  endfunction
  
  virtual function void copy (packet p);
    if(p==null)
      begin
        $display("[PACKET] ERROR NULL OBJECT PASSED TO COPY METHORD \n");
      end
    else
      begin
        this.addr=p.addr;
        this.data_in=p.data_in;
        this.wr_en=p.wr_en;
        this.rd_en=p.rd_en;
      end
  endfunction
endclass

/*
//Consicutive WRITE/READ 

class packet_wr_rd extends packet;
  int l_addr;
  bit count;
  
  //Constraints
   constraint valid {
     data_in inside {[0:((2**(DATA_WIDTH+1))-1)]};
     addr inside {[0:MEM_SIZE]};
     addr==l_addr;
     if(wr_en==0) rd_en!=0;
     if(wr_en==1) rd_en!=1;
     if(count==0)
     {
       wr_en==1;
       rd_en==0;
     }
       else
       {
         wr_en==0;
         rd_en==1;
       }
   }
   function void post_randomize ();
     if(count==1)
       if(addr==MEM_SIZE) l_addr=0;
     else l_addr=l_addr+1;
     else l_addr=l_addr;
     count = ~count;
   endfunction
     
   virtual function void copy (packet p);
    if(p==null)
      begin
        $display("[PACKET] ERROR NULL OBJECT PASSED TO COPY METHORD \n");
      end
    else
      begin
        this.addr=p.addr;
        this.data_in=p.data_in;
        this.wr_en=p.wr_en;
        this.rd_en=p.rd_en;
      end
   endfunction
endclass
         
     class packet_wrall_rdall extends packet;
       int al_addr;
       bit count;
       
       //Constraints
       constraint valid {
         data_in inside {[0:((2**(DATA_WIDTH+1))-1)]};
         addr inside {[0:MEM_SIZE]};
         addr==al_addr;
         if(wr_en==0) rd_en!=0;
         if(wr_en==1) rd_en!=1;
         if(count==0) {
           wr_en==1;
           rd_en==0;
         }
           else {
             wr_en==0;
             rd_en==1;
           }
           }
             
         function void post_randomize();
         if(addr<MEM_SIZE) count=count;
         else	count=~count;
         
         if(addr<MEM_SIZE) al_addr=al_addr+1;
         else al_addr=0;
         endfunction
         
         virtual function void copy (packet p);
           if(p==null)
             begin
               $display("[PACKET] ERROR NULL OBJECT PASSED TO COPY METHORD \n ");
             end
           else
             begin
               this.addr=p.addr;
               this.data_in=p.data_in;
               this.wr_en=p.wr_en;
               this.rd_en=p.rd_en;
             end
           
         endfunction
         
     endclass
     */
