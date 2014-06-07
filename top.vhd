library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

library UNISIM;
use UNISIM.VComponents.all;

entity top is
  Port ( MCLK1 : in std_logic;
         RS_TX : out std_logic;
         RS_RX : in std_logic);
end top;

architecture arch of top is
	signal clk,iclk: std_logic;
	component sub_top
		Port(	clk : in std_logic;
				tx : out std_logic;
				rx : in std_logic);
	end component;
begin
	ib: IBUFG port map (
		i=>MCLK1,
		o=>iclk);
	bg: BUFG port map (
		i=>iclk,
		o=>clk);
	main : sub_top port map (
		clk => clk,
		tx => RS_TX,
		rx => RS_RX);
end arch;
