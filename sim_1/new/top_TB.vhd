----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/14/2024 11:06:45 PM
-- Design Name: 
-- Module Name: top_TB - Behavioral
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

entity top_TB is
--  Port ( );
end top_TB;

architecture Behavioral of top_TB is
    component top is
        port (
            clk : in STD_LOGIC;
            in_bit : in std_logic;
            out_bit : out STD_LOGIC;
            data_out : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
   
    signal sim_clk : std_logic := '0';
    signal sim_in_bit, sim_rst : std_logic;
    constant c_BIT_PERIOD : time := 104160 ns;
    
    -- WRITE BYTE to the receiver
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
    top_TB : top PORT MAP (
    clk=> sim_clk,
    in_bit => sim_in_bit,
    out_bit => open
    );
    
    sim_clk <= not sim_clk after 5ns; 
    process begin
        --wait for 100 ms;
        UART_WRITE_BYTE(x"61",sim_in_bit);
        wait for 5 ms;
        UART_WRITE_BYTE(x"11",sim_in_bit);
        --wait for 3 sec;
    end process;


end Behavioral;
