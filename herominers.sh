#!/bin/bash

if [[ -f "worker_name" ]]; then
        worker_name=`cat worker_name`
else
        echo -ne "Enter Worker Name (no spaces):  "
        read worker_name
        echo "$worker_name" > worker_name
fi

if [[ -f "dero_wallet_address" ]]; then
        dero_wallet_address=`cat dero_wallet_address`
else
        echo -ne "DERO Wallet Address: "
        read dero_wallet_address
        echo "$dero_wallet_address" > dero_wallet_address
fi
./CC/git/xmrigCC/build/xmrigDaemon -o de.dero.herominers.com:1117 -u $dero_wallet_address -p $worker_name -a astrobwt -k
