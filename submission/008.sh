# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
 
#!/bin/bash

# Define the transaction ID of the spending transaction
txid="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"

# 1. Decode the transaction to analyze its inputs and outputs
decoded_tx=$(bitcoin-cli getrawtransaction "$txid" true)

# Extract the transaction ID of the previous output (input being spent)
prev_txid=$(echo "$decoded_tx" | jq -r '.vin[0].txid')
prev_vout=$(echo "$decoded_tx" | jq -r '.vin[0].vout')

echo "Previous transaction ID: $prev_txid"
echo "Vout being spent: $prev_vout"

# 2. Get the previous transaction details
prev_tx=$(bitcoin-cli getrawtransaction "$prev_txid" true)

# Extract the scriptPubKey from the previous transaction's output
scriptPubKey=$(echo "$prev_tx" | jq -r ".vout[$prev_vout].scriptPubKey.hex")
echo "scriptPubKey of the spent output: $scriptPubKey"

# 3. Extract and analyze the witness from the current transaction
witness=$(echo "$decoded_tx" | jq -r '.vin[0].txinwitness')
redeem_script=$(echo "$witness" | jq -r '.[-1]') # The redeem script is usually the last item in the witness stack
echo "Witness Stack: $witness"
echo "Redeem Script: $redeem_script"

# 4. Verify that the SHA256 hash of the redeem script matches the hash in the scriptPubKey
redeem_hash=$(echo -n "$redeem_script" | xxd -r -p | sha256sum | awk '{print $1}')
scriptPubKey_hash=$(echo "$scriptPubKey" | cut -c5-)

if [[ "$redeem_hash" == "$scriptPubKey_hash" ]]; then
    echo "Redeem script hash matches the scriptPubKey hash!"
else
    echo "Redeem script hash does NOT match the scriptPubKey hash!"
fi

# 5. Determine which public key signed the transaction
# The first item in the witness stack (besides the redeem script) is typically the signature.
# The second item is the public key.
signature=$(echo "$witness" | jq -r '.[0]')
public_key=$(echo "$witness" | jq -r '.[1]')

echo "Signature: $signature"
echo "Public Key: $public_key"
