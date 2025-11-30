# GitHub Pages maintenance

The documentation is published from the `docs/` folder via GitHub Pages. No submodule is required.

## Configure Pages
1. Open the repository Settings → Pages.
2. Set **Source** to "Deploy from a branch" and choose the default branch with `/docs` as the folder.
3. Save to enable the site at `https://<owner>.github.io/openspoolman/`.

## Updating docs
- Edit Markdown in `docs/` (e.g., `features.md`, `setup.md`, `deployment.md`).
- Add screenshots to `docs/img/` and reference them with relative links.
- Submit a pull request; the site will update automatically after merge.

## Preview locally
You can preview the static Markdown with any web server:
```bash
python -m http.server --directory docs 4000
```
For full Jekyll rendering, use `bundle exec jekyll serve --source docs --livereload` if you have Ruby tooling installed.

## Mirroring to a dedicated branch
If you prefer a separate `gh-pages` branch, copy the `docs/` folder into that branch via automation or a manual sync. The content remains the same; only the Pages source changes.
