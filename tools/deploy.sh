#!/bin/sh
# Package the build and copy it to a MiSTer over ssh, in the layout of the
# hybrid ports. The core is not (re)loaded: load a game of CrispyDoom from the
# Other menu afterwards. Run Scripts/danik_hybrid_ports.sh on the MiSTer
# once to set up the launcher. A MiSTer that has CrispyDoom in the old layout
# (games/CrispyDoom/) gets it moved by the launcher (version 3) once this is
# there.
# usage: MISTER=root@<address> tools/deploy.sh
set -e
cd "$(dirname "$0")/.."
HOST=${MISTER:?set MISTER=root@<address of the MiSTer>}
./package.sh > /dev/null
OUT=dist/CrispyDoom_$(date +%Y%m%d)
G=/media/fat/games/dnk/CrispyDoom
ssh "$HOST" "mkdir -p $G /media/fat/_Other/dnk /media/fat/Scripts/.danik_hybrid_ports && rm -f /media/fat/_Other/dnk/dnk-CrispyDoom_*.rbf"
# a running game keeps its binary busy: copy next to it, then swap
# (scp would copy into a folder of that name, if something left one behind)
for b in CrispyDoom CrispyHeretic CrispyHexen CrispyStrife; do
    ssh "$HOST" "rm -rf $G/$b.new"
    scp -q "$OUT/games/dnk/CrispyDoom/$b" "$HOST:$G/$b.new"
    ssh "$HOST" "mv -f $G/$b.new $G/$b"
done
# everything else of the package (user files on the MiSTer are left alone)
(cd "$OUT/games/dnk/CrispyDoom" && tar cf - --exclude=./CrispyDoom --exclude=./CrispyHeretic \
    --exclude=./CrispyHexen --exclude=./CrispyStrife .) | ssh "$HOST" "tar xf - --no-same-owner -C $G"
(cd "$OUT/Scripts" && tar cf - .) | ssh "$HOST" "tar xf - --no-same-owner -C /media/fat/Scripts"
(cd "$OUT/_Other" && tar cf - .) | ssh "$HOST" "tar xf - --no-same-owner -C /media/fat/_Other"
ssh "$HOST" "chmod +x $G/CrispyDoom $G/CrispyHeretic $G/CrispyHexen $G/CrispyStrife $G/*.sh /media/fat/Scripts/danik_hybrid_ports.sh; ls -la $G /media/fat/_Other/dnk/dnk-CrispyDoom_*.rbf /media/fat/_Other/dnk-*.mgl"
