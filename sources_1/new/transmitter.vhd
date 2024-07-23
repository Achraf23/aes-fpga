----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2024 09:45:29 PM
-- Design Name: 
-- Module Name: transmitter - Behavioral
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter is
    Port ( transmitter_clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           transmit : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (7 downto 0);
           Txd : out STD_LOGIC);
end transmitter;

architecture Behavioral of transmitter is
    signal bitcounter:std_logic_vector(3 downto 0);
    signal counter:std_logic_vector(13 downto 0) := (others => '0');
    signal state,nextstate : std_logic;
    signal rightshiftreg : std_logic_vector(9 downto 0);
    signal shift,load,clear:std_logic;

begin
    -- UART transmission logic
    process(transmitter_clk)
    begin
        if rising_edge(transmitter_clk) then
            if reset = '1' then -- reset is asserted (reset = 1)
                state <= '0'; -- state is idle (state = 0)
                counter <= (others => '0'); -- counter for baud rate is reset to 0 
                bitcounter <= "0000"; -- counter for bit transmission is reset to 0
            else
                counter <= std_logic_vector(to_unsigned(to_integer(unsigned(counter)) + 1, 14)); -- counter for baud rate generator start counting
                if to_integer(unsigned(counter)) >= 10415 then -- if count to 10416 (from 0 to 10415)
                    state <= nextstate; -- previous state change to next state
                    counter <= (others => '0'); -- reset counter to 0
                    if load = '1' then
                        rightshiftreg <= '1' & data & '0'; -- load the data if load is asserted
                    end if;
                    if clear = '1' then
                        bitcounter <= "0000"; -- reset the bitcounter if clear is asserted
                    end if;
                    if shift = '1' then -- if shift is asserted
                        rightshiftreg <= '0' & rightshiftreg(9 downto 1) ; -- right shift the data as we transmit the data from lsb
                        bitcounter <= std_logic_vector(to_unsigned(to_integer(unsigned(bitcounter)) + 1, 4)); -- count the bitcounter
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    -- state machine
    process(transmitter_clk)
    begin
        if rising_edge(transmitter_clk) then
            load <= '0'; -- set load equal to 0 at the beginning
            shift <= '0'; -- set shift equal to 0 at the beginning
            clear <= '0'; -- set clear equal to 0 at the beginning
            Txd <= '1'; -- set TxD equals to during no transmission
            case state is
                when '0' => -- idle state
                    if transmit = '1' then -- assert transmit input
                        nextstate <= '1'; -- Move to transmit state
                        load <= '1'; -- set load to 1 to prepare to load the data
                        shift <= '0'; -- set shift to 0 so no shift ready yet
                        clear <= '0'; -- set clear to 0 to avoid clear any counter
                    else -- if transmit not asserted
                        nextstate <= '0'; -- next state is back to idle state
                        Txd <= '1';
                    end if;
                when '1' => -- transmit state
                    if bitcounter >= "1001" then -- check if transmission is complete or not. If complete
                        nextstate <= '0'; -- set nextstate back to 0 to idle state
                        clear <= '1'; -- set clear to 1 to clear all counters
                    else -- if transmission is not complete 
                        nextstate <= '1'; -- set nextstate to 1 to stay in transmit state
                        Txd <= rightshiftreg(0); -- shift the bit to output TxD
                        shift <= '1'; -- set shift to 1 to continue shifting the data
                    end if;
                when others =>
                    nextstate <= '0';
            end case;
        end if;
    end process;

end Behavioral;