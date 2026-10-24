# CrispyDoom for MiSTer: notes

How the port works and how it is built. For playing it, see the [README](README.md).

## Frame pacing

The game draws exactly one picture per field of the core, 59.64 per second ("60fps"), and its clock is the core's field counter, so each picture is the state of the game at the moment it is shown. Each picture is drawn one field ahead and shown at its own field: one that takes a little longer than a field is still in time, for one field (16.8ms) more latency. Measured on a DE10-Nano (2026-10-21), every picture was shown in its own field, none missed and none shown twice, in all four resolutions, in Plutonia's first demo (12,300 pictures, MAP17, the busiest we know), Doom II's second, Heretic's first and Strife's first. Hexen's first demo (4,500 pictures) has 4 missed in 320x200, 320x240 and 640x200, and 5 in 640x240. The drawing code is made for the MiSTer's ARM CPU, which halved the time a picture takes; in 640x240 the slowest pictures of Plutonia's demo still finish in time.

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
