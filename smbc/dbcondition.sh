#!/bin/bash
cd ${WORKSPACE}/smbc
DBMATCH=$(cat serv.json | jq -r .server_details[].databasesoftware | grep -Ev "NA")
if [ -z  "$DBMATCH" ]; then DBMATCH=NO ; else DBMATCH=YES; fi
echo $DBMATCH
