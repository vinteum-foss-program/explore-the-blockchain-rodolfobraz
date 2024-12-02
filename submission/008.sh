# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
 
#!/bin/bash

# ID da transação
txid='e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163'

# Hash do bloco onde a transação está incluída
blockhash='0000000000000000000d1e8b63ec5225a12e20621e8d2fb3c44b144e6c160016'  # Substitua pelo hash correto do bloco

# Recupera e decodifica a transação, fornecendo o hash do bloco
tx=$(bitcoin-cli getrawtransaction $txid true $blockhash)

# Verifica se 'txinwitness' existe na entrada 0
witness=$(echo "$tx" | jq '.vin[0].txinwitness')

if [ "$witness" != "null" ]; then
  # É uma transação SegWit; extrai a chave pública de 'txinwitness[1]'
  pubkey=$(echo "$tx" | jq -r '.vin[0].txinwitness[1]')
else
  # Extrai o campo 'asm' do 'scriptSig' na entrada 0
  asm=$(echo "$tx" | jq -r '.vin[0].scriptSig.asm')
  if [ -z "$asm" ] || [ "$asm" == "null" ]; then
    echo "Nenhum 'scriptSig' encontrado na entrada 0."
    exit 1
  else
    # Extrai a chave pública do 'asm'
    pubkey=$(echo "$asm" | cut -d' ' -f2)
  fi
fi

# Exibe a chave pública
echo $pubkey
