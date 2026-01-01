#!/usr/bin/env -S just --justfile
build:
  zola build && pagefind --site public --root-selector body
