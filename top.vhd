library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.ALL;

entity top is
  port (MCLK1 : in std_logic;
        RS_RX : in std_logic;
        RS_TX : out std_logic);
end top;

architecture archtop of top is
  signal clk, iclk: std_logic;

  component sub_top
    generic (wtime_in : std_logic_vector(15 downto 0) := x"1ADB");
    generic (wtime_out : std_logic_vector(15 downto 0) := x"1ADB");
    port (
      clk : in std_logic;
      rx : in std_logic;
      tx : in std_logic);
  end component;


begin
  ib : ibufg port map (
    i=>MCLK1,
    o=>iclk);
  
  bg : bufg port map (
    i=>iclk,
    o=>clk);

  main : sub_top port map (
    clk => clk,
    rx => RS_RX,
    tx=> RS_TX);
  
end archtop;
