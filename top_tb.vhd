library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity news_tb is
end news_tb;

architecture example of news_tb is
  component news
  port( 
    MCLK1 : in std_logic;
    RS_TX : out std_logic;
    RS_RX : in std_logic);
  end component;

  signal MCLK1 : std_logic := '0';
  signal RS_TX : std_logic ;
  signal RS_RX : std_logic := '1';
  signal rom_t : std_logic_vector(15 downto 0) := "1111111000110001";
  signal rom_addr: std_logic_vector(3 downto 0) := (others=>'1');
  signal countdown : std_logic_vector(15 downto 0) := (others=>'0');

begin
  uut: news port map (
    MCLK1 => MCLK1,
    RS_TX => RS_TX,
    RS_RX => RS_RX);
  rom_inf: process(mclk1)
  begin
    if rising_edge(mclk1) then
      RS_RX<=rom_t(conv_integer(rom_addr));
    end if;
  end process;

  send_msg: process(mclk1)
  begin
   if rising_edge(mclk1) then
     if countdown = 0 then
	     case rom_addr is
		  when "1001" =>
    	    rom_addr <= "0000"; 
        when others =>
		    rom_addr <= rom_addr + 1;
		  end case;
          countdown <= x"1C06";
        else
          countdown <= countdown-1;
      end if;
   end if;
  end process;


  clkgen: process
  begin
    mclk1<='0';
    wait for 7 ns;
    mclk1<='1';
    wait for 7 ns;
  end process;

end example;
