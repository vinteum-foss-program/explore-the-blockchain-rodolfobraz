blockhash=$(bitcoin-cli getblockhash 123321)
txids=$(bitcoin-cli getblock "$blockhash" | jq -r '.tx[]')

for txid in $txids; do
    txdata=$(bitcoin-cli getrawtransaction "$txid" 1)
    num_vout=$(echo "$txdata" | jq '.vout | length')
    for (( vout=0; vout<num_vout; vout++ )); do
        txout=$(bitcoin-cli gettxout "$txid" $vout)
        if [ "$txout" != "null" ]; then
            scriptPubKeyHex=$(echo "$txout" | jq -r '.scriptPubKey.hex')
            decodedScript=$(bitcoin-cli decodescript "$scriptPubKeyHex")
            address=$(echo "$decodedScript" | jq -r '.addresses[0] // .address')
            if [ "$address" != "null" ]; then
                echo "$address"
            fi
        fi
    done
done
