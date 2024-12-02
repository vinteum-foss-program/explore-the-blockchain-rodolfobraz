# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
 
#!/bin/bash

# Define the transaction ID of the spending transaction
txid="e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163"

# Decode the transaction to analyze its inputs
decoded_tx=$(bitcoin-cli getrawtransaction "$txid" true)

# Extract the witness stack of input 0
witness=$(echo "$decoded_tx" | jq -r '.vin[0].txinwitness')

# Extract the public key (second item in the witness stack)
pubkey=$(echo "$witness" | jq -r '.[1]')

# Output the public key
if [[ -n "$pubkey" ]]; then
    echo "Public key for input 0: $pubkey"
else
    echo "Failed to extract public key. Please verify the transaction details."
    exit 1
fi
