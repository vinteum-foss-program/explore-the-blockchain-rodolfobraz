# Passo 1: Extrair a transação com detalhes completos e dados de witness
RAW_TX=$(bitcoin-cli getrawtransaction 37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517 true)

# Passo 2: Extrair todas as chaves públicas dos inputs e combinar em uma string separada por vírgulas
PUBKEYS=$(echo $RAW_TX | jq -r '[.vin[].txinwitness[-1]] | join(",")')

# Passo 3: Criar o descritor multisig
DESCRIPTOR="sh(multi(1,$PUBKEYS))"

# Passo 4: Obter informações do descritor
descriptor_info=$(bitcoin-cli getdescriptorinfo "$DESCRIPTOR")
descriptor=$(echo $descriptor_info | jq -r '.descriptor')

# Passo 5: Derivar o endereço
addresses=$(bitcoin-cli deriveaddresses "$descriptor")

# Passo 6: Exibir o endereço
echo $addresses | jq -r '.[0]'
