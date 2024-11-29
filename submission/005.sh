# Extrair a transação com detalhes completos e dados de witness
RAW_TX=$(bitcoin-cli getrawtransaction 37d966a263350fe747f1c606b159987545844a493dd38d84b070027a895c4517 true)

# Extrair as chaves públicas dos inputs
PUBKEY1=$(echo $RAW_TX | jq -r '.vin[0].txinwitness[-1]')
PUBKEY2=$(echo $RAW_TX | jq -r '.vin[1].txinwitness[-1]')
PUBKEY3=$(echo $RAW_TX | jq -r '.vin[2].txinwitness[-1]')
PUBKEY4=$(echo $RAW_TX | jq -r '.vin[3].txinwitness[-1]')

# Criar o descritor multisig com 1 assinatura requerida
DESCRIPTOR="multi(1,$PUBKEY1,$PUBKEY2,$PUBKEY3,$PUBKEY4)"

# Validar o descritor e extrair o descritor compacto
DESCRIPTOR_INFO=$(bitcoin-cli getdescriptorinfo "$DESCRIPTOR")
DESCRIPTOR_COMPACT=$(echo $DESCRIPTOR_INFO | jq -r '.descriptor')

# Gerar o endereço multisig a partir do descritor
ADDRESSES=$(bitcoin-cli deriveaddresses "$DESCRIPTOR_COMPACT")

# Exibir o primeiro endereço derivado
ADDRESS=$(echo $ADDRESSES | jq -r '.[0]')
echo $ADDRESS
