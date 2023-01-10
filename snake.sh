#!/usr/bin/env bash
# shellcheck disable=SC2172
# SC2172 -- Trapping signals by number is not... trap -l is ez

set -eEuo pipefail ignoreeof

shopt -s nocasematch

init()
{
len=3 speed=25
init_term
((y=rows/2)); ((x=COLUMNS/2))
}

init_term()
{
shopt -s checkwinsize; (:;:)
((rows=LINES-1))

printf '\e[?1049h\e[2J\e[?25l'
}

end(){ printf '\e[?1049l\e[?25h'&& exit; }

read_keys()
{
read -rsn1 -t"${foo:=1.5}"
[[ $REPLY == $'\e' ]]&& read -rsn2
key="${REPLY:=${key:-K}}"

case $1 in
  [1-9]) foo=".0$1";;
  10) foo=".${1}";;
  1[1-9]) foo=".${1#1}";;
  2[0-4]) foo="1.${1#2}";;
esac
}

rand_block()
{
((blockY=SRANDOM%rows)); ((blockX=SRANDOM%COLUMNS))

if (( blockY > rows )); then
  blockY="$rows"
elif (( blockY < 1 )); then
  blockY=1
fi

if (( blockX > COLUMNS )); then
  blockX="$COLUMNS"
elif (( blockX < 1 )); then
  blockX=1
fi

block="$blockY;$blockX"
printf '\e[%sH\e[41m \e[m' "${block[0]}"
}

draw_snake()
{
if (( y > rows )); then
  y=1
elif (( y < 1 )); then
  y="$rows"
elif (( x > COLUMNS )); then
  x=1
elif (( x < 1 )); then
  x="$COLUMNS"
fi

snake="$y;$x"
printf '\e[%sH\e[1;42m \e[m' "$snake"

snakeHist+=("$snake")
if (( len < ${i:=1} )); then
  printf '\e[%sH \e[m' "${snakeHist[0]}"
  snakeHist=("${snakeHist[@]:1}")
else ((++i)); fi
}

hud()
{
printf '\e[%dH\e[2K\e[40;1;32msnake\e[m Y:%d X:%d | length:%d speed:%d' \
  "$LINES" "$y" "$x" "$len" "$speed"
}

trap end 2
trap 'init_term; rand_block; hud' 28

init; rand_block; hud
for((;;)){
  read_keys "$speed"|| return
  case $key in
    H|\[D) ((x--));;
    J|\[B) ((y++));;
    K|\[A) ((y--));;
    L|\[C) ((x++));;
    R) init; rand_block; hud;;
    Q) end;;
    *) continue;;
  esac

  draw_snake

  [[ $block == "$snake" ]]&&{
    rand_block|| return
    ((len++))
    (( speed > 0 ))&& ((speed--))
  }

  hud
}
