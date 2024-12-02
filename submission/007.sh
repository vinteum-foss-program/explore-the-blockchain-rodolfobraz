#!/bin/bash

# Obter o hash do bloco
blockhash=$(bitcoin-cli getblockhash 123321)

# Listar todas as transações do bloco
txs=$(bitcoin-cli getblock "$blockhash" | jq -r '.tx[]')

# Loop através das transações para encontrar o UTXO
for tx in $txs; do
    # Decodificar a transação para extrair os vouts
    raw_tx=$(bitcoin-cli getrawtransaction "$tx")
    decoded_tx=$(bitcoin-cli decoderawtransaction "$raw_tx")
    vouts=$(echo "$decoded_tx" | jq -c ".vout[]")

    # Loop pelos vouts para verificar se foram gastos
    for vout in $vouts; do
        # Extrair o índice e verificar se o vout foi gasto
        vout_index=$(echo "$vout" | jq -c ".n")
        spent=$(bitcoin-cli -datadir=$HOME/.bitcoin gettxout "$tx" "$vout_index" 2>/dev/null)
        if [[ "$spent" != "" ]]; then
            # Imprimir o endereço e sair
            echo "$spent" | jq -r ".scriptPubKey.address"
            exit 0
        fi
    done
done

# Caso nenhum UTXO seja encontrado
exit 1

