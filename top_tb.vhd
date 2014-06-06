library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tb is
end top_tb;

architecture tb of top_tb is
  
  signal rx : std_logic;
  signal tx : std_logic;
  signal clk : std_logic;

  component top is
    port(MCLK1 : in std_logic;
         RS_RX : in std_logic;
         RS_TX : out std_logic);
  end component;

  signal data : std_logic_vector(31 downto 0) :=
    "1" & x"aa" & "01" & x"32" & "01" & x"94" & "011";
  
begin

  main : top port map (
      MCLK1 => clk,
      RS_RX => data(0);
      RS_TX => tx);

  clkgen : process
  begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
  end process;

  input : process
  begin
    wait 100 ns;
    data <= data(0) & data(31 downto 1);
  end

end tb;
