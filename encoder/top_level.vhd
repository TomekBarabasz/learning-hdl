library IEEE;
use IEEE.std_logic_1164.all;

entity top_level is
    port(
             clk : in std_logic;
        reset_sw : in std_logic;
         mode_sw : in std_logic;
     enc_a,enc_b : in std_logic;
       disp_sel  : out std_logic_vector(2 downto 0);
         display : out std_logic_vector(6 downto 0)
    );
end top_level;

architecture top of top_level is
    component seven_seg is
        port(
              digit : in unsigned(3 downto 0);
            display : out std_logic_vector(6 downto 0)
        );
    end component;
    component encoder_counter is
        port(
            rst : in std_logic;
            enc_a,enc_b : in std_logic;
            count : out unsigned(3 downto 0);
            enc_a_out,enc_b_out : out std_logic
        );
    end component;
    component encoder_impulse_measure is
        port(
            enc_a : in std_logic;
            count : out unsigned(11 downto 0);
        );
    end component;
    component display is
        port(
            clk : in  std_logic;
            digit1 : in  std_logic_vector(3 downto 0);
            digit2 : in  std_logic_vector(3 downto 0);
            digit3 : in  std_logic_vector(3 downto 0);
        disp_digit : out std_logic_vector(3 downto 0);
        disp_sel : out std_logic_vector(2 downto 0)
        );
    end component;

    signal digit_ec1 : std_logic_vector(3 downto 0);
    signal digit_ec2 : std_logic_vector(3 downto 0);
    signal digit_ec3 : std_logic_vector(3 downto 0);
    signal digit_im1 : std_logic_vector(3 downto 0);
    signal digit_im2 : std_logic_vector(3 downto 0);
    signal digit_im3 : std_logic_vector(3 downto 0);
    signal digit1    : std_logic_vector(3 downto 0);
    signal digit2    : std_logic_vector(3 downto 0);
    signal digit3    : std_logic_vector(3 downto 0);
    signal disp_digit : std_logic_vector(3 downto 0);
    signal enc_a_out_1 : std_logic;
    signal enc_a_out_2 : std_logic;
    signal enc_a_out_3 : std_logic;
    signal enc_b_out_1 : std_logic;
    signal enc_b_out_2 : std_logic;
    signal enc_b_out_3 : std_logic;
    signal        mode : std_logic = '0'
begin
    c1 : encoder_counter port map(
        rst => reset_sw,
        enc_a => enc_a,
        enc_b => enc_b,
        count => digit_ec1,
        enc_a_out => enc_a_out_1,
        enc_b_out => enc_b_out_1
    );
    c2 : encoder_counter port map(
        rst => reset_sw,
        enc_a => enc_a_out_1,
        enc_b => enc_b_out_1,
        count => digit_ec2,
        enc_a_out => enc_a_out_2,
        enc_b_out => enc_b_out_2
    );
    c3 : encoder_counter port map(
        rst => reset_sw,
        enc_a => enc_a_out_2,
        enc_b => enc_b_out_2,
        count => digit_ec3,
        enc_a_out => enc_a_out_3,
        enc_b_out => enc_b_out_3
    );
    d : display port map(
        clk => clk,
        digit1 => digit1,
        digit2 => digit2,
        digit2 => digit2,
        disp_digit => disp_digit,
        disp_sel => disp_sel
    );
    s : seven_seg port map(
        digit => disp_digit,
        display => display
    );
    im : encoder_impulse_measure port map(
        enc_a => enc_a,
        count => digit_im3 & digit_im2 & digit_im1
    );

    process(mode_sw)
    begin
        if raising_edge(mode_sw) then
            mode <= ~mode;
        end if;
    end process;

    digit1 <= digit_ec1 when mode='0' else digit_im1;
    digit2 <= digit_ec2 when mode='0' else digit_im2;
    digit3 <= digit_ec3 when mode='0' else digit_im3;
end top;