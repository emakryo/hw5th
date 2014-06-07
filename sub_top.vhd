library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sub_top is
  generic (wtime_in: std_logic_vector(15 downto 0) := x"1ADB";
           wtime_out: std_logic_vector(15 downto 0) := x"1ADB");
  port (clk : in std_logic;
        rx : in std_logic;
        tx : out std_logic);
end sub_top;

architecture archtop of sub_top is

  component u232c
    generic (wtime: std_logic_vector(15 downto 0) := wtime_out);
    port ( clk : in std_logic;
           data : in std_logic_vector(7 downto 0);
           go : in std_logic;
           busy: out  std_logic;
           tx : out std_logic);
  end component;

  component r232c is
    generic (wtime: std_logic_vector(15 downto 0) := wtime_in);
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

  input : r232c
  port map (
    clk=>clk,
    rx=>rx,
    data=>buf,
    ready=>uart_ready);
  
  output : u232c
    port map (
      clk=>clk,
      data=>buf,
      go=>uart_go,
      busy=>uart_busy,
      tx=>tx);
    
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
