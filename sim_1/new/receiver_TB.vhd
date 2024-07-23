----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/14/2024 12:44:20 PM
-- Design Name: 
-- Module Name: receiver_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity receiver_TB is
--  Port ( );
end receiver_TB;

architecture Behavioral of receiver_TB is
    component receiver is
      port (
        i_Clk       : in  std_logic;
        i_RX_Serial : in  std_logic;
        o_RX_DV     : out std_logic;
        o_RX_Byte   : out std_logic_vector(7 downto 0)
        );
    end component;
    signal sim_clk :std_logic := '0';
    signal sim_rx : std_logic := '1';
    signal w_RX_Byte   : std_logic_vector(7 downto 0);

    -- 1/9600:
    constant c_BIT_PERIOD : time := 104160 ns;
    
    -- Low-level byte-write
  procedure UART_WRITE_BYTE (
    i_Data_In       : in  std_logic_vector(7 downto 0);
    signal o_Serial : out std_logic) is
  begin

    -- Send Start Bit
    o_Serial <= '0';
    wait for c_BIT_PERIOD;

    -- Send Data Byte
    for ii in 0 to 7 loop
      o_Serial <= i_Data_In(ii);
      wait for c_BIT_PERIOD;
    end loop;  -- ii

    -- Send Stop Bit
    o_Serial <= '1';
    wait for c_BIT_PERIOD;
  end UART_WRITE_BYTE;
    
begin
    receiver_TB : receiver PORT MAP (
    i_Clk=> sim_clk,
    i_RX_Serial => sim_rx,
    o_RX_DV     => open,
    o_RX_Byte   => w_RX_Byte
);
    sim_clk <= not sim_clk after 5ns; 
    
     process
  begin
    -- Send a command to the UART
    wait until rising_edge(sim_clk);
        UART_WRITE_BYTE(X"37", sim_rx);
    wait until rising_edge(sim_clk);

    -- Check that the correct command was received
    if w_RX_Byte = X"37" then
      report "Test Passed - Correct Byte Received" severity note;
    else 
      report "Test Failed - Incorrect Byte Received" severity note;
    end if;
    
    wait for 3 sec;

--    assert false report "Tests Complete" severity failure;
    
  end process;
  

end Behavioral;
