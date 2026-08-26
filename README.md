# ProClasses guide site

Single-file static site (`index.html`, no build step, no dependencies) in the
style of https://cashmate.github.io/classmod/ — for The Kungle's ProClasses.

## Editing

Everything on the page is rendered from the data block at the top of the
`<script>` in `index.html` (between `EDIT THIS BLOCK` / `END OF EDIT BLOCK`):

- `SITE` — server name, version pill, mod.io link, Discord invite (leave empty
  to hide the button).
- `CLASSES` — the three kits (tiers, perks, gear, one-line note).
- `DEFAULT_CLASS` — the fallback class text.
- `WEAPONS` — one line per roster weapon: name, point cost, class key, and
  `banned: true` for anything currently in the server's `[RemovalMod]` list
  (rendered greyed-out with a badge). Keep this in sync with `CLASSES.md`.
- `ARMOR` — the replacement piece per tier/slot.

Open `index.html` in a browser to preview; nothing needs to be served.

## Publishing on GitHub Pages

1. Create a public repo (e.g. `proclasses`) and put `index.html` at its root.
2. Repo **Settings → Pages → Build and deployment**: Source "Deploy from a
   branch", branch `main`, folder `/ (root)`. Save.
3. After a minute the site is live at `https://<your-user>.github.io/proclasses/`.
4. Updates: edit `index.html`, commit, push — Pages redeploys automatically.
