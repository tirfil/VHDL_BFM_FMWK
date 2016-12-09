--###############################
--# Project Name : 
--# File         : 
--# Author       : Philippe THIRION
--# Description  : Test bench
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.bfm_pkg.all;
use work.cpu_pkg.all;

entity tb_BFM_CPU is
end tb_BFM_CPU;

architecture stimulus of tb_BFM_CPU is


-- COMPONENTS --
		component BFM_CPU
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
		end component;

--
-- SIGNALS --
	signal CPU_A1		: std_logic_vector(15 downto 0);
	signal CPU_RDY1		: std_logic;
	signal CPU_CSN1		: std_logic;
	signal CPU_OEN1		: std_logic;
	signal CPU_WRN1		: std_logic;
	signal CPU_RDN1		: std_logic;
	signal CPU_BEN1		: std_logic_vector(1 downto 0);
	signal CPU_D1		: std_logic_vector(15 downto 0);
	signal CPU_INTN1		: std_logic;
	
	
	signal probe_req	: std_logic;
	signal probe_ack	: std_logic;

--
	signal RUNNING	: std_logic := '1';

begin

-- PORT MAP --
		I_BFM_CPU_0 : BFM_CPU
			port map (
				CPU_A		=> CPU_A1,
				CPU_RDY		=> CPU_RDY1,
				CPU_CSN		=> CPU_CSN1,
				CPU_OEN		=> CPU_OEN1,
				CPU_WRN		=> CPU_WRN1,
				CPU_RDN		=> CPU_RDN1,
				CPU_BEN		=> CPU_BEN1,
				CPU_D		=> CPU_D1,
				CPU_INTN	=> CPU_INTN1
			);
--

	
	CPU_RDY1 <= '1';
	CPU_INTN1 <= '1';
	
	
	-- 
	CPU_D1 <= (others=>'Z') when CPU_OEN1 = '1' else CPU_A1;
	
	probe_ack <= '1' when bfm_ack = 'Z' else '0';
	probe_req <= '1' when bfm_req = '1' else '0';
	
	
	GO: process
		variable data : integer;
	begin
		cpu_write(bfm_req, bfm_ack, 16#3C3C#, 16#AA55#);
		wait for 50 ns;
		--cpu_read( bfm_req, bfm_ack, 16#3C3C#, data);
		--report "cpu_read: data=" & integer'image(data);
		cpu_check(bfm_req, bfm_ack, 16#3C3C#, 16#3C3C#);
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
