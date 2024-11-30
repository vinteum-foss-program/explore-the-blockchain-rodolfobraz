#!/bin/bash

# Step 1: Get the block hash for block 123,321
blockhash=$(bitcoin-cli getblockhash 123321)

# Step 2: Retrieve all transaction IDs from that block
txs=$(bitcoin-cli getblock "$blockhash" | jq -r '.tx[]')

# Step 3: Iterate through each transaction to find unspent outputs
for txid in $txs; do
    # Get detailed information about the transaction
    raw_tx=$(bitcoin-cli getrawtransaction "$txid")
    decoded_tx=$(bitcoin-cli decoderawtransaction "$raw_tx")

    # Extract outputs
    outputs=$(echo "$decoded_tx" | jq -c '.vout[]')

    # Iterate through each output
    for output in $outputs; do
        vout=$(echo "$output" | jq '.n')
        addresses=$(echo "$output" | jq -r '.scriptPubKey.addresses[]?')

        # Skip if no address is associated (e.g., OP_RETURN outputs)
        if [[ -z "$addresses" ]]; then
            continue
        fi

        # Check if this output is unspent
        unspent=$(bitcoin-cli listunspent 0 9999999 "[{\"txid\":\"$txid\",\"vout\":$vout}]" | jq '. | length')

        if [[ $unspent -gt 0 ]]; then
            echo "The unspent output is sent to address: $addresses"
            exit 0
        fi
    done
done

echo "No unspent outputs found in block 123,321."

