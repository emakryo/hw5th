library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity r232c_tb is
end r232c_tb;

architecture testbench of r232c_tb is
  component r232c
    generic (wtime : std_logic_vector(15 downto 0) := x"0010");
    port (clk : in std_logic;
          rx : in std_logic;
          data : out std_logic_vector(7 downto 0);
          ok : out std_logic);
    end component;

  signal sysclk : std_logic;
  signal it : std_logic_vector(3 downto 0) := (others => '0');
  signal rom_sin : std_logic_vector(9 downto 0) := '1' & x"12" & '0';
  signal sin : std_logic;
  signal sout : std_logic_vector(7 downto 0);
  signal sok : std_logic;
begin

  r232c_1 : r232c port map (
    clk=>sysclk,
    rx=>sin,
    data=>sout,
    ok=>sok);

  input : process
  begin
    wait for  80 ns;
    sin<=rom_sin(conv_integer(it));
    
    if it="1001" then
      it<="0000";
    else
      it<=it+1;
    end if;
  end process;

    
  clkgen: process
  begin
    sysclk<='0';
    wait for 5 ns;
    sysclk<='1';
    wait for 5 ns;
  end process;

end testbench;
