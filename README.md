# ProClasses guide site + server MOTD

- `index.html` — the dense one-page guide. **Fully static** (no JavaScript
  needed), so it renders inside Mordhau's MOTD panel as well as on the web.
- `MOTD.md` — plain-Markdown fallback of the same content, in case the game
  ever stops rendering HTML MOTDs.

## Server MOTD

The in-game MOTD panel renders HTML **only when the URL is served as
`text/html`**. Use the GitHub Pages address, never `raw.githubusercontent.com`
(raw serves `text/plain`, and the game then shows the page source as text):

```ini
[/Script/Mordhau.MordhauGameMode]
MOTDURL="https://kingkuess.github.io/ProClasses/"
```

Quotes included; restart the server after changing it. The panel is roughly
880px wide — the page keeps its three class columns down to 720px, so it fits
without stacking.

Markdown fallback, if HTML ever stops working:
`MOTDURL="https://raw.githubusercontent.com/KingKuess/ProClasses/main/MOTD.md"`

## Editing

Everything is plain markup in `index.html`:

- **Weapons**: one `<div class="wep">` line per weapon inside each class
  column, sorted by cost. To mark a weapon banned on the server, add the
  `banned` class and the badge span (there is an example in the HTML comment
  above the roster). Remove them to un-ban.
- **Kits**: the `.kit` block at the top of each column (perk/gear tags, note).
- **Armor table**, **rules**, **Default line**: the two panels in `.deck`.
- **Version/date**: the `.stamp` in the masthead and the footer line.
- **Discord**: uncomment the link in the footer and paste your invite.

Keep `MOTD.md` in sync by hand when the roster or bans change. Colors live in
`:root` at the top of the stylesheet.

## Publishing (GitHub Pages)

Repo **Settings → Pages → Build and deployment**: Source "Deploy from a
branch", branch `main`, folder `/ (root)`. Served at
`https://kingkuess.github.io/ProClasses/`; every push to `main` redeploys
(allow a minute, then hard-refresh).
