#!/usr/bin/env -S just --justfile
build:
  zola build && npx pagefind --site public --root-selector body

