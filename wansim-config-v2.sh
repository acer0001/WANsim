#!/bin/bash

# wansim-config.sh
# This script is designed to run when the user "wanconfig"
# logs in. The menu will show options for changing bandwidth,
# delay and loss. According to the user's choice, the
# appropriate tc commands will be run to adjust these
# settings.
# creds - wanconfig::wanconfig

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
	clear ;
	echo ""
	tc qdisc del dev eth1 root 2> /dev/null
        tc qdisc add dev eth1 root handle 1: tbf rate 500kbit burst 700kb limit 3000
        tc qdisc add dev eth1 parent 1:1 handle 10: netem delay 100ms 10ms loss 0.5%
	echo ""
	echo -e "${boldStart}WAN 1 - Typical WAN settings configured successfully!${boldStop}"
	pause
}

optionOneWAN2 () {
	clear ;
	echo ""
	tc qdisc del dev eth2 root 2> /dev/null
        tc qdisc add dev eth2 root handle 1: tbf rate 500kbit burst 700kb limit 3000
        tc qdisc add dev eth2 parent 1:1 handle 10: netem delay 100ms 10ms loss 0.5%
	echo ""
	echo -e "${boldStart}WAN 2 - Typical WAN settings configured successfully!${boldStop}"
	pause
}

optionTwoWAN1 () {
	clear ;
	echo ""
        tc qdisc del dev eth1 root 2> /dev/null
        tc qdisc add dev eth1 root handle 1: tbf rate 1500kbit burst 1800kb limit 3000
        tc qdisc add dev eth1 parent 1:1 handle 10: netem delay 10ms 5ms loss 1%
	echo ""
 	echo -e "${boldStart}WAN 1 - LFN WAN (T1) settings configured successfully!${boldStop}"
	pause
}

optionTwoWAN2 () {
	clear ;
	echo ""
	tc qdisc del dev eth2 root 2> /dev/null
        tc qdisc add dev eth2 root handle 1: tbf rate 1500kbit burst 1800kb limit 3000
        tc qdisc add dev eth2 parent 1:1 handle 10: netem delay 10ms 5ms loss 1%
	echo ""
	echo -e "${boldStart}WAN 2 - LFN WAN (T1) settings configured successfully!${boldStop}"
	pause
}

optionThreeWAN1 () {
	clear ;
	echo ""
        tc qdisc del dev eth1 root 2> /dev/null
        tc qdisc add dev eth1 root handle 1: tbf rate 2000kbit burst 2200kb limit 3000
        tc qdisc add dev eth1 parent 1:1 handle 10: netem delay 500ms 10ms loss 2%
	echo ""
	echo -e "${boldStart}WAN 1 - Satellite WAN settings configured successfully!${boldStop}"
        pause
}

optionThreeWAN2 () {
	clear ;
	echo ""
        tc qdisc del dev eth2 root 2> /dev/null
        tc qdisc add dev eth2 root handle 1: tbf rate 2000kbit burst 2200kb limit 3000
        tc qdisc add dev eth2 parent 1:1 handle 10: netem delay 500ms 10ms loss 2%
 	echo ""
 	echo -e "${boldStart}WAN 2 - Satellite WAN settings configured successfully!${boldStop}"
        pause
}

optionFourWAN1 () {
	clear ;
	echo ""
        tc qdisc del dev eth1 root 2> /dev/null
        tc qdisc add dev eth1 root handle 1: tbf rate 100000kbit burst 100000kb limit 3000
        tc qdisc add dev eth1 parent 1:1 handle 10: netem delay 5ms 2ms loss 0%
	echo ""
	echo -e "${boldStart}WAN 1 - Typical LAN settings configured successfully!${boldStop}"
        pause
}

optionFourWAN2 () {
	clear ;
	echo ""
        tc qdisc del dev eth2 root 2> /dev/null
        tc qdisc add dev eth2 root handle 1: tbf rate 100000kbit burst 100000kb limit 3000
        tc qdisc add dev eth2 parent 1:1 handle 10: netem delay 5ms 2ms loss 0%
	echo ""
 	echo -e "${boldStart}WAN 2 - Typical LAN settings configured successfully!${boldStop}"
        pause
}

optionUserDefined () {
	wanchoice1 () {
		wanint=eth1
	}
	wanchoice2 () {
		wanint=eth2
	}
	clear ;
	echo ""
	echo -e "${boldStart}Custom Bandwidth and Latency${boldStop}"
	echo ""
	echo -e "${boldStart}1. WAN 1${boldStop} (Default: MPLS T1)"
	echo -e "${boldStart}2. WAN 2${boldStop} (Default: Public Internet Network)"
	echo ""
	local wanchoice
	read -p 'Enter WAN Network choice [1,2]: ' wanchoice
	case $wanchoice in
		1) wanchoice1 ;;
		2) wanchoice2 ;;
	esac
	echo ""
	read -p 'Enter your desired Bandwidth [100 kbps - 100000 kbps]: ' bandwidth
	read -p 'Enter your desired Latency [1 ms - 1500 ms]: ' latency
	echo ""
	if [[ $wanint = eth1 ]]; then
		wantext="WAN 1"
	else
		wantext="WAN 2"
	fi
	echo "You entered:"
	echo -e " Network - ${red}$wantext${standard}"
	echo -e " Bandwidth - ${red}$bandwidth kbps${standard}"
	echo -e " Latency - ${red}$latency ms${standard}"
	echo ""
	read -p "Press [Enter] to configure these values..." fackEnterKey 
        tc qdisc del dev $wanint root 2> /dev/null
        tc qdisc add dev $wanint root handle 1: tbf rate ${bandwidth}kbit burst ${bandwidth}kbit limit 3000
        tc qdisc add dev $wanint parent 1:1 handle 10: netem delay ${latency}ms ${latency}ms loss 0%
	echo ""
	echo -e "${boldStart}Your desired Bandwidth and Latency have been configured successfully!${boldStop}"
        pause
}

optionDefaults () {
	local DFLTSCRIPT
	for DFLTSCRIPT in /opt/wanconfig/*
	do
		if [ -f $DFLTSCRIPT -a -x $DFLTSCRIPT ]
		then
			$DFLTSCRIPT
		fi
	done
	clear ;
	echo ""
	echo -e " ${boldStart}All WAN Networks have been reset to original default settings.${boldStop}"
	echo ""
	pause
}

optionShowCurrent () {
	read wan1currbw <<< $(tc -p -s -d qdisc show dev eth1 | grep tbf | cut -d ' ' -f8)
	read wan1currdly <<< $(tc -p -s -d qdisc show dev eth1 | grep netem | cut -d ' ' -f9)
	read wan2currbw <<< $(tc -p -s -d qdisc show dev eth2 | grep tbf | cut -d ' ' -f8)
	read wan2currdly <<< $(tc -p -s -d qdisc show dev eth2 | grep netem | cut -d ' ' -f9)
	local DFLTSCRIPT
	for DFLTSCRIPT in /opt/wanconfig/*
	do
		if [ -f $DFLTSCRIPT -a $DFLTSCRIPT ]
		then
			WAN1DFLTBW=`cat $DFLTSCRIPT | grep "qdisc add dev eth1 root" | cut -d ' ' -f11`
			WAN1DFLTLATENCY=` cat $DFLTSCRIPT | grep "qdisc add dev eth1 parent" | cut -d ' ' -f12`
			WAN2DFLTBW=`cat $DFLTSCRIPT | grep "qdisc add dev eth2 root" | cut -d ' ' -f11`
			WAN2DFLTLATENCY=` cat $DFLTSCRIPT | grep "qdisc add dev eth2 parent" | cut -d ' ' -f12`
		fi
	done
	clear ;
	echo ""
	echo "Current Bandwidth and Latency Settings:"
	echo ""
	echo -e "${boldStart}WAN 1 - BW:${boldStop} ${red}$wan1currbw${standard}  ${boldStart}DLY:${boldStop} ${red}$wan1currdly${standard}"
	echo -e "${boldStart}WAN 2 - BW:${boldStop} ${red}$wan2currbw${standard}  ${boldStart}DLY:${boldStop} ${red}$wan2currdly${standard}"
	echo ""
	echo -e "Default Settings:"
	echo ""
	echo -e "WAN 1 - BW: $WAN1DFLTBW  DLY: $WAN1DFLTLATENCY"
	echo -e "WAN 2 - BW: $WAN2DFLTBW  DLY: $WAN2DFLTLATENCY"
	pause
}

showMenu () {
	clear;
	echo "          >>>> www.riverbedlab.com - WANSIM CONFIGURATION MENU <<<< "
	echo ""
	echo "Please choose from the following options:"
	echo ""
	echo -e " ${boldStart}WAN 1${boldStop} - MPLS (T1) Network"
	echo ""
	echo -e "1. ${boldStart}Typical WAN${boldStop}                   BW: ${red}500 kbps${standard}     DLY: ${red}~100ms${standard}    LOSS: ${red}0.5%${standard}"
	echo -e "2. ${boldStart}LFN WAN (T1) (HSTCP/MXTCP)${boldStop}    BW: ${red}1.5 mbps${standard}     DLY: ${red}~10ms${standard}     LOSS: ${red}1%${standard}"
	echo -e "3. ${boldStart}Satellite WAN (SCPS)${boldStop}          BW: ${red}2 mbps${standard}       DLY: ${red}~500ms${standard}    LOSS: ${red}2%${standard}"
	echo -e "4. ${boldStart}Typical LAN${boldStop}                   BW: ${red}100 mbps${standard}     DLY: ${red}< ~5ms${standard}    LOSS: ${red}0%${standard}"
	echo ""
	echo -e " ${boldStart}WAN 2${boldStop} - Intenet Public Network"
	echo ""
	echo -e "5. ${boldStart}Typical WAN${boldStop}                   BW: ${red}500 kbps${standard}     DLY: ${red}~100ms${standard}    LOSS: ${red}0.5%${standard}"
	echo -e "6. ${boldStart}LFN WAN (T1) (HSTCP/MXTCP)${boldStop}    BW: ${red}1.5 mbps${standard}     DLY: ${red}~10ms${standard}     LOSS: ${red}1%${standard}"
	echo -e "7. ${boldStart}Satellite WAN (SCPS)${boldStop}          BW: ${red}2 mbps${standard}       DLY: ${red}~500ms${standard}    LOSS: ${red}2%${standard}"
	echo -e "8. ${boldStart}Typical LAN${boldStop}                   BW: ${red}100 mbps${standard}     DLY: ${red}< ~5ms${standard}    LOSS: ${red}0%${standard}"
	echo ""
	echo -e "S. ${boldStart}Show Currect Settings${boldStop}"
	echo -e "C. ${boldStart}Custom Bandwidth and Latency${boldStop} - Choose your own!"
	echo -e "D. ${boldStart}Defaults${boldStop}  - Revert All WAN Networks to Original Settings"
	echo -e "Q. ${boldStart}Quit${boldStop} menu and close console window"
	echo ""
}

readOptionsWAN () {
	local choice
	read -p "Enter choice [1,2,3,4,5,6,7,8,s,c,d,q] " choice
	case $choice in
		1) optionOneWAN1 ;;
		2) optionTwoWAN1 ;;
		3) optionThreeWAN1 ;;
		4) optionFourWAN1 ;;
		5) optionOneWAN2 ;;
		6) optionTwoWAN2 ;;
		7) optionThreeWAN2 ;;
		8) optionFourWAN2 ;;
		s) optionShowCurrent ;;
		c) optionUserDefined ;;
		d) optionDefaults ;;
		q) clear; exit 0;;
		*) echo ""
		echo -e "${red}Error...${standard} Choose again." && sleep 2
	esac
}

while true;
do
	showMenu
	readOptionsWAN
done
