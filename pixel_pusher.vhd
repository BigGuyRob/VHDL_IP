----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Robert Reid
-- 
-- Create Date: 03/29/2023 06:19:10 PM
-- Design Name: VGA Display Controller for COE 
-- Module Name: pixel_pusher - Behavioral
-- Project Name: VGA
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
use IEEE.NUMERIC_STD.ALL;
--pixel pusher (request next pixel by addr, and decode input pixel into R G and B)
entity pixel_pusher is
    port(clk, clk_en : in std_logic;
         vs : in std_logic;
         pixel : in std_logic_vector(7 downto 0);
         hcount : in std_logic_vector(9 downto 0);
         vid : in std_logic;
         R, B : out std_logic_vector(4 downto 0); --r and b are 5 bits
         G : out std_logic_vector(5 downto 0); --g is 6 bits. It totals 16
         addr : out std_logic_vector(17 downto 0));
end pixel_pusher;

architecture Behavioral of pixel_pusher is
    signal addr_out : std_logic_vector(17 downto 0) := (others => '0');
begin
    --increments every clock tick when enable is 1, vid is 1, hcount is less than 480
    --This is due to the size of the picture
    --it resets synchronously when VS is 0.
    process(clk)
    begin
        if(rising_edge(clk)) then
            if(vs = '0') then
                addr_out <= (others => '0');
            end if;
            if(clk_en = '1') then
                if (vid = '1' and unsigned(hcount) < 480) then
                --this is so the response to adding to the address is the same as the image width
                --MATLAB made our image 480 by 480 so we shouldn't add to the address 
                --when display is off screen
                    addr_out <= std_logic_vector(unsigned(addr_out) + 1);
                    R <= pixel(7 downto 5) & "00"; -- since pixel is 8 bits, the first 3 are red
                    --and because this pixel needs to be 5 bits we pad with two 0s
                    --this should only amplify the intensity
                    G <= pixel(4 downto 2) & "000"; --here we see another 3 bits go to G 
                    --and because this pixel needs to be 6 bits we pad with three 0s
                    B <= pixel(1 downto 0) & "000"; --again 2 bits to blue and then pad with 3 0s
                else
                    R <= (others => '0');
                    G <= (others => '0');
                    B <= (others => '0');
                end if;
            else
                R <= (others => '0');
                G <= (others => '0');
                B <= (others => '0');
            end if;
            addr <= addr_out;
        end if;
    end process;
    --addr <= addr_out;
end Behavioral;