# Blog tasks
@serve:
  zola serve -i 0.0.0.0
@build:
  zola build
  pagefind --site public --root-selector body

# scaffold a new post with timestamp slug
@new:
  bash scripts/new-post.sh
