
#!/bin/bash

# ID da transação
TXID="37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517"

# Passo 1: Obter as chaves públicas das entradas da transação
echo "Obtendo chaves públicas da transação $TXID..."
PUBKEYS=$(bitcoin-cli getrawtransaction "$TXID" true | jq -r ".vin[].txinwitness[1]" | paste -sd, -)

# Verificar se PUBKEYS foi gerado corretamente
if [ -z "$PUBKEYS" ]; then
  echo "Erro: Nenhuma chave pública foi encontrada na transação $TXID."
  exit 1
fi

echo "Chaves públicas obtidas: $PUBKEYS"

# Passo 2: Criar o descritor multisig
echo "Criando o descritor multisig..."
DESCRIPTOR="sh(multi(1,$PUBKEYS))"

# Passo 3: Validar o descritor com getdescriptorinfo
echo "Validando o descritor..."
DESCRIPTOR_INFO=$(bitcoin-cli getdescriptorinfo "$DESCRIPTOR")

# Extrair o checksum do descritor
CHECKSUM=$(echo "$DESCRIPTOR_INFO" | jq -r ".checksum")

if [ -z "$CHECKSUM" ]; then
  echo "Erro: Não foi possível validar o descritor."
  exit 1
fi

echo "Descritor validado com sucesso. Checksum: $CHECKSUM"

# Passo 4: Derivar o endereço multisig
echo "Derivando o endereço multisig..."
ADDRESS=$(bitcoin-cli deriveaddresses "$DESCRIPTOR")

if [ -z "$ADDRESS" ]; then
  echo "Erro: Não foi possível derivar o endereço multisig."
  exit 1
fi

echo "Endereço multisig derivado com sucesso: $ADDRESS"

# Resultado final
echo "Resumo:"
echo " - Transação: $TXID"
echo " - Chaves públicas: $PUBKEYS"
echo " - Descritor: $DESCRIPTOR"
echo " - Endereço multisig: $ADDRESS"

