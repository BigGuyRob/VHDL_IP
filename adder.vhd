----------------------------------------------------------------------------------
-- Company: Rutgers University New Brunswick 
-- Engineer: Robert Reid 
-- 
-- Create Date: 02/23/2023 07:42:54 PM
-- Design Name: adder
-- Module Name: adder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity adder is
    port(A,B,Cin : in std_logic;
         Cout,S : out std_logic);
end adder;

architecture Behavioral of adder is
begin
    s <= A xor B xor Cin;
    Cout <= ((A xor B) and Cin) or (A and B);
end Behavioral;
