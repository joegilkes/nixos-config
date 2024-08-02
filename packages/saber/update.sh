#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl gnused jq yq nix

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestVersion=$(curl --fail --silent https://api.github.com/repos/saber-notes/saber/releases/latest | jq --raw-output .tag_name | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; saber.version or (lib.getVersion saber)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "package is up-to-date: $currentVersion"
  exit 0
fi

sed -i "s/version = \".*\"/version = \"${latestVersion}\"/" "$ROOT/default.nix"

GIT_SRC_URL="https://github.com/saber-notes/saber/archive/refs/tags/v${latestVersion}.tar.gz"
GIT_SRC_SHA=$(nix hash to-sri --type sha256 $(nix-prefetch-url --unpack ${GIT_SRC_URL}))
sed -i "/linux/,/hash/{s|hash = \".*\"|hash = \"${GIT_SRC_SHA}\"|}" "$ROOT/default.nix"
curl https://raw.githubusercontent.com/saber-notes/saber/v${latestVersion}/pubspec.lock | yq . > $ROOT/pubspec.lock.json