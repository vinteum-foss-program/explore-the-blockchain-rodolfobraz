#!/bin/bash

# Verificar conexão com o bitcoind
bitcoin-cli getblockchaininfo > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Erro: Não foi possível conectar ao servidor bitcoind. Verifique se ele está rodando."
  exit 1
fi

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
      continue
    fi

    decoded_tx=$(bitcoin-cli decoderawtransaction "$raw_tx" 2>/dev/null)
    if [ -z "$decoded_tx" ]; then
      continue
    fi

    vouts=$(echo "$decoded_tx" | jq -c ".vout[]" 2>/dev/null)
    if [ -z "$vouts" ]; then
      continue
    fi

    # Loop pelos vouts para verificar se foram gastos
    for vout in $vouts; do
        vout_index=$(echo "$vout" | jq -c ".n" 2>/dev/null)
        if [ -z "$vout_index" ]; then
          continue
        fi

        spent=$(bitcoin-cli -datadir=$HOME/.bitcoin gettxout "$tx" "$vout_index" 2>/dev/null)
        if [[ "$spent" != "" ]]; then
            address=$(echo "$spent" | jq -r ".scriptPubKey.address" 2>/dev/null)
            if [ -n "$address" ]; then
              # Saída apenas o endereço e encerra
              echo "$address"
              exit 0
            fi
        fi
    done
done

# Caso nenhum UTXO seja encontrado
exit 1




