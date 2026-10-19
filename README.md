# CrispyDoom for MiSTer

Doom, Doom II, Final Doom, their expansions, Heretic, Hexen and Strife on [MiSTer FPGA](https://github.com/MiSTer-devel/Main_MiSTer/wiki) as a hybrid port.

The game itself is [Crispy Doom](https://github.com/fabiangreffrath/crispy-doom), the source port by Fabian Greffrath that stays close to the original Doom (it is based on [Chocolate Doom](https://www.chocolate-doom.org)) and lifts its limits, and for Heretic, Hexen and Strife its Crispy Heretic, Crispy Hexen and Crispy Strife. It runs on the MiSTer's ARM CPU. The CrispyDoom FPGA core provides native 15kHz video (CRT, VGA and HDMI) at 320x200, 640x200, 320x240 or 640x240, 44.1kHz audio with the music on an OPL2 (YM3812) FM chip in the core, and keyboard, mouse and gamepad input. The two halves talk through shared DDR3 memory.

> **Beta.** Expect rough edges and please report problems in the issues.

Disclaimer: AI is being used to speed up development of this project.

## Requirements

- **danik_hybrid_ports**, the launcher (`Scripts/danik_hybrid_ports.sh`): run it **once** from the MiSTer's `Scripts` menu. It starts the game whenever its menu entry is loaded, keeps running after a reboot, and serves all our hybrid ports; its screen picks which ports and games to have, and can keep them up to date through `update_all`. It replaces `danik_hybrid_cores`, the launcher before it, and moves ports installed the old way into the new folders by itself. Without it the core says "Game not running".
- **Game data**, which is not included: your own copy of Doom (or The Ultimate Doom), Doom II or Final Doom (TNT: Evilution and The Plutonia Experiment), their expansions (SIGIL, SIGIL II, No Rest for the Living, the Master Levels), Heretic, Hexen (and its expansion Deathkings of the Dark Citadel), Strife, or the shareware of Doom, Heretic or Strife. The game is in its `.WAD` file (the "IWAD"), from the original release or a later one (GOG, Steam).

## Installation

With `update_all` (Downloader 2.4 or newer, which update_all keeps up to date):

1. Copy [`downloader_danik_hybrid_ports.ini`](https://raw.githubusercontent.com/ItsDanik/Hybrid_MiSTer/main/launcher/downloader_danik_hybrid_ports.ini) to the root of your SD card (`/media/fat`).
2. Run `update_all`. That installs the launcher, **danik_hybrid_ports**, in `Scripts`.
3. Run **danik_hybrid_ports** from the `Scripts` menu, tick the games you want and press *X: Apply*. They are installed, and update_all keeps them up to date.

By hand:

1. Download the newest `CrispyDoom_YYYYMMDD.zip` from [releases](releases/) and extract it to the root of your SD card (`/media/fat`). That gives you:
   - `_Other/dnk-Doom.mgl`, `dnk-SIGIL.mgl`, `dnk-SIGIL II.mgl`, `dnk-Doom II.mgl`, `dnk-No Rest for the Living.mgl`, `dnk-Master Levels.mgl`, `dnk-TNT Evilution.mgl`, `dnk-Plutonia Experiment.mgl`, `dnk-Heretic.mgl`, `dnk-Hexen.mgl`, `dnk-Deathkings of the Dark Citadel.mgl` and `dnk-Strife.mgl`, the games' entries in the `Other` menu
   - `_Other/dnk/dnk-CrispyDoom_YYYYMMDD.rbf`, the FPGA core
   - `games/dnk/CrispyDoom/`, the game binary and its launch script
   - `Scripts/danik_hybrid_ports.sh`, the launcher (from [Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer))
   - `downloader_danik_hybrid_ports.ini`, with which `update_all` keeps the ports up to date from then on
2. Copy **everything** in your games' folders to `/media/fat/games/dnk/CrispyDoom/`, all the files as they are (files the port does not use do no harm). Each game is known by its IWAD:

   | Game | File |
   |---|---|
   | Doom, The Ultimate Doom | `DOOM.WAD` |
   | Doom shareware | `DOOM1.WAD` |
   | SIGIL | `SIGIL_v1_21.wad` (or `SIGIL_V1_23.wad`, `SIGIL_V1_23_REG.wad`, `SIGIL_v1_2.wad`, `SIGIL.wad`) and the `DOOM.WAD` of The Ultimate Doom (the one with episode 4) |
   | SIGIL II | `SIGIL_II_V1_0.WAD` (or `SIGIL_II_MP3_V1_0.WAD`) and the `DOOM.WAD` of The Ultimate Doom |
   | Doom II | `DOOM2.WAD` |
   | No Rest for the Living | `NERVE.WAD` and `DOOM2.WAD` |
   | Master Levels | `MASTERLEVELS.WAD` (or the 20 WADs of the Master Levels CD: `ATTACK.WAD`, `CANYON.WAD` and so on) and `DOOM2.WAD` |
   | TNT: Evilution | `TNT.WAD`, and `TNT31.WAD` where your copy has it (id's fix of MAP31's yellow key), which is then loaded as well |
   | The Plutonia Experiment | `PLUTONIA.WAD` |
   | Heretic | `HERETIC.WAD` (shareware: `HERETIC1.WAD`) |
   | Hexen | `HEXEN.WAD` |
   | Deathkings of the Dark Citadel | `HEXDD.WAD` and the `HEXEN.WAD` of Hexen 1.1 |
   | Strife | `STRIFE1.WAD` and `VOICES.WAD` (the voices; Strife plays without them) (shareware: `STRIFE0.WAD`) |
3. Run **danik_hybrid_ports** from the `Scripts` menu, if you have not done so before (see Requirements).
4. Load the game from the `Other` menu, e.g. **dnk-Doom II**.

The game data can go on a USB drive instead, into the same folder there (`/media/usb0/games/dnk/CrispyDoom/`): the game looks for it there first, and then keeps its settings and saved games there as well. Everything else stays on the SD card.

Each expansion has its own menu entry: it starts at its own levels (New Game goes straight to the skill), with its own saved games (`savegames/sigil/` and so on), and the expansions Crispy Doom would otherwise load next to Doom II by itself are left to their entries. The menu entries of Doom, Heretic and Strife start the shareware when the full game is not there. When a game's files are missing, the core says which file to copy where. Each game keeps its own OSD settings and button mappings. The core file itself (`_Other/dnk/dnk-CrispyDoom_*.rbf`, or from *Recent*) lists the games that are there to pick from; quitting a game then returns to the list. The game's log is in `/media/fat/logs/dnk/CrispyDoom/crispydoom.log`, its settings in `games/dnk/CrispyDoom/default.cfg` and `crispy-doom.cfg`, saved games in `games/dnk/CrispyDoom/savegames/<IWAD>/` (on the USB drive, if the game data is there). Heretic's are `heretic.cfg`, `crispy-heretic.cfg` and `hticsav*.hsg` in the same folder, Hexen's `hexen.cfg`, `crispy-hexen.cfg` and `savegames/hexen.wad/` (Deathkings' `savegames/hexdd/`), Strife's `strife.cfg`, `crispy-strife.cfg` and `savegames/strife1.wad/`.

## OSD options

| Option | |
|---|---|
| Aspect ratio, Scale, Scandoubler Fx, Stereo Mix | as in other cores |
| FPS Counter | shows the pictures per second in the top left corner |
| HDMI Only | **Yes** if no CRT is connected: resolutions of 640x400 and more are then progressive instead of interlaced, and the analog output is switched off while one is shown, so that a 15kHz screen can never get such a signal. Nothing changes at lower resolutions. Not needed with `forced_scandoubler=1` (VGA monitor); not there with `direct_video=1` |
| CRT Options | for a 15kHz screen: *Horizontal Size*, *Horizontal Pos* and *Vertical Pos* fit the picture to it. The pixels stay as they are; HDMI is not affected. The size is for the game's picture: the core's own, with its messages, keeps its width. Not there with `forced_scandoubler=1`. *HUD (Top)* / *HUD (Bottom)*: in 320x240, how many lines the messages sit below the top edge of the screen and the status bar above the bottom one, 0 to 24 (10 by default), so that a CRT's overscan does not hide them; greyed out in 320x200 and 640x200 |
| Resolution | what the game draws and the core puts out, always at 15kHz: **320x240** (default), **640x240**, **320x200** (as the original) or **640x200**. The 640-wide ones show the same picture as the 320-wide ones, with twice the detail across: walls, sprites and the floors are drawn in 640 columns, the menus, status bar and other graphics at their size. In the 240-line ones (**320x240**, **640x240**) the game's view fills all 240 lines, from the top edge to the bottom one, with the status bar drawn over it at the *HUD (Bottom)* margin and the messages at the *HUD (Top)* one. The view shows what the original's full screen does, with its tall pixels as square ones, so nothing is stretched or squashed. The menus, title screens, the intermission and the finales keep their 200 lines in the middle of the screen. Applies at once. In 240 lines the view always fills the screen: the smaller screen sizes of the game's menu are the same as the one with the status bar. 640x240 is the heaviest: in the busiest scenes it can miss a picture (see Frame pacing) |
| FM Music | where the music is made: **FPGA** (default), on the YM3812 chip in the core, which the game only sends its register writes to, or **Software**, the game working the chip out on the ARM. Applies at once, so the two can be compared while the music plays |
| Cheats | **God Mode** (IDDQD), **No Clipping** (IDCLIP: through walls), **No Target** (the monsters do not notice you), each while it is on. **Infinite Ammo**: firing uses none. **Buddha**: you are hurt as always but never below 1% health. **Give All** (IDKFA): every weapon, full ammo, all keys and armor (in Heretic RAMBO, SKEL and GIMME: the artifacts as well; in Hexen NRA, LOCKSMITH and INDIANA: every weapon, full mana, armor, the keys and the artifacts, but not the puzzle items; in Strife BOOMSTIX, JIMMY and the backpack, keeping the Sigil you have). **Kill All Monsters** (in Strife STONECOLD: killing some of them sets off alarms, as it would if you killed them yourself). **Next Level**: the level counts as completed (in Strife RIFT to the map with the next number: Strife's maps are not in a row, so that can skip part of the story). **Full Map** (IDDT): each time the whole automap, then the things on it as well, then off again. Not in demos or multiplayer |

Crispy Doom's own options are in its menu, under *Options* and *Crispness*. Its uncapped frame rate is on: the game moves 35 times per second, as the original, and the pictures in between are drawn part of the way to the next move. High resolution, widescreen and vsync do nothing on the MiSTer: the core's resolutions are those of the OSD, and the picture always comes with the core's fields.

## Frame pacing

The game draws exactly one picture per field of the core, 59.64 per second ("60fps"), and its clock is the core's field counter, so each picture is the state of the game at the moment it is shown. Each picture is drawn one field ahead and shown at its own field: one that takes a little longer than a field is still in time, for one field (16.8ms) more latency. Measured on a DE10-Nano with Plutonia's first demo (12,600 pictures, MAP17), in 320x240: no picture missed its field this way, 32 without drawing ahead; in 320x200, none against 2; in 640x200, none against 121. In 640x240 a picture takes 12.7ms on average there (320x200 5.4ms, 640x200 9.2ms, 320x240 7.3ms) and up to 24ms, and 67 of the 12,300 pictures missed their field, 994 without drawing ahead: up to 16 in 5 seconds in the busiest parts of the map. Doom II's second demo (MAP11) has no misses in 640x240 (156 without drawing ahead). Heretic draws more per picture: its first demo (3,000 pictures) has none in 320x200, 1 in 320x240, 2 in 640x200 and 83 in 640x240; its second (5,100) 142 in 640x240, about 3%. For Heretic 320x200 or 320x240 is the steady 60. Hexen's first demo (4,500 pictures) misses 8 in 320x200 and in 320x240, 39 in 640x200 and about 7% in 640x240 (302 of 4,200): for Hexen 320x200 or 320x240. Strife's first demo (3,300) has none in 320x200 and 320x240, 4 in 640x200 and 56 in 640x240.

## Controls

- **Keyboard and mouse:**

| Key | Action |
|---|---|
| Arrows | move and turn |
| Ctrl | fire |
| Space | use (doors, switches) |
| Shift | run (held; Caps Lock: always run) |
| Alt + Left / Right, `,` / `.` | strafe |
| 1 to 7 | weapons |
| Tab | automap |
| Esc | menu |
| Mouse | turns; left button fires, right strafes, middle moves forward, the wheel changes weapon |

- **Gamepad** (default mapping):

| Button | Action |
|---|---|
| Left stick | move and strafe |
| Right stick | turn (and look up and down, with *Allow Free Look* on in Crispy's options) |
| D-pad | move and turn |
| A (Xbox B / PlayStation Circle) | run (held) |
| B (Xbox A / PlayStation Cross) | use (doors, switches) |
| X (Xbox Y / PlayStation Triangle) | previous weapon |
| Y (Xbox X / PlayStation Square) | next weapon |
| L (LB / L1) | strafe (held: the d-pad and the right stick strafe) |
| R (RB / R1), R2 | fire |
| L2 | run (held) |
| Select | automap |
| Start | Menu |

In Heretic, Hexen and Strife the d-pad is for the inventory, and the left stick moves:

| Button | Heretic | Hexen | Strife |
|---|---|---|---|
| D-pad Left / Right | choose an artifact | choose an artifact | choose an item |
| D-pad Down | use it | use it | use it |
| D-pad Up | fly up (with the Wings of Wrath) | fly up (with the Wings of Wrath) | the mission objectives (held) |
| L2 | fly down | fly down | run (held) |
| X (Xbox Y / PlayStation Triangle) | previous weapon | jump | jump |

In Hexen and Strife, Next Weapon alone goes round the weapons. The OSD's *Define CrispyDoom buttons* still calls the jump button *Prev Weapon*: its names are the same for all the games of the core.

On the keyboard Hexen and Strife have Crispy's keys: `[` / `]` choose an item, Enter uses it, `/` jumps in Hexen and `A` in Strife; in Strife `W` shows the mission objectives, `K` the keys, `Z` the inventory.

Strife asks for a name when a game starts (*Name your character*): an empty slot comes with **PLAYER 1** (2, 3...) filled in, so that *Menu OK* starts it; a keyboard can change it.

In the game's menus the buttons that confirm and go back are the ones of your MiSTer menu, whatever they do in the game: its *Menu OK* / *Menu Back* if you set them in *Define joystick buttons*, else its A / B. A controller never set up in MiSTer confirms and goes back as on its console: Cross / Circle on PlayStation, A / B on Xbox and on Nintendo.

Change the buttons in the OSD under *Define CrispyDoom buttons*. *Menu OK* and *Menu Back* there are only needed for a spare button without a game function. While the OSD is open, the game gets no input.

## Building

Everything builds in Docker on a Linux PC.

```sh
git clone --recursive https://github.com/ItsDanik/CrispyDoom_MiSTer.git
cd CrispyDoom_MiSTer
./build.sh              # ARM game binaries -> build/mister/src/crispy-doom, crispy-heretic, -hexen, -strife
./core/build_core.sh    # FPGA core (Quartus Lite 17.0.2) -> core/output_files/CrispyDoom.rbf
./package.sh            # release zip      -> dist/CrispyDoom_YYYYMMDD.zip
```

The toolchain image (Debian bullseye, glibc 2.31 to match the MiSTer) is built from `hybrid/toolchain/` on first use. The first build also downloads and builds SDL2, SDL2_mixer and SDL2_net.

### Repository layout

| Path | |
|---|---|
| `hybrid/` | submodule: [ItsDanik/Hybrid_MiSTer](https://github.com/ItsDanik/Hybrid_MiSTer), what all our hybrid ports share: the FPGA host module, the ARM side library, SDL2 drivers, the launcher (`danik_hybrid_ports.sh`), toolchain and conventions. See its README. |
| `core/` | FPGA core, based on [Template_MiSTer](https://github.com/MiSTer-devel/Template_MiSTer): `CrispyDoom.sv` (OSD and button names) around `hybrid/rtl/hybrid_host.sv` |
| `crispydoom/` | submodule: the game, branch `mister`, with the MiSTer changes |
| `package/` | files shipped in the release next to the binary (`danik_hybrid_launch.sh`, README), and `games.txt`: the games and their menu entries |
| `releases/` | release packages |

### Development notes

- `./build.sh host` builds the same game for the PC. It runs against `hybrid/tools/fakecore`, a stand-in for the FPGA core that takes scripted input and saves screenshots and audio:
  ```sh
  gcc -O2 -o build/host/fakecore hybrid/tools/fakecore.c
  build/host/fakecore /tmp/shm script.txt audio.raw &
  cd <data folder> && MISTER_HYBRID_SHM=/tmp/shm <repository>/build/host/src/crispy-doom
  ```
- `MISTER=root@<address> tools/test_on_mister.sh <id>` tries the build on a MiSTer next to what is installed there, without installing it: from `/tmp`, with the installed game's folder mirrored there (what the game writes stays in `/tmp`) and its own OSD settings. `list` and `nodata` for the core started by itself and without data, `log` for the game's log, `stop` to remove all of it again.
- `touch /tmp/crispydoom_nolaunch` on the MiSTer keeps the core loaded without starting the game, so you can start a development binary by hand (set `MISTER_HYBRID_CORE=CrispyDoom`, and `MISTER_HYBRID_SET` for a game's set name). `/tmp/danik_hybrid_ports.log` shows what the launcher daemon did.

## Support

If you enjoy this project, you can support my work on [Patreon](https://www.patreon.com/itsdanik).

## Credits

- **[Crispy Doom](https://github.com/fabiangreffrath/crispy-doom)** (and Crispy Heretic, Hexen and Strife) by Fabian Greffrath and contributors, based on **[Chocolate Doom](https://www.chocolate-doom.org)** by Simon Howard and contributors (Chocolate Strife: Strife reconstructed by James Haley and Samuel Villarreal), and on the Doom, Heretic and Hexen source code released by id Software and Raven Software.
- **[JTOPL](https://github.com/jotego/jtopl)** by Jose Tejada (jotego): the FM chip in the core. **[Nuked OPL3](https://github.com/nukeykt/Nuked-OPL3)** by nukeykt: the software one.
- **[SDL](https://libsdl.org)** by Sam Lantinga and contributors.
- **[MiSTer](https://github.com/MiSTer-devel)** by Sorgelig and the MiSTer-devel contributors: the framework and Template_MiSTer.
- **[MiSTer Frontier](https://github.com/MiSTerOrganize/MiSTer_Frontier)** by MiSTer Organize: thank you for the inspiration. Hybrid cores on the MiSTer, and the way their game is launched (a daemon that watches the loaded core and runs a script from its games folder), come from MiSTer Frontier. Our launcher is a separate implementation and does not need MiSTer Frontier installed.

This project and its maintainers are in no way associated with or endorsed by id Software, Raven Software, Rogue Entertainment, Nightdive Studios, Bethesda Softworks or ZeniMax Media. It does not include any game data.

## License

The top-level scripts, tools and documentation are licensed under the [GPL-3.0](LICENSE). The components keep their own licenses: the shared framework in `hybrid/` is GPL-3.0 except where its files say otherwise, Crispy Doom (`crispydoom/`) is GPL-2.0-or-later, SDL and the SDL drivers in `hybrid/sdl2` are zlib, the FPGA core and the MiSTer framework are GPL-2.0 (`core/LICENSE`, with the core's own sources GPL-2.0-or-later).
