#!/bin/bash

# wansim-config.sh
# john.jones@riverbed.com jefferson.martin@riverbed.com
# This script is designed to run when the user "wanconfig"
# logs in. The menu will show options for changing bandwidth,
# delay and loss. According to the user's choice, the
# appropriate tc commands will be run to adjust these
# settings.
# creds - wanconfig::wanconfig
#
# changelog:
# 08/30/16 - added WAN2 options

red='\e[0;31m'
blue='\e[0;34m'
standard='\033[0;0;39m'
boldStart='\033[1m'
boldStop='\033[0m'

pause () {
	echo ""
        read -p "Press [Enter] to continue..." fackEnterKey

}

optionOneWAN1 () {
	echo ""
	tc qdisc del dev eth2 root 2> /dev/null
        tc qdisc add dev eth2 root handle 1: tbf rate 500kbit burst 700kb limit 3000
        tc qdisc add dev eth2 parent 1:1 handle 10: netem delay 100ms 10ms loss 0.5%
	echo ""
	echo -e "${boldStart}Typical WAN settings configured successfully!${boldStop}"
	pause
}

optionOneWAN2 () {
	echo ""
		tc qdisc del dev eth3 root 2> /dev/null
        tc qdisc add dev eth3 root handle 1: tbf rate 500kbit burst 700kb limit 3000
        tc qdisc add dev eth3 parent 1:1 handle 10: netem delay 100ms 10ms loss 0.5%
	echo ""
	echo -e "${boldStart}Typical WAN settings configured successfully!${boldStop}"
	pause
}

optionTwoWAN1 () {
	echo ""
        tc qdisc del dev eth2 root 2> /dev/null
        tc qdisc add dev eth2 root handle 1: tbf rate 1500kbit burst 1800kb limit 3000
        tc qdisc add dev eth2 parent 1:1 handle 10: netem delay 10ms 5ms loss 1%
	echo ""
    echo -e "${boldStart}LFN WAN (T1) settings configured successfully!${boldStop}"
	pause
}

optionTwoWAN2 () {
	echo ""
		tc qdisc del dev eth3 root 2> /dev/null
        tc qdisc add dev eth3 root handle 1: tbf rate 1500kbit burst 1800kb limit 3000
        tc qdisc add dev eth3 parent 1:1 handle 10: netem delay 10ms 5ms loss 1%
	echo ""
    echo -e "${boldStart}LFN WAN (T1) settings configured successfully!${boldStop}"
	pause
}

optionThreeWAN1 () {
	echo ""
        tc qdisc del dev eth2 root 2> /dev/null
        tc qdisc add dev eth2 root handle 1: tbf rate 2000kbit burst 2200kb limit 3000
        tc qdisc add dev eth2 parent 1:1 handle 10: netem delay 500ms 10ms loss 2%
     echo ""
     echo -e "${boldStart}Satellite WAN settings configured successfully!${boldStop}"
        pause
}

optionThreeWAN2 () {
	echo ""
        tc qdisc del dev eth3 root 2> /dev/null
        tc qdisc add dev eth3 root handle 1: tbf rate 2000kbit burst 2200kb limit 3000
        tc qdisc add dev eth3 parent 1:1 handle 10: netem delay 500ms 10ms loss 2%
     echo ""
     echo -e "${boldStart}Satellite WAN settings configured successfully!${boldStop}"
        pause
}

optionFourWAN1 () {
	echo ""
        tc qdisc del dev eth2 root 2> /dev/null
        tc qdisc add dev eth2 root handle 1: tbf rate 100000kbit burst 100000kb limit 3000
        tc qdisc add dev eth2 parent 1:1 handle 10: netem delay 5ms 2ms loss 0%
    echo ""
    echo -e "${boldStart}Typical LAN settings configured successfully!${boldStop}"
        pause
}

optionFourWAN2 () {
	echo ""
        tc qdisc del dev eth3 root 2> /dev/null
        tc qdisc add dev eth3 root handle 1: tbf rate 100000kbit burst 100000kb limit 3000
        tc qdisc add dev eth3 parent 1:1 handle 10: netem delay 5ms 2ms loss 0%
    echo ""
    echo -e "${boldStart}Typical LAN settings configured successfully!${boldStop}"
        pause
}


showMenu () {
	clear;
	echo "                      www.riverbedlab.com"
	echo ""
    echo "               >>>> WANSIM CONFIGURATION MENU <<<< "
	echo ""
	echo "Please choose from the following options:"
	echo ""
	echo -e " ${boldStart}WAN1${boldStop} Default - MPLS (T1) Network   BW: ${red}1.5 Mbps${standard}  DLY: ${red}70ms${standard}  LOSS: ${red}1%${standard}"
	echo ""
    echo -e "1. ${boldStart}Typical WAN${boldStop}                   BW: ${red}500 kbps${standard}     DLY: ${red}~100ms${standard}    LOSS: ${red}0.5%${standard}"
    echo -e "2. ${boldStart}LFN WAN (T1) (HSTCP/MXTCP)${boldStop}    BW: ${red}1.5 mbps${standard}     DLY: ${red}~10ms${standard}     LOSS: ${red}1%${standard}"
    echo -e "3. ${boldStart}Satellite WAN (SCPS)${boldStop}          BW: ${red}2 mbps${standard}       DLY: ${red}~500ms${standard}    LOSS: ${red}2%${standard}"
    echo -e "4. ${boldStart}Typical LAN${boldStop}                   BW: ${red}100 mbps${standard}     DLY: ${red}< ~5ms${standard}    LOSS: ${red}0%${standard}"
	echo ""
	echo -e " ${boldStart}WAN2${boldStop} Default - Intenet Public Network   BW: ${red}10 Mbps${standard}  DLY: ${red}70ms${standard}  LOSS: ${red}0.5%${standard}"
	echo ""
	echo -e "5. ${boldStart}Typical WAN${boldStop}                   BW: ${red}500 kbps${standard}     DLY: ${red}~100ms${standard}    LOSS: ${red}0.5%${standard}"
    echo -e "6. ${boldStart}LFN WAN (T1) (HSTCP/MXTCP)${boldStop}    BW: ${red}1.5 mbps${standard}     DLY: ${red}~10ms${standard}     LOSS: ${red}1%${standard}"
    echo -e "7. ${boldStart}Satellite WAN (SCPS)${boldStop}          BW: ${red}2 mbps${standard}       DLY: ${red}~500ms${standard}    LOSS: ${red}2%${standard}"
    echo -e "8. ${boldStart}Typical LAN${boldStop}                   BW: ${red}100 mbps${standard}     DLY: ${red}< ~5ms${standard}    LOSS: ${red}0%${standard}"
	echo -e "Q. ${boldStart}Quit${boldStop} menu and close console window"
    echo ""
}

readOptionsWAN () {
	local choice
	read -p "Enter choice [1,2,3,4,5,6,7,8,Q] " choice
	case $choice in
		1) optionOneWAN1 ;;
		2) optionTwoWAN1 ;;
		3) optionThreeWAN1 ;;
		4) optionFourWAN1 ;;
		5) optionOneWAN2 ;;
		6) optionTwoWAN2 ;;
		7) optionThreeWAN2 ;;
		8) optionFourWAN2 ;;
		q) clear; exit 0;;
		*) echo ""
	echo -e "${red}Error...${standard} Choose again." && sleep 2
	esac
}

while true
do
	showMenu
	readOptionsWAN
done
