# VHDL_BFM_FMWK

# Vhdl test framework

Update:

Replace bfm_req / bfm_ack mechanism by a unique bfm_control signal based on a resolved type.

This signal could have four values: 
* crtl_idle (default), 
* ctrl_request (TB send request to BFM), 
* ctrl_busy (BFM is working) and 
* ctrl_error (error case).

Resolution function is based on this table:

```
  CONSTANT RESOLUTION_TABLE : TABLE :=
	-- ctrl_idle	, ctrl_request	, ctrl_busy	 , ctrl_error	
	-- ------------------------------------------------------
	(( ctrl_idle	, ctrl_request	, ctrl_busy	 , ctrl_error	),  -- ctrl_idle
	 ( ctrl_request	, ctrl_error	, ctrl_busy	 , ctrl_error	),	-- ctrl_request
	 ( ctrl_busy	, ctrl_busy		, ctrl_busy	 , ctrl_error	),  -- ctrl_busy
	 ( ctrl_error	, ctrl_error	, ctrl_error , ctrl_error	)); -- ctrl_error
 ```
 
--------------------------------------------------

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
  
  
 
  
  
  


