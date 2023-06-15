`include "testcases.sv"
program program_ram(ram_interface vif);
  
  test_ram test;
  //test_ram_wr_rd test_wr_rd;
  //test_ram_wrall_rdall test_wrall_rdall;
  
  initial
    begin
      $display("@%0t [PGM BLOCK] SIMULATION STARTED",$time);
      test=new(vif.DRV,vif.IMON,vif.OMON);
      test.run();
      $display("@%0t [PGM BLOCK] SIMULATION CONCLUDED",$time);
      
      //CONSECUTIVE WRITE/READ
      /*
      $display("@%0t [PGM BLOCK - WR_RD] SIMULATION STARTED",$time);
      test_wr_rd=new(vif.DRV,vif.IMON,vif.OMON);
      test_wr_rd.run();
      $display("@%0t [PGM BLOCK - WR_RD] SIMULATION CONCLUDED",$time);
      
      //WRITE ALL / READ ALL
      
      $display("@%0t [PGM BLOCK - WRALL_RDALL] SIMULATION STARTED",$time);
      test_wrall_rdall=new(vif.DRV,vif.IMON,vif.OMON);
      test_wrall_rdall.run();
      $display("@%0t [PGM BLOCK - WRALL_RDALL] SIMULATION CONCLUDED",$time);
      */
      $finish;
      
    end
endprogram
