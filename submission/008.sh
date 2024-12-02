# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
 
TXID=e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163

TRANSACTION=$(bitcoin-cli getrawtransaction $TXID 1)

IF_CONDITION=$(echo $TRANSACTION | jq -r '.vin[0].txinwitness[1]')

WITNESS_SCRIPT=$(echo $TRANSACTION | jq '.vin[0].txinwitness[2]')

PUBKEY_1=$(echo $WITNESS_SCRIPT | jq -r '.[4:70]')

PUBKEY_0=$(echo $WITNESS_SCRIPT | jq -r '.[84:150]')


if [ $IF_CONDITION -ge 1 ]; then
  echo $PUBKEY_1
  
else
  echo $PUBKEY_0
fi