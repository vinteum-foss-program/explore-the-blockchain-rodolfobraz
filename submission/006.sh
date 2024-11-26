# Which tx in block 257,343 spends the coinbase output of block 256,128?
coinbase_txid=$(bitcoin-cli getblockhash 256128 | xargs bitcoin-cli getblock | jq -r '.tx[0]')
blockhash=$(bitcoin-cli getblockhash 257343)
txs=$(bitcoin-cli getblock $blockhash | jq -r '.tx[]')

for txid in $txs; do
    inputs=$(bitcoin-cli getrawtransaction $txid true | jq -r '.vin[].txid')
    if [[ $inputs == *"$coinbase_txid"* ]]; then
        echo $txid
        break
    fi
done