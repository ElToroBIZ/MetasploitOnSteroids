#!/bin/bash
echo "Enter Fmn name - "
read fmn
if [ -z "$2" ]
	then 
	ports="80,21,23,25,53,67,69,161,380,443,8080,5500,3306,5060,136-139,445,3389,5800,5900"
	else
	ports=$2
fi
masscan $1 -p $ports | tee masstemp.txt

echo "<?xml version='1.0'?><?xml-stylesheet href='file:///usr/bin/../share/nmap/nmap.xsl' type='text/xsl'?><nmaprun>" > "$fmn.xml"


while read line
do
ip=`echo "$line" | awk '{print $6}'`
port=`echo "$line" | awk '{print $4}' | cut -d / -f 1`
prot=`echo "$line" | awk '{print $4}' | cut -d / -f 2`

case "$port" in
80) name="http"
;;
21) name="ftp"
;;
22) name="ssh"
;;
25) name="smtp"
;;
53) name="dns"
;;
67) name="dhcps"
;;
69) name="tftp"
;;
23) name="telnet"
;;
136) name="profile"
;;
137) name="netbios-ns"
;;
138) name="netbios-dgm"
;;
139) name="netbios-ssn"
;;
161) name="snmp"
;;
380) name="is99s"
;;
445) name="microsoft-ds"
;;
443) name="https"
;;
8080) name="http-proxy"
;;
3306) name="mysql"
;;
5060) name="sip"
;;
5500) name="hotline"
;;
3389) name="ms-wbt-server"
;;
5800) name="vnc-http"
;;
5900) name="vnc"
;;
*) echo "yahoo"
;;
esac

echo "<host><status state='up' reason='echo-reply' reason_ttl='249'/><address addr='$ip' addrtype='ipv4'/><hostnames></hostnames><ports><port protocol='$prot' portid='$port'><state state='open' reason='reset' reason_ttl='24'/><service name='$name' method='table' conf='3'/></port></ports></host>" >> "$fmn.xml"

done <masstemp.txt

echo "<runstats><finished time='1388433362' timestr='2013-12-30 14:56:02' elapsed='13' /><hosts up='2' down='0' total='2' /></runstats></nmaprun>" >> "$fmn.xml"

echo " "
echo " "
echo "File saved as $fmn.xml"
