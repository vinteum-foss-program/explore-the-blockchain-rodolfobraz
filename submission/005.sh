#!/bin/bash

# Defina o TXID
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Obtenha os detalhes da transação e extraia as chaves públicas das entradas
pubkeys=($(bitcoin-cli getrawtransaction $TXID true | jq -r '.vin[].txinwitness[1]'))

# Verifique se há exatamente 4 chaves públicas
[ ${#pubkeys[@]} -ne 4 ] && { echo "Erro: Esperava-se 4 chaves públicas, mas foram encontradas ${#pubkeys[@]}."; exit 1; }

# Crie um array JSON com as chaves públicas
pubkeys_json=$(jq -n --argjson keys "$(printf '%s\n' "${pubkeys[@]}" | jq -R . | jq -s .)" '$keys')

# Crie um endereço multisig P2SH (1-of-4) e extraia o endereço e o Redeem Script
multisig_info=$(bitcoin-cli createmultisig 1 "$pubkeys_json")
multisig_address=$(echo $multisig_info | jq -r '.address')
redeem_script=$(echo $multisig_info | jq -r '.redeemScript')

# Exiba o resultado
echo "Endereço Multisig P2SH 1-of-4: $multisig_address"
echo "Redeem Script: $redeem_script"

