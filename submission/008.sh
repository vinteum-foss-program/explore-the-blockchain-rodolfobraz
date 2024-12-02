# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
#!/bin/bash

# Transaction ID
txid='e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163'

# Retrieve and decode the transaction
tx=$(bitcoin-cli getrawtransaction $txid true)

# Extract the 'asm' field of 'scriptSig' in input 0
asm=$(echo "$tx" | jq -r '.vin[0].scriptSig.asm')

# Extract the public key
pubkey=$(echo $asm | cut -d' ' -f2)

# Display the public key
echo "Public Key for input 0:"
echo $pubkey



