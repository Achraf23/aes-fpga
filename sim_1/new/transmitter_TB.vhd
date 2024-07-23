----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/14/2024 11:49:06 AM
-- Design Name: 
-- Module Name: transmitter_TB - Behavioral
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

entity transmitter_TB is
--  Port ( );
end transmitter_TB;

architecture Behavioral of transmitter_TB is
    component transmitter is
        Port ( transmitter_clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               transmit : in STD_LOGIC;
               data : in STD_LOGIC_VECTOR (7 downto 0);
               Txd : out STD_LOGIC);
    end component;
    signal sim_rst,sim_transmit: std_logic;
    signal sim_data : std_logic_vector (7 downto 0);
    signal sim_clk : std_logic := '0';
    
begin
transmitter_TB : transmitter PORT MAP (
    transmitter_clk=> sim_clk,
    reset=> sim_rst,
    transmit => sim_transmit,
    data => sim_data
);
    sim_clk <= not sim_clk after 5ns; 
    sim_rst <= '1','0' after 20ns;
    sim_transmit <= '1';
    sim_data <= "00001111";


end Behavioral;
