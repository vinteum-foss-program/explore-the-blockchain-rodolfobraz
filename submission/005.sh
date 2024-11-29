
#!/bin/bash

# Get the raw transaction data
tx_data=$(bitcoin-cli getrawtransaction 37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517 1)

# Check if transaction retrieval was successful
if [ -z "$tx_data" ]; then
  echo "Error: Could not retrieve transaction data."
  exit 1
fi

# Extract all vout addresses using jq
vout_addresses=$(echo "$tx_data" | jq -r '.vout[].scriptPubKey | @base64d | fromjson.addresses[]')

# Since it's a P2PKH transaction, extract the public keys
pubkeys=""
for address in $vout_addresses; do
  pubkey=$(bitcoin-cli gettxoutdetails "$address" | jq -r '.pubkey')
  pubkeys="$pubkeys""$pubkey"
done

# Create 1-of-4 redeem script (OP_1 followed by 4 public keys and OP_4 OP_CHECKMULTISIG)
redeem_script="01$pubkeys""0484"

# Hash the redeem script
script_hash=$(echo "$redeem_script" | xxd -r -p | openssl sha256 -ripemd160 | xxd -p)

# Create the P2SH address
p2sh_address=$(bitcoin-cli scriptpubkeytoaddress "0a$script_hash")

# Print the P2SH address
echo "1-of-4 P2SH multisig address: $p2sh_address"