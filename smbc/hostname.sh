#!/bin/bash
# Developed by Nikit Swaraj
#This script generate hostname for the server

#site is mostly Singapore 
site=$1
SITE=${site:0:3}
# env is Production, UAT, SIT, DR  (P/U/S/D)
env=$2
ENV=${env:0:1}
# Location is based on location of datacenter and Environment P1/P2/S2/U2 
LOC=$3
if [[ $LOC == "Serangoon" && $env == "Production_WithCustData" ]]; then
  LOC=P1
elif [[ $LOC == "Serangoon" && $env == "Production_NonCustData" ]]; then
  LOC=P1
elif [[ $LOC == 'DRC' && $env == 'UAT' ]]; then 
  LOC=U2
elif [[ $LOC == 'DRC' && $env == 'SIT' ]]; then 
  LOC=S2
elif [[ $LOC == 'DRC' && $env == 'DR' ]]; then
  LOC=P2
else
  echo "Pls Enter the Environment and Location properly : ENV -> Production_WithCustData/Production_NonCustData/UAT/SIT/DR : Location -> Serangoon/DRC"
  exit 1
fi
# Server type is VM or Physical (V/P)
servertype=$4
SRVTYPE=${servertype:0:1}
# based on OS windows and Linux (W/L)
os=$5
OS=${os:0:1}
# Based on Application or Database or Web (AP/DS/WB)
type=$6
TYPE=`echo $type | sed -e 's/$/ /' -e 's/\([^ ]\)[^ ]* /\1/g' -e 's/^ *//'`
# Systemcode based on the User entered (COB/SCM)
systemcode=$7
SYSCODE=${systemcode:0:3}
# Based on VM incremental seq no (01/02/03)
sequence=$8
SQNC=${sequence:0:2}

echo "$SITE$LOC$SRVTYPE$OS$TYPE$SYSCODE$SQNC" | tr [a-z] [A-Z]
