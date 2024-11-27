# Using descriptors, compute the taproot address at index 100 derived from this extended public key:
#   `xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2`
# Gerar o checksum do descritor
CHECKSUM_DESCRIPTOR=$(bitcoin-cli getdescriptorinfo "tr(${XPUB}/0/100/*)" | jq -r '.descriptor')

# Derivar o endereço
ADDRESS=$(bitcoin-cli deriveaddresses "$CHECKSUM_DESCRIPTOR" 0)

# Remover aspas e brackets
ADDRESS=$(echo "$ADDRESS" | tr -d '[]"')

echo "Taproot Address at index 100: $ADDRESS"

Taproot Address at index 100:
  bc1pn38ddgas68jszc6m53act04a6jh9a4klnmsrcvz95ngj5mcv64fs4ehzd5