#!/bin/bash

# ID da transação
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Obter as chaves públicas das entradas da transação
PUBKEYS=$(bitcoin-cli getrawtransaction "$TXID" true | jq -r ".vin[].txinwitness[1]" | paste -sd, -)

# Validar se as chaves públicas foram extraídas corretamente
if [ -z "$PUBKEYS" ]; then
  exit 1 # Falha no teste se não houver chaves públicas
fi

# Criar o descritor multisig
RAW_DESCRIPTOR="sh(multi(1,$PUBKEYS))"

# Obter o descritor validado com checksum
VALID_DESCRIPTOR=$(bitcoin-cli getdescriptorinfo "$RAW_DESCRIPTOR" | jq -r ".descriptor")

# Validar se o descritor foi gerado corretamente
if [ -z "$VALID_DESCRIPTOR" ]; then
  exit 1 # Falha no teste se o descritor não for válido
fi

# Derivar o endereço multisig
ADDRESS=$(bitcoin-cli deriveaddresses "$VALID_DESCRIPTOR" | jq -r ".[0]")

# Validar se o endereço foi gerado corretamente
if [ -z "$ADDRESS" ]; then
  exit 1 # Falha no teste se o endereço não for gerado
fi

# Imprimir apenas o endereço como saída final
echo "$ADDRESS"

