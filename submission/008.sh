# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
 
TXID=e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163

TRANSACTION=$(bitcoin-cli getrawtransaction $TXID 1)

IF_CONDITION=$(echo $TRANSACTION | jq -r '.vin[0].txinwitness[1]')
# 01

WITNESS_SCRIPT=$(echo $TRANSACTION | jq '.vin[0].txinwitness[2]')
# "6321025d524ac7ec6501d018d322334f142c7c11aa24b9cffec03161eca35a1e32a71f67029000b2752102ad92d02b7061f520ebb60e932f9743a43fee1db87d2feb1398bf037b3f119fc268ac"

PUBKEY_1=$(echo $WITNESS_SCRIPT | jq -r '.[4:70]')
# 025d524ac7ec6501d018d322334f142c7c11aa24b9cffec03161eca35a1e32a71f

PUBKEY_0=$(echo $WITNESS_SCRIPT | jq -r '.[84:150]')
# 02ad92d02b7061f520ebb60e932f9743a43fee1db87d2feb1398bf037b3f119fc2

if [ $IF_CONDITION -ge 1 ]; then
  echo $PUBKEY_1
  # 025d524ac7ec6501d018d322334f142c7c11aa24b9cffec03161eca35a1e32a71f
else
  echo $PUBKEY_0
fi