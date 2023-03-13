----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Robert Reid 
-- 
-- Create Date: 02/23/2023 07:50:14 PM
-- Design Name:  4 bit ripple carry adder
-- Module Name: ripple_adder - Behavioral
-- Project Name: 
-- Target Devices: 



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;


entity ripple_adder is
    port(A, B : in std_logic_vector(3 downto 0); --two 4 bit input signals
         C0 : in std_logic;
         C4 : out std_logic; --bit carry out
         S : out std_logic_vector(3 downto 0)); --sum
end ripple_adder;

architecture Behavioral of ripple_adder is
    component adder is
    port(A,B,Cin : in std_logic;
         Cout,S : out std_logic);
    end component;
    signal C1, C2, C3 : std_logic;
begin
    U0: adder
    port map(A => A(0),
             B => B(0),
             Cin => C0,
             Cout => C1,
             S => S(0)
    );
    
    U1: adder
    port map(A => A(1),
             B => B(1),
             Cin => C1,
             Cout => C2,
             S => S(1)
    );
    
    U2: adder
    port map(A => A(2),
             B => B(2),
             Cin => C2,
             Cout => C3,
             S => S(2)
    );
    
    U3: adder
    port map(A => A(3),
             B => B(3),
             Cin => C3,
             Cout => C4,
             S => S(3)
    );

end Behavioral;
