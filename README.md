# VHDL_BFM_FMWK

# Vhdl test framework

* Content:

  tb_bfm_cpu.vhd    : Test Bench (example)

  bfm_cpu.vhd       : Bus Functional Model for CPU stimilis (example)

  cpu_pkg.vhd       : Package for CPU (example)

  bfm_pkg.vhd       : Bus Functional Model Package
  
* Principle:

  - The TestBench (TB) send a request to the Bus Functional Model (BFM). The request contains the operation and data.
  - The BFM checks if it is concerned by this operation.
  - In this case, the BFM asserts the acknowledge and performs the operation using associated data. 
  - At the end of the operation BFM desasserts the acknowledge and then get back the control to TB.
  - The TB gets the result and continue with the next request.
  
* Variables and signals

  - bfm_info is a record (shared variable) which contains operation and data sended by TB and result sended to TB.
  - bfm_req and bfm_ack signals are used for handshaking between TB and BFM.
  
* Multi BFM framework

  - Several BFMs could asserts the same bfm_ack (asserted at '0', desasserted at 'Z').
  - Only the BFM which recognizes the operation asserts bfm_ack ( asserts at '0') before performing operation.
  - It 's also possible that several BFM execute code for the same operation.
  
  
 
  
  
  


