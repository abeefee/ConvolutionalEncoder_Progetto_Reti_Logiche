-- Alberto Biffi (Codice Persona 10677341, Matricola 933268)
-- Giovanni Mattia Codemo (Codice Persona 10707329, Matricola 934968)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

type state is (START, READ_W, READ_BYTE_REQ, READ_BYTE, EXECUTION, WAIT_RAM, WAIT_READ, 
                        WRITE_BYTE, SET_DONE, DONE_WAIT);

begin

process(i_clk)

variable tmp, W_bitStream : std_logic_vector(7 downto 0);
variable writtenBit : INTEGER RANGE 0 to 4 := 0; 
variable printedByte, byteToRead : INTEGER RANGE 0 to 255 := 0; 
variable u_k, p1_k, p2_k, q0, q1, q0_f, q1_f : STD_LOGIC := '0';
variable read_address, write_address : std_logic_vector(15 downto 0) := "0000000000000000";
variable state_next, state_curr : state := START;

begin
    if(i_clk'event and i_clk = '1') then
        if(i_rst = '1') then
            state_curr := START;
        else
            state_curr := state_next;
        end if;

        case state_curr is 
            when START =>                    
                read_address := "0000000000000000";
                write_address := "0000001111100111";
                tmp := "00000000";
                writtenBit := 0;
                printedByte := 0;
                o_done <= '0';
                o_en <= '0';
                o_we <= '0';

                u_k := '0';
                q0_f := '0';
                q1_f := '0';

                if(i_start = '1')then
                    o_en <= '1';
                    o_we <= '0';
                    o_address <= read_address;
                    state_next := WAIT_RAM;
                else
                    state_next := START;
                end if;
                
            when WAIT_RAM =>
                o_en <= '0';
                o_we <= '0';
                state_next := READ_W;
            
            when READ_W =>
                o_en <= '0';
                o_we <= '0';
                byteToRead := conv_integer(i_data);
                state_next := READ_BYTE_REQ;

            when READ_BYTE_REQ =>
                if(byteToRead = 0) then
                    state_next := SET_DONE;
                else
                    o_en <= '1';
                    o_we <= '0';
                    byteToRead := byteToRead - 1;
                    read_address := read_address + 1;
                    o_address <= read_address;
                    state_next := WAIT_READ;
                end if;
          
            when WAIT_READ =>
                o_en <= '0';
                o_we <= '0';
                state_next := READ_BYTE;
                
            when READ_BYTE =>
                W_bitStream := i_data;
                state_next := EXECUTION;
                
            when EXECUTION =>
                if(writtenBit = 4) then     
                    o_en <= '0';
                    o_we <= '0';
                    write_address := write_address + 1;
                    state_next := WRITE_BYTE;       
                else
                    o_en <= '0';
                    o_we <= '0';   
                    u_k := W_bitStream(7);
                    W_bitStream := std_logic_vector(shift_left(unsigned(W_bitStream), 1));
                    q0 := q0_f;
                    q1 := q1_f;
                    p1_k := u_k xor q1;
                    p2_k := u_k xor q0 xor q1;
                    q0_f := u_k;
                    q1_f := q0;
                    tmp := std_logic_vector(shift_left(unsigned(tmp), 1));
                    tmp(0) := p1_k;
                    tmp := std_logic_vector(shift_left(unsigned(tmp), 1));
                    tmp(0) := p2_k;  
                  
                    writtenBit := writtenBit + 1;
                   
                    state_next := EXECUTION;             
                end if;
           
            when WRITE_BYTE =>
                o_en <= '1';
                o_we <= '1';                
                o_address <= write_address;
                o_data <= tmp;
                printedByte := printedByte + 1;                               
                tmp := "00000000";
                writtenBit := 0;
                if(printedByte <2) then
                    state_next := EXECUTION;
                else
                    state_next := READ_BYTE_REQ;
                    printedByte := 0;
                end if;
                
            when SET_DONE =>
                o_en <= '0';
                o_we <= '0';
                o_done <= '1';
                state_next := DONE_WAIT;
                
            when DONE_WAIT =>
                if(i_start = '0') then
                    state_next := START;
                else
                    state_next := DONE_WAIT;
                end if;
                
        end case;
    end if;
end process;

end Behavioral;