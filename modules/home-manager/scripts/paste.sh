URL="https://p.thevirt.ru"

FILEPATH="$1"
FILENAME=$(basename -- "$FILEPATH")
EXTENSION="${FILENAME##*.}"

RESPONSE=$(curl --data-binary @${FILEPATH:-/dev/stdin} --url $URL)
PASTELINK="$URL$RESPONSE"
[ -z "$EXTENSION" ] && \
    OUT="$PASTELINK"|| \
    OUT="$PASTELINK.$EXTENSION"
echo $OUT | sed 's|/p/|/|' | wl-copy
