#!/bin/bash

# Obtém o hash do bloco 123321
block_hash=$(bitcoin-cli getblockhash 123321)

# Obtém os dados completos do bloco com detalhes das transações
block_data=$(bitcoin-cli getblock "$block_hash" 2)

# Percorre cada transação no bloco
echo "$block_data" | jq -c '.tx[]' | while read tx; do
    txid=$(echo "$tx" | jq -r '.txid')
    
    # Percorre cada saída (vout) da transação
    echo "$tx" | jq -c '.vout[]' | while read vout; do
        n=$(echo "$vout" | jq '.n')
        
        # Verifica se a saída ainda não foi gasta
        utxo=$(bitcoin-cli gettxout "$txid" "$n")
        if [ -n "$utxo" ]; then
            # Obtém o endereço associado à saída
            address=$(echo "$vout" | jq -r '.scriptPubKey.addresses[0] // .scriptPubKey.address // empty')
            if [ -n "$address" ]; then
                echo "Saída não gasta encontrada:"
                echo "TXID: $txid"
                echo "VOUT: $n"
                echo "Endereço: $address"
                echo "-----------------------------"
            else
                echo "Saída não gasta sem endereço reconhecido:"
                echo "TXID: $txid"
                echo "VOUT: $n"
                echo "-----------------------------"
            fi
        fi
    done
done
