library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port (
        clk : in STD_LOGIC;
        in_bit : in std_logic;
        out_bit : out STD_LOGIC
    );
end top;

architecture Behavioral of top is
    component transmitter is
        Port ( transmitter_clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               transmit : in STD_LOGIC;
               data : in STD_LOGIC_VECTOR (7 downto 0);
               Txd : out STD_LOGIC);
    end component;
    component receiver is
      port (
        i_Clk       : in  std_logic;
        i_RX_Serial : in  std_logic;
        o_RX_DV     : out std_logic;
        o_RX_Byte   : out std_logic_vector(7 downto 0);
        receiving : out std_logic
        );
    end component;
    
    signal sim_transmit,r_receiver : STD_LOGIC;
    signal sim_rst,end_receive : std_logic;
    signal transport_data, sim_o_rx_byte :  std_logic_vector(7 downto 0);
    constant c_BIT_PERIOD : time := 104166 ns;
    signal test_bit : std_logic;
    
begin
    tr: transmitter PORT MAP(
       transmitter_clk => clk,
       reset => sim_rst,
       transmit => sim_transmit,
       data => transport_data,
       Txd => out_bit
    );
    
    rec: receiver PORT MAP(
       i_Clk => clk,
       i_RX_Serial => in_bit,
       o_RX_DV => end_receive,
       o_RX_Byte => sim_o_rx_byte
    );
    
    process begin
        wait until rising_edge(clk) and end_receive = '1';
        -- we have finished receiving a whole byte
        -- now we send it
        transport_data <= sim_o_rx_byte;
        sim_transmit <= '1';
        wait for 10 * c_BIT_PERIOD;
        
        -- stop transmitting
        sim_transmit <= '0';
        
    end process;
    
    sim_rst <= '0';
    
end Behavioral;