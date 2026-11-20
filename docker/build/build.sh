#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

echo "==> Assembling dist/ (workspace vendor/, if any, left untouched)"
rm -rf dist grandpasson-release.zip
mkdir dist

# Exact deployable set (MVP T12 / spec §18.3), plus lock for reproducible composer prune.
cp -a public_html app cron composer.json .env.example dist/
if [ -f composer.lock ]; then
  cp -a composer.lock dist/
fi

if [ -d vendor ]; then
  cp -a vendor dist/vendor

  echo "==> Pruning to production Composer dependencies inside dist/"
  (
    cd dist
    # Offline prune using the copied vendor (no Packagist/GitHub required).
    COMPOSER_DISABLE_NETWORK=1 \
      composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist
    rm -f composer.lock
  )
else
  # No workspace vendor/ (a Community Edition checkout, #122): install the locked
  # production dependencies into dist/ from Packagist. The workspace stays untouched.
  [ -f composer.lock ] || {
    echo "no vendor/ and no composer.lock: cannot resolve production dependencies" >&2
    exit 1
  }
  echo "==> No workspace vendor/: installing production Composer dependencies into dist/"
  (
    cd dist
    composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --no-progress
    rm -f composer.lock
  )
fi

echo "==> Creating grandpasson-release.zip"
(cd dist && zip -qr ../grandpasson-release.zip .)

echo "==> Verifying zip contents"
LIST="$(unzip -Z1 grandpasson-release.zip)"

for required in composer.json .env.example public_html/assets/theme.css public_html/assets/favicon.svg; do
  echo "$LIST" | grep -qx "$required" || {
    echo "missing required file: $required" >&2
    exit 1
  }
done

for prefix in public_html/ app/ vendor/ cron/; do
  echo "$LIST" | grep -q "^${prefix}" || {
    echo "missing required tree: $prefix" >&2
    exit 1
  }
done

echo "$LIST" | grep -E '^(tests/|docker/|docs/|\.git/|assets/brand/)' && {
  echo "forbidden path present in zip" >&2
  exit 1
} || true

echo "$LIST" | grep -E '^vendor/phpunit/|^vendor/bin/phpunit' && {
  echo "phpunit must not ship in zip" >&2
  exit 1
} || true

echo "==> S1 secret scan of release zip"
php -r '
require "'"$ROOT"'/app/Support/SecretScanner.php";
$findings = GrandpaSSOn\Support\SecretScanner::scanReleaseZip("'"$ROOT"'/grandpasson-release.zip");
if ($findings !== []) {
    fwrite(STDERR, implode("\n", $findings) . "\n");
    exit(1);
}
echo "S1 zip scan clean\n";
'

count="$(echo "$LIST" | wc -l | tr -d ' ')"
echo "OK: ${count} entries in grandpasson-release.zip"

echo "==> Done: $ROOT/grandpasson-release.zip"
