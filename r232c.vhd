library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.std_logic_arith.ALL;

entity r232c is
  generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
  port (clk : in STD_LOGIC;
        rx : in STD_LOGIC;
        data : out std_logic_vector (7 downto 0);
        ready : out std_logic);
end r232c;

architecture whitebox of r232c is
  signal state : std_logic_vector (3 downto 0) := "1001";
  signal buf : std_logic_vector (7 downto 0) := (others => '0');
  signal countdown : std_logic_vector (15 downto 0) := (others => '0');
begin
  statemachine: process(clk)
  begin
    if rising_edge(clk) then
      case state is
        when "1001" =>
          if rx = '0' then
            countdown <= wtime;
            state <= "0000";
          end if;

        when "1000" =>
          if rx='1' then
            state <= state+1;
          end if;

        when others =>
          if countdown=0 then
            buf <= rx & buf(7 downto 1);
            countdown <= wtime;
            state<=state+1;
          else
            countdown <= countdown-1;
          end if;
      end case;
    end if;
  end process;
  ready <= '1' when state = "1000" else '0';
  data <= buf;
end whitebox;
