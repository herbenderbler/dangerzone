#!/usr/bin/env bash
# Repeat the Hancom HWP/HWPX CLI tests locally (see docs/ci_hwp_testing.md).
set -euo pipefail
runs="${1:-10}"
repo_root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo_root"
for i in $(seq 1 "$runs"); do
  echo "=== HWP CLI stress run $i/$runs ==="
  poetry run pytest tests/test_cli.py::TestExtraFormats::test_hancom_office -v -r fEr
done
