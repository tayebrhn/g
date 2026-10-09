#!/usr/bin/env bash
# ============================================================
# TCExam — Apply Offline Production Patch / Update (Root Proxy)
# Delegates execution to offline-deployment/apply-patch.sh
# ============================================================

exec "$(dirname "$0")/offline-deployment/apply-patch.sh" "$@"
