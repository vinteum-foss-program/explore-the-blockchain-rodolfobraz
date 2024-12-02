blockhash=$(bitcoin-cli getblockhash 123321)
blockdata=$(bitcoin-cli getblock "$blockhash" 1)
txids=$(echo "$blockdata" | jq -r '.tx[]')

for txid in $txids; do
    txdata=$(bitcoin-cli getrawtransaction "$txid" 1)
    num_vout=$(echo "$txdata" | jq '.vout | length')
    for (( vout=0; vout<num_vout; vout++ )); do
        txout=$(bitcoin-cli gettxout "$txid" $vout)
        if [ "$txout" != "null" ]; then
            address=$(echo "$txdata" | jq -r ".vout[$vout].scriptPubKey.addresses[0]")
            echo "O output não gasto está na transação $txid, vout $vout, enviado para o endereço $address"
        fi
    done
done
