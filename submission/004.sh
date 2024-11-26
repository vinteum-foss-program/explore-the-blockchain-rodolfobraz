# Using descriptors, compute the taproot address at index 100 derived from this extended public key:
#   `xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2`
from embit.descriptor import Descriptor
from embit.bip32 import HDKey

# Chave pública estendida fornecida
xpub = "xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2"

# Derivação para o índice 100
index = 100

# Criar descritor Taproot (tr)
descriptor = Descriptor.from_string(f"tr({xpub}/{index})")

# Derivar endereço Taproot
address = descriptor.derive(index).address()

print("Endereço Taproot no índice 100:", address)
