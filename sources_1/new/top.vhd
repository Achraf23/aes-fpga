library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    port (
        clk : in STD_LOGIC;
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
        o_RX_Byte   : out std_logic_vector(7 downto 0)
        );
    end component;
    
    signal transmit,sim_transmit,r_receiver : STD_LOGIC;
    signal sim_rst : std_logic;
    constant c_BIT_PERIOD : time := 104166 ns;
    
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
    
    sim_transmit <= '1';
    
  end UART_WRITE_BYTE;

begin
    tr: transmitter PORT MAP(
       transmitter_clk => clk,
       reset => sim_rst,
       transmit => sim_transmit,
       data => "00111101",
       Txd => out_bit
    );
    
    rec: receiver PORT MAP(
       i_Clk => clk,
       i_RX_Serial => r_receiver,
       o_RX_DV => open,
       o_RX_Byte => open
    );
    
    UART_WRITE_BYTE(X"37", r_receiver);

    
    sim_rst <= '0';
--    sim_rst <= '1', '0' after 10ns;
    
--    process begin
--        -- wait for complete reception 
--        wait until r_receiver = '0';
--        for ii in 0 to 7 loop
--          wait for c_BIT_PERIOD;
--        end loop; 
        
--        -- only after reception, transmit data
--        sim_transmit <= '1';
--        for ii in 0 to 9 loop
--          wait for c_BIT_PERIOD;
--        end loop; 
--        sim_transmit <= '0';
        
--    end process;
    

end Behavioral;