#!/bin/bash

# 007.sh: Find the address of the only unspent output remaining from block 123321.

# -----------------------------------
# Step 1: Get the blockhash of the provided block
# -----------------------------------
BLOCK_HEIGHT=123321
BLOCK_HASH=$(bitcoin-cli getblockhash $BLOCK_HEIGHT)

# ------------
# Step 2: List all transactions in the block
# ------------
TXIDS=($(bitcoin-cli getblock $BLOCK_HASH | jq -r '.tx[]'))

# ---------------------------------------------------
# Step 3: Loop through all transactions to find the unspent output
# ---------------------------------------------------

for TXID in "${TXIDS[@]}"; do
    # Decode the transaction
    RAW_TX=$(bitcoin-cli getrawtransaction $TXID)
    DECODED_TX=$(bitcoin-cli decoderawtransaction $RAW_TX)

    # Get all vout indices
    VOUTS=$(echo $DECODED_TX | jq -c '.vout[]')

    # Loop through each vout
    for VOUT in $VOUTS; do
        VOUT_INDEX=$(echo $VOUT | jq -r '.n')

        # Check if the vout is unspent
        UTXO=$(bitcoin-cli gettxout $TXID $VOUT_INDEX)
        if [ -n "$UTXO" ]; then
            # Extract value and address from the unspent vout
            VALUE=$(echo $VOUT | jq -r '.value')
            ADDRESS=$(echo $VOUT | jq -r '.scriptPubKey.addresses[0]')

            echo "Unspent Output Found:"
            echo "Address: $ADDRESS"
            echo "Value: $VALUE BTC"
            exit 0
        fi
    done
done

echo "No unspent outputs found in block $BLOCK_HEIGHT."
