----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Robert Reid 
-- 
-- Create Date: 02/26/2023 11:50:14 PM
-- Design Name:  16 function ALU with 4 bit opcode 
-- Module Name: my_alu - Behavioral
-- Project Name: 
-- Target Devices: 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu is
    port(A, B : in std_logic_vector(3 downto 0);
         clk : in std_logic;
         opcode : in std_logic_vector(3 downto 0);
         output : out std_logic_vector(3 downto 0));
end alu;

architecture Behavioral of alu is
    signal F : std_logic_vector(3 downto 0);
    signal ZERO : std_logic_vector(3 downto 0) := "0000";
begin
    arithmetic: process(clk)
    begin
        if(rising_edge(clk)) then
            case (opcode) is
                when  x"0" => -- A + B
                    F <= std_logic_vector(unsigned(A) + unsigned(B));
                when  x"1" => -- A - B 
                    F <= std_logic_vector(unsigned(A) - unsigned(B));
                when  x"2" => -- A + 1
                    F <= std_logic_vector(unsigned(A) + 1);
                when  x"3" => -- A - 1
                    F <= std_logic_vector(unsigned(A) - 1);
                when  x"4" => -- 0 - A
                    F <= std_logic_vector(unsigned(ZERO) - unsigned(A));
                when  x"5" => -- A IS GREATER THAN B
                    if(unsigned(A) > unsigned(B)) then
                        F <= "0001";
                    else
                        F <= "0000";
                    end if;
                when  x"6" => -- LEFT SHIFT LOGICAL on A
                    -- F <= A(2 downto 0) & '0';
                    -- ^ I feel I like I want to do this
                    F <=  std_logic_vector(unsigned(A) sll 1);
                when  x"7" => -- RIGHT SHIFT LOGICAL on A
                    --F <= '0' & A(3 downto 1);
                    F <= std_logic_vector(unsigned(A) srl 1);
                when  x"8" => -- RIGHT SHIFT ARITHMETIC on A
                    F <= std_logic_vector(shift_right(unsigned(A), 1)); 
                when  x"9" =>
                    --F <= NOT(A);
                    F(0) <= NOT(A(0));
                    F(1) <= NOT(A(1));
                    F(2) <= NOT(A(2));
                    F(3) <= NOT(A(3));
                when  x"a" =>
                    --F <= A AND B;
                    F(0) <= A(0) AND B(0);
                    F(1) <= A(1) AND B(1);
                    F(2) <= A(2) AND B(2);
                    F(3) <= A(3) AND B(3);
                when  x"b" =>
                    --F <= A OR B;
                    F(0) <= A(0) OR B(0);
                    F(1) <= A(1) OR B(1);
                    F(2) <= A(2) OR B(2);
                    F(3) <= A(3) OR B(3);        
                when  x"c" =>
                    --F <= A XOR B;
                    F(0) <= A(0) XOR B(0);
                    F(1) <= A(1) XOR B(1);
                    F(2) <= A(2) XOR B(2);
                    F(3) <= A(3) XOR B(3); 
                when  x"d" =>
                    --F <= A XNOR B;
                    F(0) <= A(0) XNOR B(0);
                    F(1) <= A(1) XNOR B(1);
                    F(2) <= A(2) XNOR B(2);
                    F(3) <= A(3) XNOR B(3); 
                when  x"e" =>
                    --F <= A NAND B;
                    F(0) <= A(0) NAND B(0);
                    F(1) <= A(1) NAND B(1);
                    F(2) <= A(2) NAND B(2);
                    F(3) <= A(3) NAND B(3); 
                when  x"f" =>
                    --F <= A NOR B;
                    F(0) <= A(0) NOR B(0);
                    F(1) <= A(1) NOR B(1);
                    F(2) <= A(2) NOR B(2);
                    F(3) <= A(3) NOR B(3); 
                when others =>
                    F <= x"0";
            end case;
            
            
        end if;
    end process;
    output <= F;
end Behavioral;
