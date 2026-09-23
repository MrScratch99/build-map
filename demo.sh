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
sleep 4; ./build-map set "$OUT" setup=running:installing --say "setup: creating the repo and installing dependencies"
sleep 4; ./build-map set "$OUT" setup=done api=running ui=running \
  --say "api: writing the login and signup routes" --say "ui: building the sign-in page and form"
sleep 4; ./build-map set "$OUT" api=done ui=blocked:"build error" --say "ui: type error in the form component, fixing it"
sleep 4; ./build-map set "$OUT" ui=done tests=running --say "tests: running the end-to-end suite, 12 of 20 passed"
sleep 4; ./build-map set "$OUT" tests=done ship=human:"approve deploy" --say "ship: everything passed, waiting for your yes to deploy"
