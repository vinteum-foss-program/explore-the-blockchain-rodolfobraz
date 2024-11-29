#!/bin/bash

# TxID da transação alvo
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Obter detalhes da transação alvo em formato JSON
bitcoin-cli getrawtransaction $TXID true > tx.json

# Extrair as chaves públicas dos campos 'txinwitness'
PUBKEYS=$(jq -r '.vin[].txinwitness[1]' tx.json | paste -sd"," -)

# Criar o descritor multisig 1 de 4 usando as chaves públicas extraídas
DESCRIPTOR="sh(multi(1,$PUBKEYS))"

# Obter o checksum do descritor
DESC_INFO=$(bitcoin-cli getdescriptorinfo "$DESCRIPTOR")
CHECKSUM=$(echo $DESC_INFO | jq -r '.checksum')

# Formar o descritor final com o checksum
DESC_WITH_CHECKSUM="$DESCRIPTOR#$CHECKSUM"

# Derivar o endereço P2SH a partir do descritor
ADDRESS=$(bitcoin-cli deriveaddresses "$DESC_WITH_CHECKSUM")

# Exibir o endereço resultante
echo "Endereço multisig 1 de 4 P2SH:"
echo $ADDRESS


