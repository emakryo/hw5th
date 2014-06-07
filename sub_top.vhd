library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity sub_top is
  Port ( clk : in std_logic;
         tx : out std_logic;
         rx : in std_logic);
end sub_top;

architecture arch of sub_top is
  component u232c
    generic (wtime: std_logic_vector(15 downto 0));
    Port ( clk  : in  std_logic;
           data : in  std_logic_vector (7 downto 0);
           go   : in  std_logic;
           busy : out std_logic;
           tx   : out std_logic);
  end component;
  component r232c
    generic (wtime: std_logic_vector(15 downto 0));
    Port ( clk  : in  std_logic;
           data : out  std_logic_vector (7 downto 0);
           ready : out std_logic;
           rx   : in std_logic);
  end component;
  signal uart_go: std_logic := '0';
  signal uart_busy: std_logic := '0';
  signal uart_ready: std_logic := '0';
  signal complete: std_logic := '0';
  signal send_data: std_logic_vector (7 downto 0);
  signal receive_data: std_logic_vector (7 downto 0);
begin
  sender: u232c generic map (wtime=>x"1C06")
  port map (
    clk=>clk,
    data=>send_data,
    go=>uart_go,
    busy=>uart_busy,
    tx=>tx);
  receiver: r232c generic map (wtime=>x"1C06")
  port map (
    clk=>clk,
    data=>receive_data,
    ready=>uart_ready,
    rx=>rx);
  controll: process(clk)
  begin
    if rising_edge(clk) then
	   if uart_ready='1' then
		  complete<='1';
		  send_data<=receive_data;
		end if;
      if uart_busy='0' and uart_go='0' and complete='1' then
        uart_go<='1';
		  complete<='0';
      else
        uart_go<='0';
      end if;
    end if;
  end process;
end arch;
