----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Robert Reid
-- 
-- Create Date: 03/29/2023 06:53:13 PM
-- Design Name: VGA Port to serve an image
-- Module Name: image_top - Behavioral
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


entity image_top is
    port(clk : in std_logic;
         vga_hs, vga_vs : out std_logic;
         vga_r, vga_b : out std_logic_vector(4 downto 0);
         vga_g : out std_logic_vector(5 downto 0));
end image_top;

architecture Behavioral of image_top is
    component picture 
    PORT (
        clka : IN STD_LOGIC;
        addra : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
        douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END component;
    component pixel_pusher is
    port(clk, clk_en : in std_logic;
         vs : in std_logic;
         pixel : in std_logic_vector(7 downto 0);
         hcount : in std_logic_vector(9 downto 0);
         vid : in std_logic;
         R, B : out std_logic_vector(4 downto 0); --r and b are 5 bits
         G : out std_logic_vector(5 downto 0); --g is 6 bits. It totals 16
         addr : out std_logic_vector(17 downto 0));
    end component;
    component vga_ctrl is
    port(clk, clk_en : in std_logic;
         hcount, vcount : out std_logic_vector(9 downto 0);
         vid : out std_logic;
         hs, vs: out std_logic);
    end component;
    component clock_divider is
    generic(
        clock_frequency : INTEGER;
        division_integer : INTEGER);
    port(
        clk  : in std_logic;        
        div : out std_logic);     
    end component;
    signal addr : std_logic_vector(17 downto 0) := (others => '0'); --address is 18 bits
    signal pixel : std_logic_vector(7 downto 0); --pixel is 8 bits
    signal div : std_logic; --output from clock_divider at 25MHz
    signal vid : std_logic;
    signal hcount : std_logic_vector(9 downto 0); --hcount is an output from vga_ctrl used as input to pixel pusher
    signal vcount : std_logic_vector(9 downto 0); --vcount is an output from vga_ctrl but never used except for debugging
    signal vga_vs_out : std_logic;
begin

    vga_port_controller:vga_ctrl
    port map(clk => clk,
             clk_en => div,
             hcount => hcount,
             vcount => vcount, 
             vid => vid,
             hs => vga_hs,
             vs => vga_vs_out);
             
    pic: picture
    port map(clka => clk,            
             addra => addr, --address is the address coming from the pixel pusher
             douta => pixel);
    
    display_controller: pixel_pusher
    port map(clk => clk,
             clk_en => div,
             vs => vga_vs_out, 
             pixel => pixel,
             hcount => hcount,
             vid => vid,
             R => vga_r,
             B => vga_b,
             G => vga_g,
             addr => addr);
    
    clk_div: clock_divider
    generic map(clock_frequency => 125000000, division_integer => 25000000) --25MHz out
    port map(clk => clk,
             div => div);
     vga_vs <= vga_vs_out;

end Behavioral;