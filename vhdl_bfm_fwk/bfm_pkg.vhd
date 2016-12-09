--###############################
--# Project Name : 
--# File         : 
--# Author       : Philippe THIRION
--# Description  : Package for Bus Functional Model 
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package BFM_PKG is

  TYPE operation_type IS
  (
    req_none,
    req_cpu_read,
    req_cpu_write,
    req_interrupt
  );

  TYPE info_type IS
  RECORD
	op  :  operation_type;
    parameter1  :  integer ;
    parameter2  :  integer ;
    parameter3  :  integer ;
  END RECORD info_type;
  
  PROCEDURE do_req(
	SIGNAL bfm_req : OUT std_logic;
	SIGNAL bfm_ack : IN  std_logic
  );
  
  PROCEDURE check_ack;
  
  shared variable bfm_info : info_type;
  
  signal bfm_req : std_logic;
  signal bfm_ack : std_logic;

end;


package body BFM_PKG is

  PROCEDURE check_ack is
  BEGIN
	if (bfm_ack /= 'Z') then
		wait until bfm_ack = 'Z';
	end if;
  END PROCEDURE check_ack;

  PROCEDURE do_req(
	SIGNAL bfm_req : OUT std_logic;
	SIGNAL bfm_ack : IN  std_logic
  ) IS
  BEGIN
	bfm_req <= '1';
	wait until bfm_ack = '0';
	wait for 0 ns;
	bfm_req <= '0';
  END PROCEDURE do_req;

end package body;
