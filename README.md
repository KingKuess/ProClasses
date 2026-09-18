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

### Remote configuration (ConfigURL, 2026-09-14)

Instead of keeping the `[ProClasses]` block in Game.ini, a server can point
ProClasses at a file hosted on GitHub (or any plain-text URL):

```ini
[ProClasses]
ConfigURL=https://raw.githubusercontent.com/KingKuess/ProClasses/main/proclasses.ini
ConfigPollSeconds=60      ; optional re-fetch interval, default 60
```

`bAllowHttpRequests=True` must be set under `[/Script/Mordhau.MordhauGameSession]`.
Game.ini is only read at boot, so restart once after adding the line (stop the
server first: Mordhau rewrites Game.ini on shutdown and can drop a line that
was added while it ran).

How it applies:

- The server fetches the file at every map start and every `ConfigPollSeconds`
  and caches it in `Saved/PlayerFiles/ProClassesRemote.txt`.
- The cache is applied at the **next** map load. Rule of thumb: push to
  GitHub, wait about five minutes (GitHub's raw CDN can serve the old file
  for that long), then change map.
- With `ConfigURL` set the ini `[ProClasses]` block is ignored, so everything
  you want (weapon lines, `Default`, `Armory*`, `HideServerClasses`,
  `WeaponSpeeds*`, `DodgeStaminaCost`, `DodgeDuration`) must be in the file. Keep the ini block anyway: it is the
  fallback for the first map after a boot, before any cache exists.
- Without `ConfigURL` nothing changes: the ini is read exactly as before.

The file is INI-style. `;` and `#` start comments. [proclasses.ini](proclasses.ini)
is The Jungle's live file.

```ini
[ProClasses]
; identical keys to the Game.ini section
Default=/ProWeapons/Classes/BP_Class_Default.BP_Class_Default_C
BP_Zweihander_NC_C=/ProWeapons/Classes/BP_Class_Support.BP_Class_Support_C
BP_Maul_NC_C=Bruiser            ; a class defined in [Classes] below

[Classes]
; inline class definitions: any BP_ProClassDef variable by name
; HeadTier/ChestTier/LegTier, HeadID/ChestID/LegID, Perk1..Perk5 (-1 = unused),
; Gear1/Gear2, WeaponID (>0 replaces the held weapon), LoadoutWeaponID
Bruiser=HeadTier:2,ChestTier:2,LegTier:1,HeadID:5,ChestID:3,LegID:11,Perk1:0,Perk2:21,Gear1:27

[Weapons]
; <donor asset>.<attack>.<field>=<value>, applied to the ProWeapons donor
; blueprints before the removal mod copies them (WeaponsConfig lines unchanged)
BP_NACL_Estoc.StrikeAttack.ComboWindupIncrease=0.2
BP_NACL_Longsword.StabAttack.Damage=65,55,45,34
BP_NACL_Partisan.StabAttack.bCanCombo=1
BP_NACL_Maul.StrikeAttack.TurnCaps=253.75,177.625
```

`[Weapons]` details:

- Attacks: `StrikeAttack`, `SecondStrikeAttack`, `StabAttack`, `SecondStabAttack`.
- Fields (the ones the removal mod replicates to clients): `Windup`,
  `Release`, `ComboWindupIncrease`, `MissComboExtraWindupIncrease`,
  `FeintLockOut`, `FlinchSpeedModifier`, `FlinchDurationModifier`,
  `StaminaDrain`, `ExtraStaminaDrainVsHeldBlock`, `MissStaminaCost`,
  `HitStaminaReward`, `MissRecovery`, `FeintCost`, `MorphCost`, `bCanCombo`,
  `bCanMissCombo`, `bStopOnHit`, `Damage`, `HeadBonus`, `LegBonus` (four
  comma-separated numbers, armor tiers 0-3), `TurnCaps` (two numbers).
  Chamber costs are owned by the removal mod and cannot be set here.
- Timing values must stay **below 1.0 s**. The game does not apply a
  `Release` of 1.0 or more (verified live 2026-09-15: 1.0 had no effect,
  0.999 worked). Assume the same for `Windup` and the other timings.
- Donor names resolve under `/ProWeapons/Weapons/`; set `WeaponRoot=` in
  `[ProClasses]` for another mount, or use a full `/Mod/Path/BP_X.BP_X_C`.
- Deleting a line reverts the field at the next map load (the server keeps
  `Saved/PlayerFiles/ProClassesBaseline.txt` for that).
- Known quirk: right after a value change, players who spawn in the first
  seconds of the map can see the old swing timing on their own screen for
  that one life (the server already uses the new value). Respawning fixes it.

### Dodge perk (2026-09-17)

The Dodge perk's numbers are not on the perk; they are two fields on the
character. ProClasses writes them onto every pawn (all players, classed or
not), on the server and on each client so the dodge check and the animation
length agree:

```ini
[ProClasses]
DodgeStaminaCost=15   ; optional. Default WITH ProClasses running = 15 (stock 10)
DodgeDuration=0.35    ; optional, seconds. Unset or 0 = stock 0.35
```

- Servers get the 15 stamina dodge with no ini change. Write
  `DodgeStaminaCost=10` to get the stock cost back.
- Both keys work in Game.ini and in the hosted file (with `ConfigURL` set,
  only the hosted file is read, like every other `[ProClasses]` key).
- Server log line at map start: `[ProClasses] dodge: stamina cost N (stock 10),
  duration D (0 = stock 0.35 s)`.

Log lines to look for (server log, `[ProClasses] remote ...`):
`ConfigURL set but no cache for it yet` (first map after boot),
`remote fetch sent=true <url>`, `remote config fetched (N lines incl. stamp)`,
`remote config APPLIED from cache (N lines): K keys, C inline classes, W weapon patches`,
`weapon patch <key> = <new> (was <old>)`, `weapon baseline restored <key> = <old>`,
`remote fetch FAILED, http code N`.

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
