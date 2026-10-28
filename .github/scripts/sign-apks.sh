#!/usr/bin/env bash
set -euo pipefail

apksigner=$1
shift
keys="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../app/keys" && pwd)"

omnt_signer=()
if [[ -f "$keys/OpenMobileNetworkToolkit-key.jks" ]]; then
  omnt_signer=(--ks "$keys/OpenMobileNetworkToolkit-key.jks"
    --ks-key-alias "$OMNT_KEY_ALIAS"
    --ks-pass env:OMNT_STORE_PASSWORD --key-pass env:OMNT_KEY_PASSWORD
    --next-signer)
fi

for apk in "$@"; do
  "$apksigner" sign --v1-signing-enabled true --v2-signing-enabled true \
    --v3-signing-enabled false --v4-signing-enabled false \
    "${omnt_signer[@]}" \
    --ks "$keys/sakura.jks" --ks-pass pass:sakurasim \
    --next-signer --ks "$keys/community.jks" --ks-pass pass:CommunityKey \
    --next-signer --ks "$keys/9esim.jks" --ks-pass pass:147258369 \
    "$apk"
done
