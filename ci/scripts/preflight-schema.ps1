#!/usr/bin/env pwsh
# Preflight schema probe — Windows companion (invokes Python script).
# Phase 2a T0 gate per §5.3 4-assertion probe.
$python = if ($env:PYTHON) { $env:PYTHON } else { "python" }
& $python "$PSScriptRoot/preflight-schema.py" $args
exit $LASTEXITCODE
