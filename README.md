# ProClasses guide site + server MOTD

- `index.html` — the dense one-page guide (GitHub Pages). Fully static, no
  JavaScript.
- `MOTD.md` + `motd.png` — the in-game Message of the Day. Mordhau's MOTD
  panel renders **Markdown only** (headings, bold, italic, links, lists,
  images) — not HTML. So, like Cashmate's, the MOTD is a Markdown file that
  embeds a **screenshot of the page** plus a short text fallback and the link.
- `make-motd-png.ps1` — regenerates `motd.png` from `index.html` with headless
  Chrome/Edge at the panel width (860px), cropped to the card.

## Weapon values page

`weapons.html` is GENERATED — do not edit it by hand. It is built from the
recovered value data (stock CDO dump + promod deltas + `kungle_overrides.json`)
by `Mordhau\PyTools\make_weapons_page.py`. After any weapon tuning:

1. Run `python make_weapons_page.py` (no editor needed) — it writes both the
   site copy and the repo copy.
2. Commit and push. Bump `VERSION` in the script when the mod version changes.

Class assignment, banned flags and the roster live in the `ROSTER` table at
the top of that script. The per-weapon "discuss" links point at GitHub
Discussions — enable Discussions on the repo (Settings > Features) for them
to work.

## Server config reference

`kungle-Game.ini` is The Kungle's live server `Game.ini` with secrets
redacted (server/admin/RCON passwords, the StatTracker webhook, admin IDs).
`example-support-only-Game.ini` is a generic template enforcing ONLY the
1/3/1 Support class: six weapon lines, no `Default` line (so every other
loadout stays fully custom), armory suggestions trimmed to match, and
ChangeMe placeholders for all credentials.
The Kungle file shows exactly how the mods, `[ProClasses]`, `[CompModifiers]`,
`WeaponsConfig` and `[RemovalMod]` sections fit together — usable as a
starting point for another ProClasses server. Keep it in sync when the live
config changes.

## Server MOTD

In the server's `Game.ini`:

```ini
[/Script/Mordhau.MordhauGameMode]
MOTDURL="https://raw.githubusercontent.com/KingKuess/ProClasses/main/MOTD.md"
```

Quotes included; restart the server after changing it. GitHub raw URLs are
cached for a few minutes, so edits show up shortly after a push.

## Updating

1. Edit `index.html` (see below).
2. Run `powershell -ExecutionPolicy Bypass -File .\make-motd-png.ps1` to
   regenerate `motd.png`.
3. Update the text fallback in `MOTD.md` if classes, weapons or bans changed.
4. Commit and push all three.

## Editing `index.html`

Everything is plain markup:

- **Weapons**: one `<span class="wep">` pill per weapon inside each class
  column, alphabetical. To mark a weapon banned on the server, add the
  `banned` class and the badge span (example in the HTML comment above the
  roster). Remove them to un-ban.
- **Kits**: the `.kit` block at the top of each column (perk/gear tags, note).
- **Armor table**, **rules**, **Default line**: the two panels in `.deck`.
- **Version/date**: the `.stamp` in the masthead and the footer line.
- **Discord**: uncomment the link in the footer and paste your invite.
- Colors live in `:root` at the top of the stylesheet.

## Publishing (GitHub Pages)

Repo **Settings → Pages → Build and deployment**: Source "Deploy from a
branch", branch `main`, folder `/ (root)`. Served at
`https://kingkuess.github.io/ProClasses/`; every push to `main` redeploys
(allow a minute, then hard-refresh).
