# Using descriptors, compute the taproot address at index 100 derived from this extended public key:
#   `xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2`
XPUB="xpub6Cx5tvq6nACSLJdra1A6WjqTo1SgeUZRFqsX5ysEtVBMwhCCRa4kfgFqaT2o1
kwL3esB1PsYr3CUdfRZYfLHJunNWUABKftK2NjHUtzDms2"

# Remove any whitespace or newlines in the xpub (if copied with line breaks)
XPUB=$(echo $XPUB | tr -d '\n')

# Construct the descriptor
DESCRIPTOR="tr($XPUB/0/*)"

# Get the descriptor info and extract the checksum
CHECKSUM=$(bitcoin-cli getdescriptorinfo "$DESCRIPTOR" | jq -r '.checksum')

# Combine the descriptor and checksum
DESCRIPTOR_WITH_CHECKSUM="${DESCRIPTOR}#${CHECKSUM}"

# Derive the address at index 100
ADDRESS=$(bitcoin-cli deriveaddresses "$DESCRIPTOR_WITH_CHECKSUM" "[100,100]" | jq -r '.[0]')

# Output the derived address
echo "The Taproot address at index 100 is:"
echo "$ADDRESS"