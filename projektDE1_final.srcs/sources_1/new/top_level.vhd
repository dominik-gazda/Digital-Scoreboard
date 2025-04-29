----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 03:07:34 PM
-- Design Name: 
-- Module Name: top_level - Behavioral
-- Project Name: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
    Port (
        CLK100MHZ   : in  std_logic;
        BTNU        : in  std_logic;
        BTND        : in  std_logic;
        BTNL        : in  std_logic;
        BTNR        : in  std_logic;
        SW          : in  std_logic;

        CA       : out  std_logic;
        CB       : out  std_logic;
        CC       : out  std_logic;
        CD       : out  std_logic;
        CE       : out  std_logic;
        CF       : out  std_logic;
        CG       : out  std_logic;
        DP       : out  std_logic;
        AN       : out std_logic_vector(7 downto 0);

        LED17_R : out std_logic
    );
end top_level;

architecture Behavioral of top_level is

    component debouncer
        Port ( inp : in STD_LOGIC;
               clk : in STD_LOGIC;
               outp : out STD_LOGIC;
               rst : in STD_LOGIC);
    end component;

    component clock_enable
        generic (
            N_PERIODS : integer := 100_000_000  -- 1 sekunda @ 100 MHz
        );
        Port (
            clk   : in  STD_LOGIC;
            rst   : in  STD_LOGIC;
            pulse : out STD_LOGIC
        );
    end component;

    component SyncLogic
        Port (
            CLK       : in  std_logic;
            BTN       : in  std_logic;
            SW        : in  std_logic;
            BTN_SYNC  : out std_logic;
            BTN_PREV  : out std_logic;
            SW_SYNC   : out std_logic
        );
    end component;

    component CounterLogic is
        Port (
            CLK       : in  std_logic;
            RST       : in  std_logic;
            BTN_SYNC  : in  std_logic;
            BTN_PREV  : in  std_logic;
            SW_SYNC   : in  std_logic;
            CNT1_OUT  : out std_logic_vector(3 downto 0);
            CNT2_OUT  : out std_logic_vector(3 downto 0)
        );
    end component;

    component bin2seg is
        Port ( 
            clear : in STD_LOGIC;
            bin : in STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
    
    component i8to1Multiplex is
        Port ( counter0 : in STD_LOGIC_VECTOR (3 downto 0);
               counter1 : in STD_LOGIC_VECTOR (3 downto 0);
               counter2 : in STD_LOGIC_VECTOR (3 downto 0);
               counter3 : in STD_LOGIC_VECTOR (3 downto 0);
               counter4 : in STD_LOGIC_VECTOR (3 downto 0);
               counter5 : in STD_LOGIC_VECTOR (3 downto 0);
               counter6 : in STD_LOGIC_VECTOR (3 downto 0);
               counter7 : in STD_LOGIC_VECTOR (3 downto 0);
               switch : in STD_LOGIC_VECTOR (2 downto 0);
               output : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    component counter_sec_des is
        generic (
            N_BITS : integer := 4
        );
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            en     : in  STD_LOGIC;
            count  : out STD_LOGIC_VECTOR (N_BITS-1 downto 0);
            carry  : out STD_LOGIC
        );
    end component;

    component counter is
        generic (
            N_BITS : integer := 4
        );
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            en     : in  STD_LOGIC;
            count  : out STD_LOGIC_VECTOR (N_BITS-1 downto 0);
            carry  : out STD_LOGIC
        );
    end component;

    component enable_logic is
        Port (
            clk        : in  STD_LOGIC;
            rst        : in  STD_LOGIC;
            pulse      : in  STD_LOGIC;
            pause      : in  STD_LOGIC;
            carry3     : in  STD_LOGIC;

            enable_out : out STD_LOGIC;
            auto_pause : out STD_LOGIC
        );
    end component;

    component pause_toggle is
        Port (
            clk       : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            btn_pause : in  STD_LOGIC;
            pause_out : out STD_LOGIC
    );
    end component;

    component stateMachine is
        Port ( 
                en : in STD_LOGIC;
                rst : in STD_LOGIC;
                clk : in STD_LOGIC;
                stateM : out STD_LOGIC_VECTOR (2 downto 0);
                stateA : out STD_LOGIC_VECTOR (7 downto 0);
                stateDP : out STD_LOGIC 
            );
    end component;
    
    component toggler is
        Port ( 
               outp : out STD_LOGIC;
               pause : in STD_LOGIC;
            
               rst : in STD_LOGIC;
               clk_500 : in STD_LOGIC;
            
               clk : in STD_LOGIC);
    end component;
    -- deklaracie signalov

        -- signal pre vstup do bin2seg
        signal sig_b2s : std_logic_vector(3 downto 0);

        -- signal pre vstup do multiplexora o strany SM
        signal sig_smM : std_logic_vector(2 downto 0);
        -- signal pre vstup do multiplexora o strany pocitadiel
        signal sig_counter0 : std_logic_vector(3 downto 0);
        signal sig_counter1 : std_logic_vector(3 downto 0);
        signal sig_counter2 : std_logic_vector(3 downto 0);
        signal sig_counter3 : std_logic_vector(3 downto 0);
        signal sig_counter4 : std_logic_vector(3 downto 0);
        signal sig_counter5 : std_logic_vector(3 downto 0);
        signal sig_counter6 : std_logic_vector(3 downto 0);
        signal sig_counter7 : std_logic_vector(3 downto 0);

        -- signal pre vstup do SM
        signal sig_en_SM : std_logic;
    -- deklaracia signalov DOMINIK
        
        signal sig_en_enable : std_logic;
        signal sig_en1, sig_en2, sig_en3 : std_logic;
        signal sig_autopause : std_logic;
        signal sig_en_timers_final : std_logic;

        signal sig_timer_carry0, sig_timer_carry1, sig_timer_carry2, sig_timer_carry3 : std_logic;

    -- deklaracia signalov DANO TOMAS
        signal sig_BTN_PREV_0 : std_logic;
        signal sig_BTN_PREV_1 : std_logic;

        signal sig_BTN_SYNC_0 : std_logic;
        signal sig_BTN_SYNC_1 : std_logic;

        signal sig_SW_SYNC_0 : std_logic;
        signal sig_SW_SYNC_1 : std_logic;

        signal sigBTNU, sigBTND, sigBTNL, sigBTNR : std_logic;
        signal sigPauseOut : std_logic;

        signal sigToggler : std_logic;
        signal sigenToggle : std_logic;

        signal b2sRst : std_logic;
        signal sigBTNRf, sigBTNlf : std_logic;
begin

    -- instancie komponentov MARTIN
    -- cast ktora ovlada vystup

    
        BNTU_DEBOUNCE : debouncer
            port map (
                inp => BTNU,
                clk => CLK100MHZ,
                outp => sigBTNU,
                rst => sigBTND
            );
        BTND_DEBOUNCE : debouncer
            port map (
                inp => BTND,
                clk => CLK100MHZ,
                outp => sigBTND,
                rst => sigBTND
            );
        BTNL_DEBOUNCE : debouncer
            port map (
                inp => BTNL,
                clk => CLK100MHZ,
                outp => sigBTNL,
                rst => sigBTND
            );
        BTNR_DEBOUNCE : debouncer   
            port map (
                inp => BTNR,
                clk => CLK100MHZ,
                outp => sigBTNR,
                rst => sigBTND
            );

        
        B2S : bin2seg
        port map (
            clear    =>  b2sRst,
            bin      =>  sig_b2s,
            seg(6)   =>  CA,
            seg(5)   =>  CB,
            seg(4)   =>  CC,
            seg(3)   =>  CD,
            seg(2)   =>  CE,
            seg(1)   =>  CF,
            seg(0)   =>  CG
         );
        
        b2sRst <= sigBTND or sigToggler; -- reset pre bin2seg
        -- DP <= '0'; -- DP je stale zapnute

        MUX : i8to1Multiplex
            port map (
                counter0 => sig_counter0,
                counter1 => sig_counter1,
                counter2 => sig_counter2,
                counter3 => sig_counter3,
                counter4 => sig_counter4,
                counter5 => sig_counter5,
                counter6 => sig_counter6,
                counter7 => sig_counter7,
                switch => sig_smM,
                output => sig_b2s
            );

        SM : stateMachine
        port map(
            en => sig_en_SM,
            rst => sigBTND,
            clk => CLK100MHZ,
            stateM => sig_smM,
            stateA => AN,
            stateDP => DP
        );    

        CE_SM : clock_enable
            generic map (
                N_PERIODS => 150_000  -- 60Hz refresh @ 100 MHz
            )
            port map (
                clk => CLK100MHZ,
                rst => sigBTND,
                pulse => sig_en_SM
            );

    CE_TOGGLER_500 : clock_enable
        generic map (
            N_PERIODS => 12_500_000  -- 2Hz refresh @ 100 MHz
        )
        port map (
            clk => CLK100MHZ,
            rst => sigBTND,
            pulse => sigEnToggle
        );
        

        TOGGLE : toggler
            port map (
                outp => sigToggler,
                pause => sigPauseOut,
                rst => sigBTND,
                clk_500 => sigEnToggle,
                clk => CLK100MHZ
            );

            LED17_R <= sigToggler;
    -- instancie komponentov DOMINIK

    CE_TIME : clock_enable
        generic map (
            N_PERIODS => 100_000  -- 1 sekunda @ 100 MHz
        )
        port map (
            clk => CLK100MHZ,
            rst => sigBTND,
            pulse => sig_en_enable
        );
    
    -- -- logika pre ovladanie pocitadla / pauza resp play
    -- sig_autopause <= sig_timer_carry3;
    -- sig_en_timers_final <= sig_en_timers and not (BTNU or sig_autopause);

    -- sig_en1 <= sig_timer_carry0 and not sig_en_timers_final;
    -- sig_en2 <= sig_timer_carry1 and not sig_en_timers_final;
    -- sig_en3 <= sig_timer_carry2 and not sig_en_timers_final;    

    sig_en1 <= sig_timer_carry0;
    sig_en2 <= sig_timer_carry1;
    sig_en3 <= sig_timer_carry2;

    TIM_PAUSE : pause_toggle
        port map (
            clk => CLK100MHZ,
            rst => sigBTND,
            btn_pause => sigBTNU OR sig_timer_carry3,
            pause_out => sigPauseOut
        );


    EN_LOGIC : enable_logic
        port map (
            clk => CLK100MHZ,
            rst => sigBTND,
            pulse => sig_en_enable,
            pause => sigPauseOut,
            carry3 => sig_timer_carry3,

            enable_out => sig_en_timers_final
            -- auto_pause => sig_autopause
        );

    TIMER_0 : counter
        generic map (
            N_BITS => 4
        )
        port map (
            clk => CLK100MHZ,
            rst => sigBTND,
            en => sig_en_timers_final,
            count => sig_counter4,
            carry => sig_timer_carry0
        );
    TIMER_1 : counter_sec_des
        generic map (
            N_BITS => 4
        )
        port map (
            clk => CLK100MHZ,
            rst => sigBTND,
            en => sig_en1,
            count => sig_counter5,
            carry => sig_timer_carry1
        );
    TIMER_2 : counter
        generic map (
            N_BITS => 4
        )
        port map (
            clk => CLK100MHZ,
            rst => sigBTND,
            en => sig_en2,
            count => sig_counter6,
            carry => sig_timer_carry2
        );
    TIMER_3 : counter
        generic map (
            N_BITS => 4
        )
        port map (
            clk => CLK100MHZ,
            rst => sigBTND,
            en => sig_en3,
            count => sig_counter7,
            carry => sig_timer_carry3
        );
        
    sigBTNRf <= sigBTNR and not sigPauseOut;
    sigBTNLf <= sigBTNL and not sigPauseOut;
    -- sig_timer_carry3 <= sigBTNU; --autopauza po preteceni casovaca
    SCORE_0_SYNC : SyncLogic
        port map (
            CLK => CLK100MHZ,
            BTN => sigBTNRf,
            SW => SW,
            BTN_SYNC => sig_BTN_SYNC_0,
            BTN_PREV => sig_BTN_PREV_0,
            SW_SYNC => sig_SW_SYNC_0
        );
    SCORE_0_COUNTER : CounterLogic
        port map (
            CLK => CLK100MHZ,
            RST => sigBTND,
            BTN_SYNC => sig_BTN_SYNC_0,
            BTN_PREV => sig_BTN_PREV_0,
            SW_SYNC => sig_SW_SYNC_0,
            CNT1_OUT => sig_counter0,
            CNT2_OUT => sig_counter1
        );
    SCORE_1_SYNC : SyncLogic
        port map (
            CLK => CLK100MHZ,
            BTN => sigBTNLf,
            SW => SW,
            BTN_SYNC => sig_BTN_SYNC_1,
            BTN_PREV => sig_BTN_PREV_1,
            SW_SYNC => sig_SW_SYNC_1
        );
    SCORE_1_COUNTER : CounterLogic      
        port map (
            CLK => CLK100MHZ,
            RST => sigBTND,
            BTN_SYNC => sig_BTN_SYNC_1,
            BTN_PREV => sig_BTN_PREV_1,
            SW_SYNC => sig_SW_SYNC_1,
            CNT1_OUT => sig_counter2,
            CNT2_OUT => sig_counter3
        );
end Behavioral;
