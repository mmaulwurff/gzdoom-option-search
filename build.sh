#!/bin/bash

#gzdoom=gzdoom
gzdoom=~/Documents/src/gzdoom-build/gzdoom

name=option-search
#iwad=~/Programs/Games/wads/doom/DOOM.WAD
#iwad=~/Programs/Games/wads/doom/HERETIC.WAD
#iwad=~/Programs/Games/wads/modules/game/chex3.wad
#iwad=~/Programs/Games/wads/doom/HEXEN.WAD
#iwad=~/Programs/Games/wads/doom/freedoom1.wad
#iwad=~/Programs/Games/wads/modules/game/square1.pk3
#iwad=~/Programs/Games/wads/modules/game/harm1.wad

rm -f $name.pk3 \
&& \
git log --date=short --pretty=format:"-%d %ad %s%n" | \
    grep -v "^$" | \
    sed "s/HEAD -> master, //" | \
    sed "s/, origin\/master//" | \
    sed "s/ (HEAD -> master)//" | \
    sed "s/ (origin\/master)//"  |\
    sed "s/- (tag: \(v\?[0-9.]*\))/\n\1\n-/" \
    > changelog.txt \
&& \
zip $name.pk3 \
    zscript/*.zs \
    *.txt \
    *.zs \
    *.md \
    language.* \
&& \
cp $name.pk3 $name-$(git describe --abbrev=0 --tags).pk3 \
&& \
$gzdoom -iwad $iwad \
        -file $name.pk3 "$1" "$2" \
        ~/Programs/Games/wads/maps/DOOMTEST.wad \
        +openmenu m8f_os_Menu \
        #-norun
