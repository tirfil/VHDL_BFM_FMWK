--###############################
--# Project Name : 
--# File         : 
--# Author       : Philippe THIRION
--# Description  : Package for Bus Functional Model CPU
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.bfm_pkg.all;

package CPU_PKG is

PROCEDURE cpu_read
  (
	SIGNAL bfm_control : INOUT bfm_control_type;
    CONSTANT addr : IN    integer;
    VARIABLE data : OUT   integer
  );
  
PROCEDURE cpu_write
  (
	SIGNAL bfm_control : INOUT bfm_control_type;
    CONSTANT addr : IN    integer;
    CONSTANT data : IN    integer
  );
  
PROCEDURE cpu_check
  (
	SIGNAL bfm_control : INOUT bfm_control_type;
    CONSTANT addr : IN    integer;
    CONSTANT data : IN    integer
  );

end;


package body CPU_PKG is

  PROCEDURE cpu_read
  (
	SIGNAL bfm_control : INOUT bfm_control_type;
    CONSTANT addr : IN    integer;
    VARIABLE data : OUT   integer
  ) IS
  BEGIN
	check_ack(bfm_control);
    bfm_info.parameter1 := addr;
    bfm_info.op := req_cpu_read;
    do_req(bfm_control);
    check_ack(bfm_control);
    data := bfm_info.parameter2;
  END PROCEDURE cpu_read;
  
  PROCEDURE cpu_write
  (
	SIGNAL bfm_control : INOUT bfm_control_type;
    CONSTANT addr : IN    integer;
    CONSTANT data : IN    integer
  ) IS
  BEGIN
	check_ack(bfm_control);
    bfm_info.parameter1 := addr;
    bfm_info.op := req_cpu_write;
    bfm_info.parameter2 := data;
    do_req(bfm_control);
  END PROCEDURE cpu_write;
  
  PROCEDURE cpu_check
  (
	SIGNAL bfm_control : INOUT bfm_control_type;
    CONSTANT addr : IN    integer;
    CONSTANT data : IN    integer
  ) IS
  BEGIN
	check_ack(bfm_control);
    bfm_info.parameter1 := addr;
    bfm_info.op := req_cpu_read;
    do_req(bfm_control);
    check_ack(bfm_control);
    assert (data = bfm_info.parameter2)
    report "CPU CHECK FAILED"
    severity error;
  END PROCEDURE cpu_check;
  
end package body;
