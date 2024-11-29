#!/bin/bash

# Transaction ID
txid="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Get the transaction data
tx_data=$(bitcoin-cli getrawtransaction "$txid" 1)

# Check if the transaction was retrieved successfully
if [ -z "$tx_data" ]; then
  echo "Error: Could not retrieve transaction data."
  exit 1
fi

# Extract the previous transaction IDs and vout indexes from the inputs
inputs=$(echo "$tx_data" | jq -r '.vin[] | "\(.txid) \(.vout)"')

# Initialize an array for public keys
pubkeys=()

# Loop through each input to retrieve the public keys
while read -r prev_txid vout; do
  # Get the previous transaction data
  prev_tx_data=$(bitcoin-cli getrawtransaction "$prev_txid" 1)
  if [ -z "$prev_tx_data" ]; then
    echo "Error: Could not retrieve previous transaction $prev_txid."
    exit 1
  fi

  # Extract the public key from the scriptPubKey in the specified vout
  pubkey=$(echo "$prev_tx_data" | jq -r ".vout[$vout].scriptPubKey.asm" | awk '{print $2}')
  
  # Add the public key to the array
  if [ -n "$pubkey" ]; then
    pubkeys+=("$pubkey")
  fi
done <<< "$inputs"

# Ensure we have exactly 4 public keys
if [ "${#pubkeys[@]}" -ne 4 ]; then
  echo "Error: Did not find exactly 4 public keys."
  exit 1
fi

# Create the redeem script for 1-of-4 multisig
redeem_script="51" # OP_1
for pubkey in "${pubkeys[@]}"; do
  redeem_script+="$pubkey"
done
redeem_script+="54ae" # OP_4 OP_CHECKMULTISIG

# Hash the redeem script (RIPEMD-160(SHA-256(script)))
script_hash=$(echo "$redeem_script" | xxd -r -p | openssl dgst -sha256 -binary | openssl dgst -rmd160 -binary | xxd -p -c 80)

# Create the P2SH address
p2sh_address=$(bitcoin-cli -named createmultisig nrequired=1 keys='["'$script_hash'"]' | jq -r '.address')

# Output the result
echo "1-of-4 P2SH multisig address: $p2sh_address"
