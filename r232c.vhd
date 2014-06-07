library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity r232c is
  generic (wtime: std_logic_vector(15 downto 0) := x"1ADB");
  Port ( clk  : in  std_logic;
         data : out  std_logic_vector (7 downto 0) := (others=>'1');
         ready : out std_logic := '0';
         rx   : in std_logic);
end r232c;

architecture blackbox of r232c is
  signal countdown: std_logic_vector(15 downto 0) := (others=>'0');
  signal receivebuf: std_logic_vector(7 downto 0) := (others=>'1');
  signal state: std_logic_vector(3 downto 0) := "1001";
begin
  statemachine: process(clk)
  begin
    if rising_edge(clk) then
      case state is
        when "1001"=>
          if rx = '0' then
            state<=state-1;
            countdown<=wtime;
            receivebuf<=(others=>'1');
          end if;
		    ready<= '0';
        when others=>
          if countdown=0 then
            receivebuf<=rx&receivebuf(7 downto 1);
				countdown<=wtime;
            if state="0000" then
              state<="1001";
		        data<=receivebuf;
				  ready<= '1';
            else
              state<=state-1;
            end if;
          else
            countdown<=countdown-1;
          end if;
      end case;
    end if;
 end process;
end blackbox;
