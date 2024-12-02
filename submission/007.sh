#!/bin/bash

# Obter o hash do bloco
blockhash=$(bitcoin-cli getblockhash 123321)

# Listar todas as transações do bloco
txs=$(bitcoin-cli getblock "$blockhash" | jq -r '.tx[]')

# Loop através das transações para encontrar o UTXO
for txid in $txs; do
    # Decodificar a transação para extrair os vouts
    raw_tx=$(bitcoin-cli getrawtransaction "$txid")
    decoded_tx=$(bitcoin-cli decoderawtransaction "$raw_tx")
    
    for index in $(echo "$decoded_tx" | jq -r '.vout[].n'); do
        # Verificar se o vout foi gasto usando gettxout
        utxo=$(bitcoin-cli gettxout "$txid" "$index")
        if [ -n "$utxo" ]; then
            # Se o gettxout retorna algo, significa que o vout não foi gasto
            address=$(echo "$utxo" | jq -r '.scriptPubKey.addresses[0]')
            echo "$address"
            exit 0
        fi
    done
done

# Caso nenhum UTXO seja encontrado
exit 1
