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

  component u232c
    generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
    port ( clk : in std_logic;
           data : in std_logic_vector(7 downto 0);
           go : in std_logic;
           busy: out  std_logic;
           tx : out std_logic);
  end component;

  component r232c is
    generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
    port ( clk : in std_logic;
           rx : in std_logic;
           data : out std_logic_vector(7 downto 0);
           ready : out std_logic);
  end component;
  
  signal uart_go : std_logic;
  signal uart_busy : std_logic := '0';
  signal buf : std_logic_vector(7 downto 0) := (others => '1');
  signal uart_ready : std_logic;
begin
  ib : ibufg port map (
    i=>MCLK1,
    o=>iclk);
  
  bg : bufg port map (
    i=>iclk,
    o=>clk);
        
  input : r232c generic map (wtime=>x"1ADB")
  port map (
    clk=>clk,
    rx=>RS_RX,
    data=>buf,
    ready=>uart_ready);
  
  output : u232c generic map (wtime=>x"1ADB")
    port map (
      clk=>clk,
      data=>buf,
      go=>uart_go,
      busy=>uart_busy,
      tx=>RS_TX);
    
  send : process(clk)
  begin
    if rising_edge(clk) then
      if uart_busy='0' and uart_go='0' and uart_ready='1' then
        uart_go<='1';
      else
        uart_go<='0';
      end if;
    end if;
  end process;
  
end archtop;
