#!/bin/bash

# ID da transação
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Passo 1: Obter as chaves públicas das entradas da transação
PUBKEYS=$(bitcoin-cli getrawtransaction "$TXID" true | jq -r ".vin[].txinwitness[1]" | paste -sd, -)

# Verificar se PUBKEYS foi gerado corretamente
if [ -z "$PUBKEYS" ]; then
  echo "Erro: Nenhuma chave pública foi encontrada na transação $TXID."
  exit 1
fi

# Passo 2: Criar o descritor multisig
RAW_DESCRIPTOR="sh(multi(1,$PUBKEYS))"

# Passo 3: Validar o descritor com getdescriptorinfo
VALID_DESCRIPTOR=$(bitcoin-cli getdescriptorinfo "$RAW_DESCRIPTOR" | jq -r ".descriptor")

if [ -z "$VALID_DESCRIPTOR" ]; then
  echo "Erro: Não foi possível validar o descritor."
  exit 1
fi

# Passo 4: Derivar o endereço multisig
ADDRESS=$(bitcoin-cli deriveaddresses "$VALID_DESCRIPTOR" | jq -r ".[0]")

if [ -z "$ADDRESS" ]; then
  echo "Erro: Não foi possível derivar o endereço multisig."
  exit 1
fi

# Imprimir apenas o endereço multisig
echo "$ADDRESS"
