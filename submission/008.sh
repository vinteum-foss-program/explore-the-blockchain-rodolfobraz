# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
 
txid='e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163'

tx=$(bitcoin-cli getrawtransaction $txid true)

asm=$(echo "$tx" | jq -r '.vin[0].scriptSig.asm')

pubkey=$(echo $asm | cut -d' ' -f2)

echo $pubkey

