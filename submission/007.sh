#!/bin/bash

# Obter o hash do bloco
blockhash=$(bitcoin-cli getblockhash 123321 2>/dev/null)
if [ -z "$blockhash" ]; then
  echo "Erro: Não foi possível obter o hash do bloco."
  exit 1
fi

# Listar todas as transações do bloco
txs=$(bitcoin-cli getblock "$blockhash" | jq -r '.tx[]' 2>/dev/null)
if [ -z "$txs" ]; then
  echo "Erro: Não foi possível obter as transações do bloco."
  exit 1
fi

# Loop através das transações para encontrar o UTXO
for tx in $txs; do
    # Decodificar a transação para extrair os vouts
    raw_tx=$(bitcoin-cli getrawtransaction "$tx" 2>/dev/null)
    if [ -z "$raw_tx" ]; then
      echo "Erro: Não foi possível obter a transação bruta."
      continue
    fi

    decoded_tx=$(bitcoin-cli decoderawtransaction "$raw_tx" 2>/dev/null)
    if [ -z "$decoded_tx" ]; then
      echo "Erro: Não foi possível decodificar a transação."
      continue
    fi

    vouts=$(echo "$decoded_tx" | jq -c ".vout[]" 2>/dev/null)
    if [ -z "$vouts" ]; then
      echo "Erro: Não foi possível extrair os vouts."
      continue
    fi

    # Loop pelos vouts para verificar se foram gastos
    for vout in $vouts; do
        vout_index=$(echo "$vout" | jq -c ".n" 2>/dev/null)
        if [ -z "$vout_index" ]; then
          echo "Erro: Não foi possível extrair o índice do vout."
          continue
        fi

        spent=$(bitcoin-cli -datadir=$HOME/.bitcoin gettxout "$tx" "$vout_index" 2>/dev/null)
        if [[ "$spent" != "" ]]; then
            address=$(echo "$spent" | jq -r ".scriptPubKey.address" 2>/dev/null)
            if [ -n "$address" ]; then
              echo "$address"
              exit 0
            else
              echo "Erro: Não foi possível extrair o endereço."
            fi
        fi
    done
done

# Caso nenhum UTXO seja encontrado
echo "Erro: Nenhum UTXO não gasto encontrado."
exit 1

