# Create a 1-of-4 P2SH multisig address from the public keys in the four inputs of this tx:
#   `37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517`
txid="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"
tx=$(bitcoin-cli getrawtransaction $txid true)
pubkeys=$(echo $tx | jq -r '.vin | .[].scriptSig.asm' | awk '{print $NF}')

multisig_desc="sh(multi(1,$(echo $pubkeys | sed 's/ /,/g')))"
address=$(bitcoin-cli deriveaddresses "$multisig_desc")

echo $address