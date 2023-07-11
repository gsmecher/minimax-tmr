library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library unisim;
use unisim.vcomponents.all;

library xpm;
use xpm.vcomponents.all;

entity wrapper is port (
	clk_100mhz : in std_logic;
	led0_r, led1_r, led2_r, led3_g : out std_logic := '0';
	btn0, btn1, btn2, btn3 : in std_logic);
end wrapper;

architecture behav of wrapper is
	type v12_array is array(integer range <>) of std_logic_vector(11 downto 0);
	type v16_array is array(integer range <>) of std_logic_vector(15 downto 0);
	type v32_array is array(integer range <>) of std_logic_vector(31 downto 0);
	type v4_array is array(integer range <>) of std_logic_vector(3 downto 0);

	signal inst_addr : v12_array(0 to 2);
	signal inst : v16_array(0 to 2);
	signal inst_ce : std_logic_vector(0 to 2);

	signal addr, wdata : v32_array(0 to 2);
	signal rdata : v32_array(0 to 2) := (others => 32x"0");
	signal wmask : v4_array(0 to 2);
	signal rreq : std_logic_vector(0 to 2);
	signal rack : std_logic_vector(0 to 2) := (others => '0');

	signal reset0, reset1, reset2 : std_logic := '0';
begin
	process(clk_100mhz)
	begin
		if rising_edge(clk_100mhz) then
			reset0 <= btn0 or btn3;
			reset1 <= btn1 or btn3;
			reset2 <= btn2 or btn3;
		end if;
	end process;

	rom_gen : for n in 0 to 2 generate
	begin
		rom : xpm_memory_tdpram
		generic map (
			ADDR_WIDTH_A => 11,
			ADDR_WIDTH_B => 10,
			AUTO_SLEEP_TIME => 0,
			BYTE_WRITE_WIDTH_A => 16,
			BYTE_WRITE_WIDTH_B => 32,
			CASCADE_HEIGHT => 0,
			CLOCKING_MODE => "common_clock",
			ECC_MODE => "no_ecc",
			MEMORY_INIT_FILE => "blink.mem",
			MEMORY_INIT_PARAM => "0",
			MEMORY_OPTIMIZATION => "true",
			MEMORY_PRIMITIVE => "block",
			MEMORY_SIZE => 32 * 1024,
			MESSAGE_CONTROL => 0,
			READ_DATA_WIDTH_A => 16,
			READ_DATA_WIDTH_B => 32,
			READ_LATENCY_A => 1,
			READ_LATENCY_B => 1,
			READ_RESET_VALUE_A => "0",
			READ_RESET_VALUE_B => "0",
			RST_MODE_A => "SYNC",
			RST_MODE_B => "SYNC",
			SIM_ASSERT_CHK => 0,
			USE_EMBEDDED_CONSTRAINT => 0,
			USE_MEM_INIT => 1,
			USE_MEM_INIT_MMI => 1,
			WAKEUP_TIME => "disable_sleep",
			WRITE_DATA_WIDTH_A => 16,
			WRITE_DATA_WIDTH_B => 32,
			WRITE_MODE_A => "no_change",
			WRITE_MODE_B => "no_change",
			WRITE_PROTECT => 1)
		port map (
			douta => inst(n),
			doutb => rdata(n),
			addra => inst_addr(n)(11 downto 1),
			addrb => addr(n)(11 downto 2),
			clka => clk_100mhz,
			clkb => clk_100mhz,
			dina => 16x"0",
			dinb => wdata(n),
			ena => inst_ce(n),
			enb => rreq(n),
			injectdbiterra => '0',
			injectdbiterrb => '0',
			injectsbiterra => '0',
			injectsbiterrb => '0',
			regcea => '0',
			regceb => '0',
			rsta => '0',
			rstb => '0',
			sleep => '0',
			wea => "0",
			web => "0");
	end generate;

	dut : entity work.minimax_tmr
	port map (
		clk => clk_100mhz,

		reset_TMR_0 => reset0,
		reset_TMR_1 => reset1,
		reset_TMR_2 => reset2,

		inst_addr_TMR_0 => inst_addr(0),
		inst_addr_TMR_1 => inst_addr(1),
		inst_addr_TMR_2 => inst_addr(2),

		inst_ce_TMR_0 => inst_ce(0),
		inst_ce_TMR_1 => inst_ce(1),
		inst_ce_TMR_2 => inst_ce(2),

		inst_TMR_0 => inst(0),
		inst_TMR_1 => inst(1),
		inst_TMR_2 => inst(2),

		addr_TMR_0 => addr(0),
		addr_TMR_1 => addr(1),
		addr_TMR_2 => addr(2),

		wdata_TMR_0 => wdata(0),
		wdata_TMR_1 => wdata(1),
		wdata_TMR_2 => wdata(2),

		rdata_TMR_0 => rdata(0),
		rdata_TMR_1 => rdata(1),
		rdata_TMR_2 => rdata(2),

		wmask_TMR_0 => wmask(0),
		wmask_TMR_1 => wmask(1),
		wmask_TMR_2 => wmask(2),

		rreq_TMR_0 => rreq(0),
		rreq_TMR_1 => rreq(1),
		rreq_TMR_2 => rreq(2),

		rack_TMR_0 => rack(0),
		rack_TMR_1 => rack(1),
		rack_TMR_2 => rack(2));

	-- Capture LED blinker
	io_proc: process(clk_100mhz)
	begin
		if rising_edge(clk_100mhz) then
			rack <= rreq;

			-- Writes to address 0xfffffffc address the LED
			if wmask(0)=x"f" and addr(0)=x"fffffffc" then
				led0_r <= wdata(0)(0);
			end if;
			if wmask(1)=x"f" and addr(1)=x"fffffffc" then
				led1_r <= wdata(1)(0);
			end if;
			if wmask(2)=x"f" and addr(2)=x"fffffffc" then
				led2_r <= wdata(2)(0);
			end if;
		end if;
	end process;

	LUT3_inst : LUT3
	generic map (INIT => X"e8")
	port map (
		O => led3_g,
		I0 => led0_r,
		I1 => led1_r,
		I2 => led2_r);
end behav;
