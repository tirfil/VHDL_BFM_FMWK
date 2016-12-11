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
  
  TYPE control_utype IS 
  (
	ctrl_idle,
	ctrl_request,
	ctrl_busy,
	ctrl_error
  );
  
  type control_array_utype is array(natural range <>) of control_utype;
  
  FUNCTION resolve_control(
	contribution : control_array_utype
  ) RETURN control_utype;
  
  SUBTYPE bfm_control_type IS resolve_control control_utype;
  
  PROCEDURE do_req(
	SIGNAL bfm_control : INOUT bfm_control_type 
  );
  
    PROCEDURE check_ack(
	SIGNAL bfm_control : IN bfm_control_type 
  );
  
  shared variable bfm_info : info_type;
  
	signal bfm_control : bfm_control_type;

end;


package body BFM_PKG is

  TYPE TABLE IS ARRAY(control_utype,control_utype) of control_utype;
  
  CONSTANT RESOLUTION_TABLE : TABLE :=
	-- ctrl_idle	, ctrl_request	, ctrl_busy	 , ctrl_error	
	-- ------------------------------------------------------
	(( ctrl_idle	, ctrl_request	, ctrl_busy	 , ctrl_error	),  -- ctrl_idle
	 ( ctrl_request	, ctrl_error	, ctrl_busy	 , ctrl_error	),	-- ctrl_request
	 ( ctrl_busy	, ctrl_busy		, ctrl_busy	 , ctrl_error	),  -- ctrl_busy
	 ( ctrl_error	, ctrl_error	, ctrl_error , ctrl_error	)); -- ctrl_error

  FUNCTION resolve_control(
	contribution : control_array_utype
  ) RETURN control_utype IS
	variable result : control_utype := ctrl_idle;
  BEGIN
	for index in contribution'range loop
		result := RESOLUTION_TABLE(result, contribution(index));
	end loop;
	return result;
  END FUNCTION resolve_control;
  
  PROCEDURE check_ack(
	SIGNAL bfm_control : IN bfm_control_type 
  ) is 
  BEGIN
	if(bfm_control /= ctrl_idle) then
		wait until bfm_control = ctrl_idle;
	end if;
  END PROCEDURE check_ack;

  PROCEDURE do_req(
	SIGNAL bfm_control : INOUT bfm_control_type 
  ) IS
  BEGIN
	bfm_control <= ctrl_request;
	wait until bfm_control = ctrl_busy;
	wait for 0 ns;
	bfm_control <= ctrl_idle;
  END PROCEDURE do_req;

end package body;
