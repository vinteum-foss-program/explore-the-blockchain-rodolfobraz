# How many new outputs were created by block 123,456?
blockhash=$(bitcoin-cli getblockhash 123456)
block=$(bitcoin-cli getblock $blockhash)
txids=$(echo $block | jq -r '.tx[]')
outputs=0

for txid in $txids; do
    tx=$(bitcoin-cli getrawtransaction $txid true)
    vout_count=$(echo $tx | jq '.vout | length')
    outputs=$((outputs + vout_count))
done

echo $outputs