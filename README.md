# ProClasses guide site + server MOTD

Two files, no build step:

- `index.html` — the dense one-page web guide (GitHub Pages).
- `MOTD.md` — the in-game Message of the Day. Mordhau no longer renders HTML
  MOTDs; it fetches a **Markdown** file from a URL and supports only headings,
  bold, italics, links, numbered and bulleted lists. Keep it ASCII and simple.

## Server MOTD

In the server's `Game.ini`, under `[/Script/Mordhau.MordhauGameMode]`:

```ini
MOTDURL="https://raw.githubusercontent.com/KingKuess/ProClasses/main/MOTD.md"
```

(quotes included). Restart the server after adding it. GitHub's raw URLs are
cached for a few minutes, so edits to `MOTD.md` show up shortly after a push.

## Editing

`index.html` renders everything from the data block at the top of its
`<script>` (between `EDIT THIS BLOCK` / `END OF EDIT BLOCK`):

- `SITE` — server name, version/date stamp, mod.io link, Discord invite (empty
  hides the link).
- `CLASSES` — the three kits (tiers, perks, gear, one-line note).
- `DEFAULT_CLASS` — the fallback class line.
- `WEAPONS` — one line per roster weapon: name, point cost, class key, and
  `banned: true` for anything currently in the server's `[RemovalMod]` list.
- `ARMOR` — the replacement piece per tier/slot.

`MOTD.md` is plain text — update it by hand to match (weapon lists, banned
notes, perks, armor, version line).

## Publishing (GitHub Pages)

Repo **Settings → Pages → Build and deployment**: Source "Deploy from a
branch", branch `main`, folder `/ (root)`. The site is served at
`https://kingkuess.github.io/ProClasses/`; every push to `main` redeploys.
