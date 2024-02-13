library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

use std.textio.ALL;
use ieee.std_logic_textio.ALL;
use work.sim_mem_init.ALL;

entity Barrel_TB is
end Barrel_TB;

architecture behavior of Barrel_TB is
  signal A : std_logic_vector(7 downto 0);
  signal I : std_logic_vector(7 downto 0);  -- Changed from "i" to "I"
  signal S : std_logic_vector(1 downto 0);
  signal shift : integer range 0 to 7;
  signal reset, clk : std_logic;
  constant bit_depth : integer := 8;
  signal expected : std_logic_vector(7 downto 0);

  -- Specify input and output file names
  constant in_fname: string := "barrel_input.csv";
  constant out_fname: string := "barrel_output.csv";

  -- Define input and output files
  file input_file: text;
  file output_file: text;

begin
  -- Initialize inputs
  reset <= '1';
  clk <= '0';
  A <= (others => '0');  -- Initialize A with a default value

  -- Create a testbench process
  process
    variable input_line: line;
    variable input_char: character;
    variable output_line: line;
    variable output_char: character;
    variable in_slv : std_logic_vector(bit_depth - 1 downto 0);
    variable out_slv : std_logic_vector(bit_depth - 1 downto 0);
  begin
    -- Open input and output files
    file_open(input_file, in_fname, read_mode);
    file_open(output_file, out_fname, write_mode);

    while not(endfile(input_file)) loop
        -- Read a line from input
        readline(input_file, input_line);

        -- Read the first 8 characters from the line
        for index in 1 to 8 loop  -- Changed "i" to "index"
            -- Read a character from the line
            read(input_line, input_char);
            in_slv := std_logic_vector(to_unsigned(character'pos(input_char), 8));

            -- Convert character to std_logic_vector
            if index = 3 then
                I(7 downto 4) <= in_slv(7 downto 4);
            elsif index = 4 then
                I(3 downto 0) <= in_slv(3 downto 0);
            elsif index = 6 then
                S <= in_slv(1 downto 0);
            elsif index = 8 then
                shift <= to_integer(unsigned(ASCII_to_hex(in_slv)));
            end if;
        end loop;

        -- Rest of the process...

        -- Compare the actual output with the expected output
        if expected /= A then
            report "FAILURE! Test Case 1 Failed" severity failure;
        else
            report "SUCCESS! Test Case 1 Passed" severity note;
        end if;
    end loop;

    -- Close input and output files
    file_close(input_file);
    file_close(output_file);
    wait;
  end process;

  -- Instantiate the Barrel component here (modify the instance name as needed)
  Barrel_inst : entity work.Barrel
    generic map (
      bit_depth
    )
    port map (
      A,
      I,
      S,
      shift,
      reset,
      clk
    );
end behavior;
