@serve:
  zola serve
@build:
  zola build
  pagefind --site public --root-selector body
@format:
  rumdl check --fix .
  rumdl fmt .
@new:
  bash scripts/new-post.sh
