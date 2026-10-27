#!/usr/bin/env bash
set -euo pipefail
app_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
moose_path=${1:-"$(dirname -- "$app_dir")/moose"}
if [[ -e "$moose_path" ]]; then
  echo "Refusing to overwrite existing MOOSE directory: $moose_path" >&2
  echo "Use it through MOOSE_DIR, or provide a new path as the first argument." >&2
  exit 1
fi
revision=$(tr -d '\r\n' < "$app_dir/MOOSE_REVISION")
git init "$moose_path"
git -C "$moose_path" remote add origin https://github.com/cpgr/moose.git
git -C "$moose_path" fetch --depth 1 origin "$revision"
git -C "$moose_path" checkout --detach FETCH_HEAD
printf 'Pinned MOOSE checkout: %s\n' "$moose_path"
printf 'For a non-sibling checkout, export MOOSE_DIR=%q\n' "$moose_path"
