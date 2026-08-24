#!/usr/bin/env bash

set -e

echo 'Per il PDF: "typst compile main.typ" (o "typst watch main.typ").'
echo 'Per la versione web (Shiroa): "shiroa build -d dist".'

typst compile main.typ
shiroa build -d dist
