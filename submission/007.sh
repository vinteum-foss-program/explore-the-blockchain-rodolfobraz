# Only one single output remains unspent from block 123,321. What address was it sent to?
blockhash=$(bitcoin-cli getblockhash 123321)
txs=$(bitcoin-cli getblock $blockhash | jq -r '.tx[]')

for txid in $txs; do
    outputs=$(bitcoin-cli listunspent | jq -r --arg txid "$txid" '.[] | select(.txid == $txid) | .address')
    if [[ ! -z $outputs ]]; then
        echo $outputs
        break
    fi
done