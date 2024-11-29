#!/bin/bash

# Chave pública extraída das entradas (todas as chaves são iguais neste caso)
pubkey='02ba9b867aeeb0b0b5460be20b227b94565f0ff3716310a3a7e1f280630d9b8592'

# Criar um array de chaves públicas (quatro vezes a mesma chave)
pubkeys='["'"$pubkey1"'", "'"$pubkey2"'", "'"$pubkey3"'", "'"$pubkey4"'"]'

# Criar o endereço multisig 1 de 4 usando o bitcoin-cli
# Especificamos o tipo de endereço como "legacy" para obter um endereço P2SH
result=$(bitcoin-cli createmultisig 1 "$pubkeys" "legacy")

# Extrair o endereço do resultado usando jq
address=$(echo "$result" | jq -r '.address')

# Imprimir o endereço
echo "$address"
error: timeout on transient error: Could not connect to the server 127.0.0.1:8332

Make sure the bitcoind server is running and that you are connecting to the correct RPC port.
Use "bitcoin-cli -help" for more info.

 rodolfobraz@Rodolfos-MacBook-Pro  ~  bitcoin --version
zsh: command not found: bitcoin
 ✘ rodolfobraz@Rodolfos-MacBook-Pro  ~  >....
# Concatenar o payload e o checksum
address_bin="$payload$checksum"

# Converter o endereço binário para hexadecimal
address_hex=$(echo -n "$address_bin" | xxd -p -c999)

# Função para codificar em Base58
base58_encode() {
    local alphabet="123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
    local num=$(echo "ibase=16; $(echo "$1" | tr 'a-f' 'A-F')" | bc)
    local encoded=""
    while [ "$num" -gt 0 ]; do
        local remainder=$(($num % 58))
        encoded="${alphabet:$remainder:1}$encoded"
        num=$(($num / 58))
    done
    # Adicionar '1's para zeros iniciais
    local leading_zeros=$(echo "$1" | grep -o '^00*' | wc -c)
    local leading_ones=$(printf '1%.0s' $(seq 1 $((leading_zeros / 2))))
    echo "${leading_ones}${encoded}"
}

# Codificar o endereço em Base58
address=$(base58_encode "$address_hex")

# Imprimir o endereço
echo "$address"

base58_encode:4: number truncated after 20 digits: 35233585842191090242576023511294008081665685694911641477563
1