# ProClasses changelog

## 1.0.1 — unreleased

- **Fix: empty first slot no longer keeps the secondary.** Spawning with an
  empty slot 1 and a weapon in slot 2 gave the Default class but left the
  secondary in your inventory. The carried weapon is now removed like any
  other secondary; the greatsword replaces it.
- **Fix: the round-start drop exploit.** You can no longer drop your weapon
  while the class-swap window is open (grace period + a few seconds into the
  round), so dropping to grab the Default 3/3/3 kit and looting your weapon
  back no longer works. Once the swap window closes, dropping behaves
  normally again — and never re-classes you.

- **New: server-configurable armory roster.** The "Server Classes"
  suggestions can be overridden per server (`ArmoryClasses/ArmoryNames/
  ArmoryWeaponIDs` ini lines) or hidden entirely (`HideServerClasses=1`).
  Without those lines nothing changes.
- **New: third-party class packs.** Class-defs can live in any mounted mod,
  not just this one — a server points its `[ProClasses]` lines at them and
  they run on the same enforcement actor. First pack: Cashmate's 12
  classmod classes, converted from his cswic containers and delivered to
  him for his own weapon mod.

## 1.0.0 — 2026-08-30

First Kungle-specific weapon tuning on top of the recovered promod values:


- **Partisan** — stab vs T3 armor: **60 to the head, 40 to the torso** (was
  55 / 50; T3 legs drop to 30 as a side effect). Reward headshots on Vanguards.
- **Greatsword** — alt-grip stab combos **+25 ms** slower (combo windup
  0.125 → 0.15). It was the fastest combo on the server.
- **Spear** — main-grip stab windup **+25 ms** (0.65 → 0.675 — now matches
  the Halberd's stab).

## 0.0.4 — 2026-08-26

- Roster: **Partisan** and **Billhook** moved to Support; **Heavy Handaxe**
  added to Rat (27 weapons total).
- New armor defaults (used when your piece is the wrong tier):
  - T1: Peasant Hat / Coat of Plates (leather) / Rider's Hosen
  - T2: Eisenhut / Chainmail Shirt / Calf Guard Hosen
  - T3: Flat Templar / Crude Cuirass / Crude Chausses
- Perks settled: Support = Brawler, Stun, Acrobat · Rat = Brawler, Stun,
  Second Wind, Dodge, Acrobat · Vanguard/Default = Brawler, Stun.

Server config alongside this release:

- **Unbanned:** Falx, Arming Sword, Warhammer, Billhook, Partisan, and the
  Dodge perk. Still banned: Rapier, Short Spear, Falchion, Quarterstaff.
- **Heavy Handaxe now runs promod values** (was stock).
- All weapon configs served by ProWeapons; the old Cashmod pak retired.
- Class config re-keyed to the classes players actually hold — the fix that
  made per-weapon classes work live.
- In-game MOTD + this guide site.

## 0.0.3 — 2026-08-26

- First working release of the class system: per-weapon archetypes
  (Support 1/3/1, Rat 2/1/1, Vanguard 3/3/3, Default fallback), once-per-life
  application, armory "Server Classes" loadouts, default-unlocked armor.
- Weapon values identical to the original promod (Cashmod) set, rebuilt from
  scratch in ProWeapons.
