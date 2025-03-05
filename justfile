#!/usr/bin/env -S just --justfile
# ^ A shebang isn't required, but allows a justfile to be executed
#   like a script, with `./justfile build`, for example.

# Task  thet using Zola and Pagefindo build site
build:
  # Build the si\
  te with Zola
  zola build && npx pagefind --site public

