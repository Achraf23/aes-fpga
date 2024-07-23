library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity top is
    port (
        clk : in STD_LOGIC;
        in_bit : in std_logic;
        out_bit : out STD_LOGIC;
        data_out : out STD_LOGIC_VECTOR (7 downto 0)
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
    
    -- Enumerated type declaration and state signal declaration
    type t_State is (idle, send);
    signal State : t_State := idle;
    
    signal sim_transmit,r_receiver : STD_LOGIC;
    signal end_receive : std_logic;
    signal transport_data, sim_o_rx_byte :  std_logic_vector(7 downto 0);
    constant max_cnt : integer := 104200000;
    signal cnt_transmit: unsigned (26 downto 0) := (others => '0');
    signal sim_rst : std_logic;
    
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
       o_RX_DV => end_receive, -- read only
       o_RX_Byte => sim_o_rx_byte
    );
        
    process (clk) begin
        if rising_edge(clk) then
            if State = send then
                if cnt_transmit = max_cnt then
                    State <= idle;
                    sim_transmit <= '0';
                    data_out <= x"00";
                    cnt_transmit <= (others => '0');
                else
                    cnt_transmit <= cnt_transmit + 1;
                end if;
            else
                if end_receive = '1' then
                    data_out <= sim_o_rx_byte;
                    transport_data <= sim_o_rx_byte;
                    sim_transmit <= '1';
                    State <= send;
                end if;
            end if;
        end if;
    end process;
    
    sim_rst <= '0';
    
end Behavioral;