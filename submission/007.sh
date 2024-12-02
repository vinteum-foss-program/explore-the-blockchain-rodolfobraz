#!/bin/bash

# Obtém o hash do bloco 123321
block_hash=$(bitcoin-cli getblockhash 123321)

# Obtém os dados completos do bloco com detalhes das transações
block_data=$(bitcoin-cli getblock "$block_hash" 2)

# Extrai as transações do bloco
txs=$(echo "$block_data" | jq -r '.tx[] | @base64')

# Percorre cada transação
for tx in $txs; do
    # Decodifica os dados da transação
    tx_data=$(echo "$tx" | base64 --decode)

    # Obtém o ID da transação
    txid=$(echo "$tx_data" | jq -r '.txid')

    # Percorre cada saída (vout) da transação
    vouts=$(echo "$tx_data" | jq -c '.vout[]')
    for vout in $vouts; do
        # Obtém o índice da saída
        n=$(echo "$vout" | jq '.n')

        # Verifica se a saída ainda não foi gasta
        utxo=$(bitcoin-cli gettxout "$txid" $n)
        if [ -n "$utxo" ]; then
            # Obtém o(s) endereço(s) associado(s) à saída
            addresses=$(echo "$vout" | jq -r '.scriptPubKey.addresses[]?')

            # Exibe as informações da saída não gasta
            echo "Saída não gasta encontrada:"
            echo "TXID: $txid"
            echo "VOUT: $n"
            echo "Endereço(s): $addresses"
            echo "-----------------------------"
        fi
    done
done
