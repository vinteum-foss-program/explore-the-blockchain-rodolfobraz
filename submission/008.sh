# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
#!/bin/bash

# Get the block hash of block 123321
blockhash=$(bitcoin-cli getblockhash 123321)

# Get all transaction IDs from the block
txids=$(bitcoin-cli getblock $blockhash | jq -r '.tx[]')

# Initialize variable to store the address
unspent_address=""

# Loop through each transaction ID
for txid in $txids; do
  # Get the raw transaction details
  raw_tx=$(bitcoin-cli getrawtransaction $txid true)
  
  # Loop through each output (vout) in the transaction
  vout_count=$(echo $raw_tx | jq '.vout | length')
  for (( i=0; i<$vout_count; i++ )); do
    # Get the scriptPubKey address
    address=$(echo $raw_tx | jq -r ".vout[$i].scriptPubKey.addresses[0]")
    
    # Skip if address is null (e.g., OP_RETURN outputs)
    if [ "$address" == "null" ]; then
      continue
    fi
    
    # Check if this output is unspent
    utxo=$(bitcoin-cli gettxout $txid $i)
    if [ -n "$utxo" ]; then
      # We've found the unspent output; store the address and exit loops
      unspent_address=$address
      break 2
    fi
  done
done

# Output the address
echo $unspent_address



