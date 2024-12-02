# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
 
#!/bin/bash

# Define the transaction ID of the spending transaction
txid="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"

# Decode the spending transaction
decoded_tx=$(bitcoin-cli getrawtransaction "$txid" true)

# Extract the previous transaction ID and vout index from the first input
prev_txid=$(echo "$decoded_tx" | jq -r '.vin[0].txid')
prev_vout=$(echo "$decoded_tx" | jq -r '.vin[0].vout')

echo "Previous transaction ID: $prev_txid"
echo "Vout being spent: $prev_vout"

# Decode the previous transaction
prev_tx=$(bitcoin-cli getrawtransaction "$prev_txid" true)

# Extract the scriptPubKey (asm) from the previous transaction
scriptPubKey_asm=$(echo "$prev_tx" | jq -r ".vout[$prev_vout].scriptPubKey.asm")
echo "scriptPubKey (previous transaction): $scriptPubKey_asm"

# Extract the scriptSig (asm) from the current transaction
scriptSig_asm=$(echo "$decoded_tx" | jq -r '.vin[0].scriptSig.asm')
echo "scriptSig (current transaction): $scriptSig_asm"

# Analyze the witness or scriptSig to find the redeem script (if present) and public key
redeem_script=$(echo "$scriptSig_asm" | awk '{print $NF}') # Last item in the scriptSig is usually the redeem script
pubkey=$(echo "$scriptSig_asm" | awk '{print $(NF-1)}')    # Second-to-last item in the scriptSig is usually the public key

echo "Redeem Script: $redeem_script"
echo "Public Key: $pubkey"

# Verify the hash of the redeem script matches the hash in the scriptPubKey
redeem_hash=$(echo -n "$redeem_script" | xxd -r -p | sha256sum | awk '{print $1}')
scriptPubKey_hash=$(echo "$scriptPubKey_asm" | awk '{print $NF}')

if [[ "$redeem_hash" == "$scriptPubKey_hash" ]]; then
    echo "Redeem script hash matches the scriptPubKey hash!"
else
    echo "Redeem script hash does NOT match the scriptPubKey hash!"
fi

