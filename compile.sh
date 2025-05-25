#!/usr/bin/env bash

set -e

echo 'For live rebuild, use "typst watch main.typ" or "typst watch --features html -f html main.typ --input html_mode=true".'

typst compile main.typ
typst compile main.typ  --features html -f html --input html_mode=true
