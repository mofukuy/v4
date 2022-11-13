#!/bin/bash
# User Trial SSH / OPENVPN
# Edition : Stable Edition V1.0
# Auther  : AWALUDIN FERIYANTO
# (C) Copyright 2021-2022 By FSIDVPN
# =========================================

# // Exporting Language to UTF-8
export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'
export LC_CTYPE='en_US.utf8'

# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'

# // Export Banner Status Information
export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"

# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"

# // Exporting URL Host
export Server_URL="raw.githubusercontent.com/fikripps/prokontrol/main"
export Server_Port="443"
export Server_IP="underfined"
export Script_Mode="Stable"
export Auther="FsidVPN"

# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi

# // Exporting IP Address
export IP=$( curl -s https://ipinfo.io/ip/ )

# // License Key Detail
export Tanggal_Pembelian_License=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 3 | tr -d '\r' | tr -d '\r\n')
export Nama_Issued_License=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 9-100 | tr -d '\r' | tr -d '\r\n')
export Masa_Laku_License_Berlaku_Sampai=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 4 | tr -d '\r' | tr -d '\r\n')
export Install_Limit=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 2 | tr -d '\r' | tr -d '\r\n')
export Tipe_License=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $License_Key | cut -d ' ' -f 8 | tr -d '\r' | tr -d '\r\n')

# // Exporting Network Interface
export NETWORK_IFACE="$(ip route show to default | awk '{print $5}')"

# // Validate Result ( 1 )
touch /etc/${Auther}/license.key
export Your_License_Key="$( cat /etc/${Auther}/license.key | awk '{print $1}' )"
export Validated_Your_License_Key_With_Server="$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 1 )"
if [[ "$Validated_Your_License_Key_With_Server" == "$Your_License_Key" ]]; then
    validated='true'
else
    echo -e "${EROR} License Key Not Valid"
    exit 1
fi

# // Checking VPS Status > Got Banned / No
if [[ $IP == "$( curl -s https://${Server_URL}/blacklist.txt | cut -d ' ' -f 1 | grep -w $IP | head -n1 )" ]]; then
    echo -e "${EROR} 403 Forbidden ( Your VPS Has Been Banned )"
    exit  1
fi

# // Checking VPS Status > Got Banned / No
if [[ $Your_License_Key == "$( curl -s https://${Server_URL} | cut -d ' ' -f 1 | grep -w $Your_License_Key | head -n1)" ]]; then
    echo -e "${EROR} 403 Forbidden ( Your License Has Been Limited )"
    exit  1
fi

# // Checking VPS Status > Got Banned / No
if [[ 'Standart' == "$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 8 )" ]]; then 
    License_Mode='Standart'
elif [[ Pro == "$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $Your_License_Key | head -n1 | cut -d ' ' -f 8 )" ]]; then 
    License_Mode='Pro'
else
    echo -e "${EROR} Please Using Genuine License !"
    exit 1
fi

# // Checking Script Expired
Isadmin=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $Your_License_Key | cut -d ' ' -f 8 )
Nama=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $Your_License_Key | cut -d ' ' -f 9-100 )
exp=$( curl -s https://${Server_URL}/validated-registered-license-key.txt | grep -w $Your_License_Key | cut -d ' ' -f 4 )
now=`date -d "0 days" +"%Y-%m-%d"`
expired_date=$(date -d "$exp" +%s)
now_date=$(date -d "$now" +%s)
sisa_hari=$(( ($expired_date - $now_date) / 86400 ))
if [[ $sisa_hari -lt 0 ]]; then
    echo $sisa_hari > /etc/${Auther}/license-remaining-active-days.db
    echo -e "${EROR} Your License Key Expired ( $sisa_hari Days )"
    exit 1
else
    echo $sisa_hari > /etc/${Auther}/license-remaining-active-days.db
fi

# // Clear
clear

MYIP=$(curl -sS ipv4.icanhazip.com)
#########################

# Color Validation
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
# VPS Information
#Domain
domain=$(cat /etc/xray/domain)
#Status certificate
modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# Download
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
IPVPS=$(curl -s ipinfo.io/ip )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws_epro="${GREEN}ON${NC}"
else
    status_ws_epro="${red}OFF${NC}"
fi
# // Trojan Proxy
ss=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ss == "running" ]]; then
    status_ss="${GREEN}ON${NC}"
else
    status_ss="${red}OFF${NC}"
fi
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${red}OFF${NC}"
fi
if [ "$Isadmin" = "Pro" ]; then
uis="${GREEN}Premium User$NC"
else
uis="${red}Free Version$NC"
fi
MYIP=$(curl -sS ipv4.icanhazip.com)
echo "Checking VPS"
#########################

# Color Validation
DF='\e[39m'
Bold='\e[1m'
Blink='\e[5m'
yell='\e[33m'
red='\e[31m'
green='\e[32m'
blue='\e[34m'
PURPLE='\e[35m'
cyan='\e[36m'
Lred='\e[91m'
Lgreen='\e[92m'
Lyellow='\e[93m'
NC='\e[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
LIGHT='\033[0;37m'
RED='\033[0;31m'
NC='\033[0m'
yl='\e[32;1m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# VPS Information
#Domain
domain=$(cat /etc/xray/domain)
#Status certificate
modifyTime=$(stat $HOME/.acme.sh/${domain}_ecc/${domain}.key | sed -n '7,6p' | awk '{print $2" "$3" "$4" "$5}')
modifyTime1=$(date +%s -d "${modifyTime}")
currentTime=$(date +%s)
stampDiff=$(expr ${currentTime} - ${modifyTime1})
days=$(expr ${stampDiff} / 86400)
remainingDays=$(expr 90 - ${days})
tlsStatus=${remainingDays}
if [[ ${remainingDays} -le 0 ]]; then
	tlsStatus="expired"
fi
# OS Uptime
uptime="$(uptime -p | cut -d " " -f 2-10)"
# Download
#Download/Upload today
dtoday="$(vnstat -i eth0 | grep "today" | awk '{print $2" "substr ($3, 1, 1)}')"
utoday="$(vnstat -i eth0 | grep "today" | awk '{print $5" "substr ($6, 1, 1)}')"
ttoday="$(vnstat -i eth0 | grep "today" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload yesterday
dyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $2" "substr ($3, 1, 1)}')"
uyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $5" "substr ($6, 1, 1)}')"
tyest="$(vnstat -i eth0 | grep "yesterday" | awk '{print $8" "substr ($9, 1, 1)}')"
#Download/Upload current month
dmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $3" "substr ($4, 1, 1)}')"
umon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $6" "substr ($7, 1, 1)}')"
tmon="$(vnstat -i eth0 -m | grep "`date +"%b '%y"`" | awk '{print $9" "substr ($10, 1, 1)}')"
# Getting CPU Information
cpu_usage1="$(ps aux | awk 'BEGIN {sum=0} {sum+=$3}; END {print sum}')"
cpu_usage="$((${cpu_usage1/\.*} / ${corediilik:-1}))"
cpu_usage+=" %"
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
DAY=$(date +%A)
DATE=$(date +%m/%d/%Y)
IPVPS=$(curl -s ipinfo.io/ip )
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
uram=$( free -m | awk 'NR==2 {print $3}' )
fram=$( free -m | awk 'NR==2 {print $4}' )
# // SSH Websocket Proxy
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws_epro="${GREEN}ON${NC}"
else
    status_ws_epro="${red}OFF${NC}"
fi
# // Trojan Proxy
ss=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ss == "running" ]]; then
    status_ss="${GREEN}ON${NC}"
else
    status_ss="${red}OFF${NC}"
fi
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${GREEN}ON${NC}"
else
    status_nginx="${red}OFF${NC}"
fi

clear 
echo -e "${CYAN}╒━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╕\033[0m${NC}"
echo -e " \E[44;1;39m            ⇱ BIGETRON RED ALIENS ⇲             \E[0m"
echo -e "${CYAN}╘━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╛\033[0m${NC}"
echo -e "    [ SSH : $status_ws_epro ] [ X-RAY : $status_ss ] [ NGINX : $status_nginx ]"
echo -e "${CYAN}╒━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╕\033[0m${NC}"
echo -e "\e[33m Operating System     \e[0m: \033[1;32m "`hostnamectl | grep "Operating System" | cut -d ' ' -f5-`	${NC}
echo -e "\e[33m Total Amount Of RAM  \e[0m: \033[1;32m $tram MB ${NC}"
echo -e "\e[33m System Uptime        \e[0m: \033[1;32m $uptime ${NC}"
echo -e "\e[33m Isp Name             \e[0m: \033[1;32m $ISP ${NC}"
echo -e "\e[33m Domain               \e[0m: \033[1;36m $domain ${NC}"	
echo -e "\e[33m Ip Vps               \e[0m: \033[1;36m $IPVPS ${NC}"	
echo -e "${CYAN}╘━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╛\033[0m${NC}"
echo -e "${CYAN}╒━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╕\033[0m${NC}"
echo -e " \E[44;1;39m                 • SCRIPT MENU •                \E[0m"
echo -e "${CYAN}╘━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╛\033[0m${NC}"
echo -e " [\e[36m•1\e[0m] SSH & OpenVPN Menu [\e[36m•5\e[0m]\033[1;31m CEK AREK AKTIF SSH$NC"
echo -e " [\e[36m•2\e[0m] Vmess Menu         [\e[36m•6\e[0m]\033[1;31m CEK AREK AKTIF XRAY$NC"
echo -e " [\e[36m•3\e[0m] Vless Menu         [\e[36m•7\e[0m] Clear RAM Cache"
echo -e " [\e[36m•4\e[0m] Trojan Go Menu     [\e[36m•8\e[0m] Trojan WSS Menu"                  
echo -e  "\e[36m╒════════════════════════════════════════════════╕\033[0m"
echo -e " \E[44;1;39m                 Settings MENU                  \E[0m"
echo -e "\e[36m╘════════════════════════════════════════════════╛\033[0m
 [\033[1;36m09\033[0m] Setting Menu [\033[1;32mPro${NC}] [\033[1;36m14\033[0m] \033[1;31mSEtting Pasword VPS${NC}
 [\033[1;36m10\033[0m] Gen cert SSL       [\033[1;36m15\033[0m] \033[1;33mSEtting Auto Reboot${NC}
 [\033[1;36m11\033[0m] Cek Status \033[1;32mRUNNING${NC} [\033[1;36m16\033[0m] Cek Pkt bulanan
 [\033[1;36m12\033[0m] Reboot VPS \033[1;36mX-Ray${NC}   [\033[1;36m17\033[0m] Cek Pkt \033[1;33mHarian${NC}
 [\033[1;36m13\033[0m] Restart VPS        [\033[1;36m18\033[0m] Keluar \033[1;33mVPS${NC}
"
echo -e   " \033[1;33m Press x or [ Ctrl+C ] • To-Exit-Script ${NC}"
echo -e  "\e[36m╒════════════════════════════════════════════════╕\033[0m"
echo -e "\e[36m│ Client Name :$NC \033[1;32m$Nama ${NC}"
echo -e "\e[36m│ User Roles  :${NC} \033[1;32m$uis ${NC}"
    echo -e "\e[36m│ Exp License :$NC \033[1;32m$sisa_hari ${NC}Days Tersisa"
echo -e "\e[36m╘════════════════════════════════════════════════╛\033[0m"
echo -e   ""
read -p " Select menu :  "  opt
echo -e   ""
case $opt in
1) clear ; menu-ssh ;;
2) clear ; menu-vmess ;;
3) clear ; menu-vless ;;
4) clear ; menu-trgo ;;
5) clear ; cek ;;
6) clear ; cek-ws ;;
7) clear ; clearcache ;;
8) clear ; menu-trojan ;;
9) clear ; menu-set ;;
10) clear ; certv2ray ;;
11) clear ; status ;;
12) clear ; reboot ;;
13) clear ; restart ;;
14) clear ; passwd ;;
15) clear ; jam ;;
16) clear ; vnstat ;;
17) clear ; vnstat -d ;;
18) clear ; exit ;;
x) exit ;;
esac
