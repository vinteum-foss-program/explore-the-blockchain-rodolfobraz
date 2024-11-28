#!/bin/bash

# Define the transaction ID
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Step 1: Fetch raw transaction details
echo "Fetching raw transaction details..."
raw_transaction=$(bitcoin-cli getrawtransaction $TXID true)

# Step 2: Extract public keys from transaction inputs
echo "Extracting public keys from inputs..."
pubkeys=($(echo $raw_transaction | jq -r '.vin[].txinwitness[1]'))

# Verify if the public keys were extracted
if [ ${#pubkeys[@]} -ne 4 ]; then
  echo "Error: Expected 4 public keys, but found ${#pubkeys[@]}"
  exit 1
fi

# Print the extracted public keys
echo "Extracted Public Keys:"
for pubkey in "${pubkeys[@]}"; do
    echo "- $pubkey"
done

# Step 3: Format public keys into JSON array
echo "Formatting public keys into JSON array..."
pubkeys_json=$(jq -n --argjson keys "$(printf '%s\n' "${pubkeys[@]}" | jq -R . | jq -s .)" '$keys')

# Step 4: Create a 1-of-4 multisig address
echo "Creating 1-of-4 P2SH multisig address..."
multisig_info=$(bitcoin-cli createmultisig 1 "$pubkeys_json")

# Step 5: Extract and display the P2SH address and redeem script
multisig_address=$(echo $multisig_info | jq -r '.address')
redeem_script=$(echo $multisig_info | jq -r '.redeemScript')

echo "1-of-4 P2SH Multisig Address: $multisig_address"
echo "Redeem Script: $redeem_script"
