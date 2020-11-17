#!/bin/bash

if [ -f ./serv.json ]; 
then 
    arrayCount=`jq '.server_details | length' ./serv.json`
    for (( ac=0; ac<arrayCount; ac++ ))
    do 
        echo "Server $ac";
        SITE=SNG
        ENV=$(jq -r ".server_details[$ac].environment" serv.json )
        LOC=$(jq -r ".server_details[$ac].location" serv.json)
        SRVTYPE=$(jq -r ".server_details[$ac].servertype" serv.json)
        OS=$(jq -r ".server_details[$ac].operatingsystem" serv.json)
        TYPE=$(jq -r ".server_details[$ac].usagetype" serv.json)
        SYSCODE=$(jq -r ".server_details[$ac].systemcode" serv.json)
        SQNC=$(jq -r ".server_details[$ac].seqNo" serv.json)
        HOSTname=`bash -x hostname.sh $SITE $ENV $LOC $SRVTYPE $OS "$TYPE" $SYSCODE $SQNC`;
        if [ $? == 0 ]; then
            cat serv.json | jq '.server_details['"$ac"'] += {"hostname": "'"$HOSTname"'"}' | sponge serv.json
            echo $HOSTname
        else 
            echo "There is error in generating hostname, pls refer the entered and recommended details"
            exit 1
        fi
    done
else
    echo "pls pass the value file"
fi


