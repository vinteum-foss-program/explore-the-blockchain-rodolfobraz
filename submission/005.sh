#!/bin/bash

# Chave pública extraída das entradas (todas as chaves são iguais neste caso)
pubkey='02ba9b867aeeb0b0b5460be20b227b94565f0ff3716310a3a7e1f280630d9b8592'

# Criar um array de chaves públicas (quatro vezes a mesma chave)
pubkeys='["'"$pubkey"'", "'"$pubkey"'", "'"$pubkey"'", "'"$pubkey"'"]'

# Criar o endereço multisig 1 de 4 usando o bitcoin-cli
# Especificamos o tipo de endereço como "legacy" para obter um endereço P2SH
result=$(bitcoin-cli createmultisig 1 "$pubkeys" "legacy")

# Extrair o endereço do resultado usando jq
address=$(echo "$result" | jq -r '.address')

# Imprimir o endereço
echo "$address"

