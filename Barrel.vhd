library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Barrel is
  generic (
    bit_depth : integer := 8
  );
  Port (
    A     : out std_logic_vector(bit_depth - 1 downto 0);
    I     : in std_logic_vector(bit_depth - 1 downto 0);
    S     : in std_logic_vector(1 downto 0);
    shift : in integer range 0 to bit_depth - 1;
    reset : in std_logic;
    clk   : in std_logic
  );
end Barrel;

architecture behavior of Barrel is
begin
  process (clk, reset)
    variable shifted_data : std_logic_vector(bit_depth - 1 downto 0);
    variable temp : std_logic_vector(bit_depth - 1 downto 0);
  begin
    if reset = '1' then
      -- Reset the output when the reset signal is asserted
      A <= (others => '0');
    elsif rising_edge(clk) then
      -- Shifting logic based on S and shift input
      if S = "00" then
        -- No shift, the output is the same as the input
        A <= I;
      elsif S = "01" then
        -- Right shift
        temp := (others => '0');
        temp(bit_depth - 1 downto shift) := I(bit_depth - 1 downto shift);
        shifted_data := temp;
        A <= shifted_data;
      elsif S = "10" then
        -- Left shift
        temp := (others => '0');
        temp(bit_depth - shift - 1 downto 0) := I(bit_depth - shift - 1 downto 0);
        shifted_data := temp;
        A <= shifted_data;
      else
        -- Invalid operation, reset output
        A <= (others => '0');
      end if;
    end if;
  end process;
end behavior;
