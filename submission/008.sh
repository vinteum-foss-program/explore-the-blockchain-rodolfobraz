# Which public key signed input 0 in this tx:
#   `e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163`
 
# ID da transação
txid='e5969add849689854ac7f28e45628b89f7454b83e9699e551ce14b6f90c86163'

# Recupera e decodifica a transação
tx=$(bitcoin-cli getrawtransaction $txid true)

# Extrai o campo 'asm' do 'scriptSig' da entrada 0
asm=$(echo "$tx" | jq -r '.vin[0].scriptSig.asm')

if [ -z "$asm" ] || [ "$asm" == "null" ]; then
  # Se 'asm' está vazio, é uma transação SegWit; extrai a chave pública dos dados de testemunha
  pubkey=$(echo "$tx" | jq -r '.vin[0].txinwitness[-1]')
else
  # Extrai a chave pública do 'asm'
  pubkey=$(echo $asm | cut -d' ' -f2)
fi

# Exibe a chave pública
echo $pubkey
