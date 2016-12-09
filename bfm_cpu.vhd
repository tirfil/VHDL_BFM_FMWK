--###############################
--# Project Name : 
--# File         : 
--# Author       : Philippe THIRION
--# Description  : Bus Functional Model for CPU
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.bfm_pkg.all;

entity BFM_CPU is
	port(
		CPU_A		: out	std_logic_vector(15 downto 0);
		CPU_RDY		: in	std_logic;
		CPU_CSN		: out	std_logic;
		CPU_OEN		: out	std_logic;
		CPU_WRN		: out	std_logic;
		CPU_RDN		: out	std_logic;
		CPU_BEN		: out	std_logic_vector(1 downto 0);
		CPU_D		: inout	std_logic_vector(15 downto 0);
		CPU_INTN	: in	std_logic
	);
end BFM_CPU;

architecture bfm of BFM_CPU is

  --

  CONSTANT C_TCYCLE : time := 5 ns;
    
  -- cpu hold and setup
  CONSTANT C_WR_SETUP : integer := 1;
  CONSTANT C_WR_STROBE : integer := 5;
  CONSTANT C_WR_HOLD : integer := 1;
  CONSTANT C_WR_EXTHOLD : integer := 1;
  
  CONSTANT C_RD_SETUP : integer := 2;
  CONSTANT C_RD_STROBE : integer := 7;
  CONSTANT C_RD_HOLD : integer := 1;
  CONSTANT C_RD_EXTHOLD : integer := 2;

begin

server: PROCESS
  BEGIN
	bfm_ack <= 'Z';
  	CPU_OEN <= '1';
	CPU_CSN <= '1';
	CPU_BEN <= "11";
	CPU_A <= (others=>'0');
	CPU_D <= (others=>'Z');
	CPU_WRN <= '1';
	CPU_RDN <= '1';
    WAIT UNTIL bfm_req = '1';
    
    CASE bfm_info.op IS
      WHEN req_cpu_write =>
        bfm_ack <= '0';
        WAIT FOR 0 ns;
        --trigger the BFM process with a write command and wait until
        --it has finished
        CPU_OEN <= '1';
        CPU_CSN <= '0';
		CPU_WRN <= '1';
		CPU_RDN <= '1';
		CPU_A <= std_logic_vector(to_unsigned(bfm_info.parameter1,16));
		CPU_D <= std_logic_vector(to_unsigned(bfm_info.parameter2,16));
		CPU_BEN <= "00";
		wait for C_WR_SETUP * C_TCYCLE;
		CPU_WRN <= '0';
		wait for (C_WR_STROBE-3) * C_TCYCLE;
		while (CPU_RDY = '0') loop
			wait for C_TCYCLE;
		end loop;
		wait for 3 * C_TCYCLE;
		CPU_WRN <= '1';
		wait for C_WR_HOLD * C_TCYCLE;
		CPU_CSN <= '1'; 
		CPU_D <= (others=>'Z');
		CPU_BEN <= "11";
		wait for C_WR_EXTHOLD * C_TCYCLE;

      WHEN req_cpu_read =>
        bfm_ack <= '0';
        WAIT FOR 0 ns;
        --trigger the BFM process with a read command and wait until
        --it has finished
        CPU_D <= (others=>'Z');
        CPU_OEN <= '0';
        CPU_CSN <= '0';
		CPU_A <= std_logic_vector(to_unsigned(bfm_info.parameter1,16));
		CPU_BEN <= "00";
		CPU_RDN <= '1';
		wait for C_RD_SETUP * C_TCYCLE;
		CPU_RDN <= '0';
		wait for (C_RD_STROBE-3) * C_TCYCLE;
		while (CPU_RDY = '0') loop
			wait for C_TCYCLE;
		end loop;
		wait for 3 * C_TCYCLE;
		bfm_info.parameter2 := to_integer(unsigned(CPU_D)); -- from BFM
		CPU_RDN <= '1';
		wait for C_RD_HOLD * C_TCYCLE;
		CPU_OEN <= '1';
		CPU_CSN <= '1';
		CPU_D <= (others=>'Z');
		CPU_BEN <= "11";
		wait for C_RD_EXTHOLD * C_TCYCLE;
		
	  WHEN req_interrupt =>
		bfm_ack <= '0';
        WAIT FOR 0 ns;
		if (CPU_INTN = '1') then
			wait on CPU_INTN;
		end if;
		
      WHEN others =>
        null;
        
    END CASE;
    -- Notify client that the request has been handled and that
    -- data from the server is valid (until a new request is
    -- received).
    --
    if (bfm_req = '1') then
		WAIT UNTIL bfm_req = '0';
	end if;
    bfm_ack <= 'Z';
  END PROCESS server;

end bfm;

