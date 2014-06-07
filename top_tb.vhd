library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tb is
end top_tb;

architecture tb of top_tb is
  
  signal tx : std_logic;
  signal clk : std_logic;

  component sub_top is
    generic (wtime_in : std_logic_vector(15 downto 0) := x"0032";
             wtime_out : std_logic_vector(15 downto 0) := x"0032");
    port(clk : in std_logic;
         rx : in std_logic;
         tx : out std_logic);
  end component;

  signal data : std_logic_vector(31 downto 0) :=
    "1" & x"aa" & "01" & x"32" & "01" & x"94" & "011";
  
begin

  main : sub_top port map (
      clk => clk,
      rx => data(0),
      tx => tx);

  clkgen : process
  begin
    clk <= '1';
    wait for 1 ns;
    clk <= '0';
    wait for 1 ns;
  end process;
  
  input : process
  begin
    wait for 100 ns;
    data <= data(0) & data(31 downto 1);
  end process;

end tb;
