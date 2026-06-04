#!/usr/bin/env bash
set -euo pipefail

slug="${1:-$(date +%F-%H%M%S)}"
title="${2:-New Post}"
today=$(date +%F)

cat >"content/${slug}.md" <<EOF
+++
title = "${title}"
date = ${today}

[taxonomies]
tags = [乱七八糟]
+++

<!-- more -->

EOF

echo "Created: content/${slug}.md"
