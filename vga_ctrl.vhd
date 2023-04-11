----------------------------------------------------------------------------------
-- Engineer: Robert Reid
-- 
-- Create Date: 03/29/2023 04:06:34 PM
-- Design Name: VGA Controller
-- Module Name: vga_ctrl - Behavioral
-- Project Name: VGA Lab
-- Target Devices: XC7Z010CLG400-1
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

entity vga_ctrl is
    port(clk, clk_en : in std_logic;
         hcount, vcount : out std_logic_vector(9 downto 0);
         vid : out std_logic;
         hs, vs: out std_logic);
end vga_ctrl;

architecture Behavioral of vga_ctrl is
    signal hcounter, vcounter : std_logic_vector(9 downto 0) := (others => '0');
    
    signal h_video_size : integer := 640;
    signal h_fp_size : integer := 16;
    signal h_sync_size : integer := 96;
    signal h_bp_size : integer := 48;
    signal h_total : integer := 800;
    signal v_video_size : integer := 480;
    signal v_fp_size : integer := 10;
    signal v_sync_size : integer := 2;
    signal v_bp_size : integer := 33;
    signal v_total : integer := 525;
begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            if(clk_en = '1') then
                if(unsigned(hcounter) = h_total - 1) then --horizontal outer loop
                    
                    if(unsigned(vcounter) = v_total - 1) then --vertical inner loop
                        vcounter <= (others => '0');
                    else --reset for next frame
                        
                        vcounter <= std_logic_vector(unsigned(vcounter) + 1); 
                        --vcounter increments every clock tick, when clk_en = '1' and hcounter has been reset to '0'
                    end if; 
                    hcounter <= (others => '0');  
                else --reset for next loop 
                    hcounter <= std_logic_vector(unsigned(hcounter) + 1);
                end if;
                
                if(unsigned(hcounter) < h_video_size - 1) and (unsigned(vcounter) < v_video_size) then
                    vid <= '1';
                else 
                    vid <= '0';
                end if;
                
                
                if((unsigned(hcounter) >= h_video_size + h_fp_size) and (unsigned(hcounter) < h_total - h_bp_size)) then
                    hs <= '0';
                else    
                    hs <= '1';
                end if;
                
                if ((unsigned(vcounter) >= v_video_size + v_fp_size) and (unsigned(vcounter) < v_total - v_bp_size)) then
                    vs <= '0';
                else
                    vs <= '1';
                end if;
                
                hcount <= hcounter;
                vcount <= vcounter;
            end if;
        end if;
    end process;
    --set output signals
    --vid <= '1' when (unsigned(hcounter) < h_video_size) and (unsigned(vcounter) < v_video_size ) 
      --         else '0';
    --hs <= '0' when (unsigned(hcounter) >= h_video_size + h_fp_size) and (unsigned(hcounter) < h_total - h_bp_size) 
      --  else '1'; --this is a good way to calculate the length of the sync pulse based on
        -- the total, back porch, and front porch sizes
    --vs <= '0' when (unsigned(vcounter) >= v_video_size + v_fp_size) and (unsigned(vcounter) < v_total - v_bp_size) 
      --  else '1'; --this is a good way to calculate the length of the sync pulse
        --just copy and pasted my formula from the hs pulse
    --hcount <= hcounter;
    --vcount <= vcounter;
end Behavioral;