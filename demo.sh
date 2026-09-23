#!/usr/bin/env bash
# Draws a small five-part build, then moves it forward one step at a time.
# Open demo-out/live.html in a browser while this runs and watch it colour itself.
set -euo pipefail
cd "$(dirname "$0")"
OUT=demo-out
./build-map init "$OUT" --title "Demo build" \
  --node "setup:Setup:repo and deps" \
  --node "api:API:routes" \
  --node "ui:UI:pages" \
  --node "tests:Tests:e2e" \
  --node "ship:Ship:deploy" \
  --after "api:setup" --after "ui:setup" \
  --after "tests:api,ui" --after "ship:tests"
echo "Open $OUT/live.html now."
sleep 4; ./build-map set "$OUT" setup=running:installing
sleep 4; ./build-map set "$OUT" setup=done api=running ui=running
sleep 4; ./build-map set "$OUT" api=done ui=blocked:"build error"
sleep 4; ./build-map set "$OUT" ui=done tests=running
sleep 4; ./build-map set "$OUT" tests=done ship=human:"approve deploy"
